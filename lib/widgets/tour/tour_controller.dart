import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';

class TourController extends ChangeNotifier {
  final List<GlobalKey> steps;
  final Map<String, GlobalKey> _stepKeys = {}; // ✅

  int _currentStep = 0;

  TourController({required this.steps});

  int get currentStep => _currentStep;
  GlobalKey? get currentKey {
    final key = (_currentStep < steps.length) ? steps[_currentStep] : null;
    logger.i('🎯 currentKey for step $_currentStep is $key');
    return key;
  }

  bool get isTourActive => _currentStep < steps.length;

  GlobalKey getKeyForStep(String id) {
    return _stepKeys.putIfAbsent(id, () => GlobalKey());
  }

  void addStep({
    required String id,
    required GlobalKey key,
    required String description,
  }) {
    _stepKeys[id] = key;
    // You can later store description or metadata if needed
  }

  void nextStep() {
    if (_currentStep < steps.length - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void endTour() {
    logger.i('🛑 TourController.endTour() called');
    _currentStep = steps.length;
    notifyListeners();
  }

  void reset() {
    _currentStep = 0;
    notifyListeners();
  }
}
