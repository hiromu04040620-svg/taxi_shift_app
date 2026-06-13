import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../application/providers/repositories_provider.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/revenue.dart';
import '../../../../domain/models/work_session.dart';
import '../../../providers/revenue_queries_provider.dart';
import '../../../providers/work_session_queries_provider.dart';
import '../../../utils/number_format.dart';
import '../../../widgets/labeled_text_field.dart';

class DailyEntrySheet extends ConsumerStatefulWidget {
  const DailyEntrySheet({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<DailyEntrySheet> createState() => _DailyEntrySheetState();
}

class _DailyEntrySheetState extends ConsumerState<DailyEntrySheet> {
  bool _isLoading = false;

  // Toggle Switches
  bool _isWorkSessionEnabled = true;
  bool _isRevenueEnabled = true;

  // WorkSession fields
  WorkSession? _existingSession;
  TimeOfDay _startTime = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  bool _endsNextDay = true;
  late TextEditingController _restMinutesController;
  late TextEditingController _sessionNoteController;

  // Revenue fields
  Revenue? _existingRevenue;
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
  late TextEditingController _revenueNoteController;

  @override
  void initState() {
    super.initState();
    _restMinutesController = TextEditingController(text: '180');
    _sessionNoteController = TextEditingController();

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
    _revenueNoteController = TextEditingController();

    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final sessionRepo = ref.read(workSessionsRepositoryProvider);
    final revenueRepo = ref.read(revenuesRepositoryProvider);

    final session = await sessionRepo.findByShiftDate(widget.date);
    final revenue = await revenueRepo.findByShiftDate(widget.date);

    if (mounted) {
      setState(() {
        _existingSession = session;
        _existingRevenue = revenue;

        // Determine switch states based on existing data
        if (session != null && revenue == null) {
          _isWorkSessionEnabled = true;
          _isRevenueEnabled = false;
        } else if (session == null && revenue != null) {
          _isWorkSessionEnabled = false;
          _isRevenueEnabled = true;
        } else {
          // both null or both exist -> both ON
          _isWorkSessionEnabled = true;
          _isRevenueEnabled = true;
        }

        // Populate WorkSession
        if (session != null) {
          _startTime = TimeOfDay.fromDateTime(session.startDateTime);
          _endTime = TimeOfDay.fromDateTime(session.endDateTime);
          _endsNextDay =
              session.endDateTime.difference(session.startDateTime).inHours >=
                  12 ||
              session.endDateTime.day != session.startDateTime.day;
          _restMinutesController.text = session.restMinutes.toString();
          _sessionNoteController.text = session.note ?? '';
        }

        // Populate Revenue
        if (revenue != null) {
          _grossController.text = revenue.grossRevenue.toString();
          _taxExcludedController.text = revenue.taxExcludedRevenue.toString();
          _cashController.text = revenue.cashAmount.toString();
          _cardController.text = revenue.cardAmount.toString();
          _appController.text = revenue.appAmount.toString();
          _ticketController.text = revenue.ticketAmount.toString();
          _totalDistanceController.text = revenue.totalDistance.toString();
          _occupiedDistanceController.text = revenue.occupiedDistance
              .toString();
          _ridesController.text = revenue.ridesCount.toString();
          if (revenue.fuelAmount != null) {
            _fuelController.text = revenue.fuelAmount.toString();
          }
          _revenueNoteController.text = revenue.note ?? '';
        }
      });
    }
  }

  @override
  void dispose() {
    _restMinutesController.dispose();
    _sessionNoteController.dispose();
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
    _revenueNoteController.dispose();
    super.dispose();
  }

  DateTime _buildDateTime(DateTime baseDate, TimeOfDay time, bool isNextDay) {
    var dt = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      time.hour,
      time.minute,
    );
    if (isNextDay) {
      dt = dt.add(const Duration(days: 1));
    }
    return dt;
  }

  void _unfocusWhenTappedOutside(PointerDownEvent event) {
    final currentFocus = FocusManager.instance.primaryFocus;
    final focusContext = currentFocus?.context;
    final renderObject = focusContext?.findRenderObject();

    if (renderObject is RenderBox) {
      final localPosition = renderObject.globalToLocal(event.position);
      if (renderObject.size.contains(localPosition)) {
        return;
      }
    }

    currentFocus?.unfocus();
  }

  void _selectTime(bool isStart) async {
    final initialTime = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!_isWorkSessionEnabled && !_isRevenueEnabled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('最低1つの記録を有効にしてください')));
      return;
    }

    final sessionRepo = ref.read(workSessionsRepositoryProvider);
    final revenueRepo = ref.read(revenuesRepositoryProvider);

    // Prepare WorkSession validation
    int? restMinutes;
    DateTime? startDt;
    DateTime? endDt;

    if (_isWorkSessionEnabled) {
      restMinutes = int.tryParse(_restMinutesController.text) ?? 180;
      startDt = _buildDateTime(widget.date, _startTime, false);
      endDt = _buildDateTime(widget.date, _endTime, _endsNextDay);

      if (startDt.isAfter(endDt) || startDt.isAtSameMomentAs(endDt)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('入庫時刻は出庫時刻より後にしてください')));
        return;
      }
    }

    // Prepare Revenue validation
    int? gross, taxExcluded, cash, card, app, ticket, rides, fuel;
    double? totalDist, occDist;

    if (_isRevenueEnabled) {
      gross = int.tryParse(_grossController.text.replaceAll(',', '')) ?? 0;
      taxExcluded =
          int.tryParse(_taxExcludedController.text.replaceAll(',', '')) ?? 0;
      cash = int.tryParse(_cashController.text.replaceAll(',', '')) ?? 0;
      card = int.tryParse(_cardController.text.replaceAll(',', '')) ?? 0;
      app = int.tryParse(_appController.text.replaceAll(',', '')) ?? 0;
      ticket = int.tryParse(_ticketController.text.replaceAll(',', '')) ?? 0;
      totalDist =
          double.tryParse(_totalDistanceController.text.replaceAll(',', '')) ??
          0.0;
      occDist =
          double.tryParse(
            _occupiedDistanceController.text.replaceAll(',', ''),
          ) ??
          0.0;
      rides = int.tryParse(_ridesController.text.replaceAll(',', '')) ?? 0;
      fuel = int.tryParse(_fuelController.text.replaceAll(',', ''));

      final innerSum = cash + card + app + ticket;
      if (gross > 0 && innerSum > 0 && innerSum != gross) {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('内訳にずれがあります'),
            content: Text(
              '売上内訳の合計（${AppNumberFormat.currency(innerSum)}）が税込総額（${AppNumberFormat.currency(gross!)}）と一致しません。このまま保存しますか？',
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
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Save WorkSession
      if (_isWorkSessionEnabled) {
        if (_existingSession != null) {
          await sessionRepo.update(
            _existingSession!.copyWith(
              startDateTime: startDt!,
              endDateTime: endDt!,
              restMinutes: restMinutes!,
              note: _sessionNoteController.text.trim().isEmpty
                  ? null
                  : _sessionNoteController.text.trim(),
            ),
          );
        } else {
          await sessionRepo.create(
            WorkSession(
              shiftDate: widget.date,
              startDateTime: startDt!,
              endDateTime: endDt!,
              restMinutes: restMinutes!,
              note: _sessionNoteController.text.trim().isEmpty
                  ? null
                  : _sessionNoteController.text.trim(),
            ),
          );
        }
        ref.invalidate(workSessionForDateProvider(widget.date));
        ref.invalidate(workSessionsInMonthProvider);
      }

      // Save Revenue
      if (_isRevenueEnabled) {
        if (_existingRevenue != null) {
          await revenueRepo.update(
            _existingRevenue!.copyWith(
              grossRevenue: gross!,
              taxExcludedRevenue: taxExcluded!,
              cashAmount: cash!,
              cardAmount: card!,
              appAmount: app!,
              ticketAmount: ticket!,
              totalDistance: totalDist!,
              occupiedDistance: occDist!,
              ridesCount: rides!,
              fuelAmount: fuel,
              note: _revenueNoteController.text.trim().isEmpty
                  ? null
                  : _revenueNoteController.text.trim(),
            ),
          );
        } else {
          await revenueRepo.create(
            Revenue(
              shiftDate: widget.date,
              grossRevenue: gross!,
              taxExcludedRevenue: taxExcluded!,
              cashAmount: cash!,
              cardAmount: card!,
              appAmount: app!,
              ticketAmount: ticket!,
              totalDistance: totalDist!,
              occupiedDistance: occDist!,
              ridesCount: rides!,
              fuelAmount: fuel,
              note: _revenueNoteController.text.trim().isEmpty
                  ? null
                  : _revenueNoteController.text.trim(),
            ),
          );
        }
        ref.invalidate(revenueForDateProvider(widget.date));
        ref.invalidate(revenuesInMonthProvider);
      }

      if (mounted) {
        Navigator.pop(context, true);
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

  Widget _buildWorkSessionSection(TextTheme textTheme) {
    if (!_isWorkSessionEnabled) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('出庫時刻', style: textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  OutlinedButton.icon(
                    onPressed: () => _selectTime(true),
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('入庫時刻', style: textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  OutlinedButton.icon(
                    onPressed: () => _selectTime(false),
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('翌日にまたぐ'),
            Switch(
              value: _endsNextDay,
              onChanged: (val) {
                setState(() {
                  _endsNextDay = val;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        LabeledTextField(
          label: '休憩時間',
          controller: _restMinutesController,
          keyboardType: TextInputType.number,
          suffix: '分',
        ),
        const SizedBox(height: AppSpacing.md),
        LabeledTextField(
          label: '勤務メモ',
          controller: _sessionNoteController,
          maxLines: 2,
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildRevenueSection(TextTheme textTheme) {
    if (!_isRevenueEnabled) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: LabeledTextField(
                label: '総営収（任意）',
                controller: _grossController,
                keyboardType: TextInputType.number,
                suffix: '円',
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
        Text('売上内訳', style: textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: LabeledTextField(
                label: '現金（任意）',
                controller: _cashController,
                keyboardType: TextInputType.number,
                suffix: '円',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: LabeledTextField(
                label: 'クレジット（任意）',
                controller: _cardController,
                keyboardType: TextInputType.number,
                suffix: '円',
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
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: LabeledTextField(
                label: 'チケット（任意）',
                controller: _ticketController,
                keyboardType: TextInputType.number,
                suffix: '円',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('運行データ', style: textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: LabeledTextField(
                label: '総走行距離（任意）',
                controller: _totalDistanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                suffix: 'km',
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
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const Expanded(child: SizedBox()),
          ],
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
          label: '売上メモ（任意）',
          controller: _revenueNoteController,
          maxLines: 2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dateLabel = DateFormat(
      'yyyy年M月d日 (E) の記録',
      'ja_JP',
    ).format(widget.date);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _unfocusWhenTappedOutside,
            child: Material(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Container(
                      width: 32,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.4,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    dateLabel,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.only(
                        left: AppSpacing.md,
                        right: AppSpacing.md,
                        top: AppSpacing.sm,
                        bottom: AppSpacing.xxl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // WorkSession Section Header
                          SwitchListTile(
                            title: Text(
                              '勤務記録を入力する',
                              style: textTheme.titleMedium,
                            ),
                            value: _isWorkSessionEnabled,
                            onChanged: (val) {
                              setState(() {
                                _isWorkSessionEnabled = val;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                          _buildWorkSessionSection(textTheme),

                          const Divider(),

                          // Revenue Section Header
                          SwitchListTile(
                            title: Text(
                              '売上記録を入力する',
                              style: textTheme.titleMedium,
                            ),
                            value: _isRevenueEnabled,
                            onChanged: (val) {
                              setState(() {
                                _isRevenueEnabled = val;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                          _buildRevenueSection(textTheme),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: AnimatedPadding(
            duration: AppAnimation.fast,
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text('キャンセル'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: _isLoading ? null : _save,
                      child: _isLoading
                          ? SizedBox.square(
                              dimension: AppIconSize.sm,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Text('保存'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
