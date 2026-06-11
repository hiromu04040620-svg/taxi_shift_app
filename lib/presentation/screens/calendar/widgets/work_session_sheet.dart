import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../application/providers/repositories_provider.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/work_session.dart';
import '../../../providers/improvement_warnings_provider.dart';
import '../../../providers/work_session_queries_provider.dart';
import '../../../widgets/labeled_text_field.dart';

class WorkSessionSheet extends ConsumerStatefulWidget {
  const WorkSessionSheet({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<WorkSessionSheet> createState() => _WorkSessionSheetState();
}

class _WorkSessionSheetState extends ConsumerState<WorkSessionSheet> {
  WorkSession? _existing;
  TimeOfDay _startTime = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  bool _endsNextDay = true;
  late TextEditingController _restMinutesController;
  late TextEditingController _noteController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _restMinutesController = TextEditingController(text: '180');
    _noteController = TextEditingController();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final repo = ref.read(workSessionsRepositoryProvider);
    final existing = await repo.findByShiftDate(widget.date);
    if (mounted && existing != null) {
      setState(() {
        _existing = existing;
        _startTime = TimeOfDay.fromDateTime(existing.startDateTime);
        _endTime = TimeOfDay.fromDateTime(existing.endDateTime);
        _endsNextDay =
            existing.endDateTime.difference(existing.startDateTime).inHours >=
                12 ||
            existing.endDateTime.day != existing.startDateTime.day;
        _restMinutesController.text = existing.restMinutes.toString();
        _noteController.text = existing.note ?? '';
      });
    }
  }

  @override
  void dispose() {
    _restMinutesController.dispose();
    _noteController.dispose();
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

  Future<void> _save() async {
    setState(() {
      _isLoading = true;
    });

    final restMinutes = int.tryParse(_restMinutesController.text) ?? 180;
    final startDt = _buildDateTime(widget.date, _startTime, false);
    final endDt = _buildDateTime(widget.date, _endTime, _endsNextDay);

    try {
      final repo = ref.read(workSessionsRepositoryProvider);
      if (_existing != null) {
        final updated = _existing!.copyWith(
          startDateTime: startDt,
          endDateTime: endDt,
          restMinutes: restMinutes,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
        await repo.update(updated);
      } else {
        final newSession = WorkSession(
          shiftDate: widget.date,
          startDateTime: startDt,
          endDateTime: endDt,
          restMinutes: restMinutes,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
        await repo.create(newSession);
      }

      ref.invalidate(workSessionForDateProvider(widget.date));
      ref.invalidate(workSessionsInMonthProvider);
      ref.invalidate(sessionWarningsProvider(widget.date));

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
      final repo = ref.read(workSessionsRepositoryProvider);
      await repo.delete(_existing!.id!);

      ref.invalidate(workSessionForDateProvider(widget.date));
      ref.invalidate(workSessionsInMonthProvider);
      ref.invalidate(sessionWarningsProvider(widget.date));

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dateLabel = DateFormat('M月d日の乗務記録', 'ja_JP').format(widget.date);

    final startDt = _buildDateTime(widget.date, _startTime, false);
    final endDt = _buildDateTime(widget.date, _endTime, _endsNextDay);
    final durationMinutes = endDt.difference(startDt).inMinutes;
    final restMinutes = int.tryParse(_restMinutesController.text) ?? 0;
    final workMinutes = durationMinutes - restMinutes;

    final durationHours = durationMinutes ~/ 60;
    final durationMins = durationMinutes % 60;
    final workHours = workMinutes ~/ 60;
    final workMins = workMinutes % 60;

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
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          LabeledTextField(
            label: 'メモ',
            controller: _noteController,
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            margin: EdgeInsets.zero,
            color: durationHours > 21
                ? colorScheme.errorContainer
                : colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '拘束時間: $durationHours時間$durationMins分 (実働: $workHours時間$workMins分)',
                    style: textTheme.bodySmall?.copyWith(
                      color: durationHours > 21
                          ? colorScheme.onErrorContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (durationHours > 21)
                    Text(
                      '改善基準告示: 拘束時間が21時間を超過しています',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
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
