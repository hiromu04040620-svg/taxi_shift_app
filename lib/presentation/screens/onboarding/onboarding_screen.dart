import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/constants/shift_cycle_presets.dart';
import '../../../application/providers/onboarding_provider.dart';
import 'steps/step_select_preset.dart';
import 'steps/step_set_start_date.dart';
import 'steps/step_welcome.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  ShiftCyclePreset? _selectedPreset;

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  void _onCompleted() {
    ref.invalidate(isOnboardingCompletedProvider);
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return Scaffold(body: StepWelcome(onNext: _nextStep));
      case 1:
        return StepSelectPreset(
          onSelected: (preset) {
            setState(() {
              _selectedPreset = preset;
            });
            _nextStep();
          },
          onBack: _previousStep,
        );
      case 2:
        return StepSetStartDate(
          selectedPreset: _selectedPreset!,
          onBack: _previousStep,
          onCompleted: _onCompleted,
        );
      default:
        return const Scaffold(body: Center(child: Text('Invalid step')));
    }
  }
}
