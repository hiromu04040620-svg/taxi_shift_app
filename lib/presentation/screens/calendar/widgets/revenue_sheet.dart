import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../application/providers/repositories_provider.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/revenue.dart';
import '../../../providers/revenue_queries_provider.dart';
import '../../../providers/work_session_queries_provider.dart';
import '../../../utils/number_format.dart';
import '../../../widgets/labeled_text_field.dart';

class RevenueSheet extends ConsumerStatefulWidget {
  const RevenueSheet({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<RevenueSheet> createState() => _RevenueSheetState();
}

class _RevenueSheetState extends ConsumerState<RevenueSheet> {
  Revenue? _existing;
  late TextEditingController _grossController;
  late TextEditingController _taxExcludedController;
  late TextEditingController _cashController;
  late TextEditingController _cardController;
  late TextEditingController _appController;
  late TextEditingController _ticketController;
  late TextEditingController _totalDistanceController;
  late TextEditingController _occupiedDistanceController;
  late TextEditingController _ridesController;
  late TextEditingController _fuelController;
  late TextEditingController _noteController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _grossController = TextEditingController();
    _taxExcludedController = TextEditingController();
    _cashController = TextEditingController();
    _cardController = TextEditingController();
    _appController = TextEditingController();
    _ticketController = TextEditingController();
    _totalDistanceController = TextEditingController();
    _occupiedDistanceController = TextEditingController();
    _ridesController = TextEditingController();
    _fuelController = TextEditingController();
    _noteController = TextEditingController();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final repo = ref.read(revenuesRepositoryProvider);
    final existing = await repo.findByShiftDate(widget.date);
    if (mounted && existing != null) {
      setState(() {
        _existing = existing;
        _grossController.text = existing.grossRevenue.toString();
        _taxExcludedController.text = existing.taxExcludedRevenue.toString();
        _cashController.text = existing.cashAmount.toString();
        _cardController.text = existing.cardAmount.toString();
        _appController.text = existing.appAmount.toString();
        _ticketController.text = existing.ticketAmount.toString();
        _totalDistanceController.text = existing.totalDistance.toString();
        _occupiedDistanceController.text = existing.occupiedDistance.toString();
        _ridesController.text = existing.ridesCount.toString();
        if (existing.fuelAmount != null) {
          _fuelController.text = existing.fuelAmount.toString();
        }
        _noteController.text = existing.note ?? '';
      });
    }
  }

  @override
  void dispose() {
    _grossController.dispose();
    _taxExcludedController.dispose();
    _cashController.dispose();
    _cardController.dispose();
    _appController.dispose();
    _ticketController.dispose();
    _totalDistanceController.dispose();
    _occupiedDistanceController.dispose();
    _ridesController.dispose();
    _fuelController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onGrossChanged(String value) {
    setState(() {});
  }

  void _onGrossUnfocus() {
    final gross = int.tryParse(_grossController.text);
    if (gross != null && _taxExcludedController.text.isEmpty) {
      final taxExcluded = (gross / 1.1).round();
      setState(() {
        _taxExcludedController.text = taxExcluded.toString();
      });
    }
  }

  void _onInnerAmountChanged(String value) {
    setState(() {});
  }

  Future<void> _save() async {
    final gross = int.tryParse(_grossController.text.replaceAll(',', '')) ?? 0;
    final taxExcluded =
        int.tryParse(_taxExcludedController.text.replaceAll(',', '')) ?? 0;
    final cash = int.tryParse(_cashController.text.replaceAll(',', '')) ?? 0;
    final card = int.tryParse(_cardController.text.replaceAll(',', '')) ?? 0;
    final app = int.tryParse(_appController.text.replaceAll(',', '')) ?? 0;
    final ticket =
        int.tryParse(_ticketController.text.replaceAll(',', '')) ?? 0;
    final totalDist =
        double.tryParse(_totalDistanceController.text.replaceAll(',', '')) ??
        0.0;
    final occDist =
        double.tryParse(_occupiedDistanceController.text.replaceAll(',', '')) ??
        0.0;
    final rides = int.tryParse(_ridesController.text.replaceAll(',', '')) ?? 0;
    final fuel = int.tryParse(_fuelController.text.replaceAll(',', ''));

    final numericSum =
        gross +
        taxExcluded +
        cash +
        card +
        app +
        ticket +
        totalDist +
        occDist +
        rides +
        (fuel ?? 0);

    if (numericSum == 0 && _noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('最低1項目は入力してください')));
      return;
    }

    final innerSum = cash + card + app + ticket;
    if (gross > 0 && innerSum > 0 && innerSum != gross) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('内訳にずれがあります'),
          content: Text(
            '内訳の合計（${AppNumberFormat.currency(innerSum)}）が税込総額（${AppNumberFormat.currency(gross)}）と一致しません。このまま保存しますか？',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('修正する'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('このまま保存'),
            ),
          ],
        ),
      );
      if (confirm != true) {
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final sessionAsync = ref.read(workSessionForDateProvider(widget.date));
      final sessionId = sessionAsync.value?.id;

      final repo = ref.read(revenuesRepositoryProvider);

      if (_existing != null) {
        final updated = _existing!.copyWith(
          workSessionId: sessionId,
          grossRevenue: gross,
          taxExcludedRevenue: taxExcluded,
          cashAmount: cash,
          cardAmount: card,
          appAmount: app,
          ticketAmount: ticket,
          totalDistance: totalDist,
          occupiedDistance: occDist,
          ridesCount: rides,
          fuelAmount: fuel,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
        await repo.update(updated);
      } else {
        final newRevenue = Revenue(
          shiftDate: widget.date,
          workSessionId: sessionId,
          grossRevenue: gross,
          taxExcludedRevenue: taxExcluded,
          cashAmount: cash,
          cardAmount: card,
          appAmount: app,
          ticketAmount: ticket,
          totalDistance: totalDist,
          occupiedDistance: occDist,
          ridesCount: rides,
          fuelAmount: fuel,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
        await repo.create(newRevenue);
      }

      ref.invalidate(revenueForDateProvider(widget.date));
      ref.invalidate(revenuesInMonthProvider);
      ref.invalidate(monthlySummaryProvider);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Invalid argument(s): ', '')),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _delete() async {
    if (_existing?.id == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final repo = ref.read(revenuesRepositoryProvider);
      await repo.delete(_existing!.id!);

      ref.invalidate(revenueForDateProvider(widget.date));
      ref.invalidate(revenuesInMonthProvider);
      ref.invalidate(monthlySummaryProvider);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dateLabel = DateFormat('M月d日の売上', 'ja_JP').format(widget.date);

    final gross = int.tryParse(_grossController.text.replaceAll(',', '')) ?? 0;
    final cash = int.tryParse(_cashController.text.replaceAll(',', '')) ?? 0;
    final card = int.tryParse(_cardController.text.replaceAll(',', '')) ?? 0;
    final app = int.tryParse(_appController.text.replaceAll(',', '')) ?? 0;
    final ticket =
        int.tryParse(_ticketController.text.replaceAll(',', '')) ?? 0;
    final innerSum = cash + card + app + ticket;
    final diff = innerSum - gross;

    final totalDist = double.tryParse(_totalDistanceController.text) ?? 0.0;
    final occDist = double.tryParse(_occupiedDistanceController.text) ?? 0.0;
    final occRate = totalDist > 0
        ? (occDist / totalDist * 100).toStringAsFixed(1)
        : '0.0';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            dateLabel,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  '営収',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) _onGrossUnfocus();
                        },
                        child: LabeledTextField(
                          label: '総営収（任意）',
                          controller: _grossController,
                          keyboardType: TextInputType.number,
                          suffix: '円',
                          onChanged: _onGrossChanged,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: LabeledTextField(
                        label: '税抜営収（任意）',
                        controller: _taxExcludedController,
                        keyboardType: TextInputType.number,
                        suffix: '円',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ExpansionTile(
                  title: const Text('内訳'),
                  subtitle: Text(
                    '合計: ${AppNumberFormat.currency(innerSum)} (差額: ${diff > 0 ? '+' : ''}${AppNumberFormat.currency(diff)})',
                    style: TextStyle(
                      color: diff != 0
                          ? colorScheme.error
                          : colorScheme.primary,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                  ),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            label: '現金（任意）',
                            controller: _cashController,
                            keyboardType: TextInputType.number,
                            suffix: '円',
                            onChanged: _onInnerAmountChanged,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: LabeledTextField(
                            label: 'クレジット（任意）',
                            controller: _cardController,
                            keyboardType: TextInputType.number,
                            suffix: '円',
                            onChanged: _onInnerAmountChanged,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: LabeledTextField(
                            label: '配車アプリ（任意）',
                            controller: _appController,
                            keyboardType: TextInputType.number,
                            suffix: '円',
                            onChanged: _onInnerAmountChanged,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: LabeledTextField(
                            label: 'チケット（任意）',
                            controller: _ticketController,
                            keyboardType: TextInputType.number,
                            suffix: '円',
                            onChanged: _onInnerAmountChanged,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '走行',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: LabeledTextField(
                        label: '総走行距離（任意）',
                        controller: _totalDistanceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        suffix: 'km',
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: LabeledTextField(
                        label: '実車距離（任意）',
                        controller: _occupiedDistanceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        suffix: 'km',
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: LabeledTextField(
                        label: '乗車回数（任意）',
                        controller: _ridesController,
                        keyboardType: TextInputType.number,
                        suffix: '回',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          '実車率: $occRate %',
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'その他',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                LabeledTextField(
                  label: '給油額（任意）',
                  controller: _fuelController,
                  keyboardType: TextInputType.number,
                  suffix: '円',
                ),
                const SizedBox(height: AppSpacing.sm),
                LabeledTextField(
                  label: 'メモ（任意）',
                  controller: _noteController,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              if (_existing != null)
                OutlinedButton(
                  onPressed: _isLoading ? null : _delete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                  ),
                  child: const Text('削除'),
                ),
              const Spacer(),
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text('キャンセル'),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('保存'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
