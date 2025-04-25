import 'package:bcc5/utils/logger.dart';
import 'package:flutter/material.dart';

class TourStepData {
  final String id;
  final GlobalKey key;
  final String description;

  TourStepData({
    required this.id,
    required this.key,
    required this.description,
  });
}

class TourController extends ChangeNotifier {
  final List<TourStepData> _steps = [];
  final Map<String, GlobalKey> _stepKeys = {};

  int _currentStep = 0;

  int get currentStep => _currentStep;

  GlobalKey? get currentKey {
    final key =
        (_currentStep < _steps.length) ? _steps[_currentStep].key : null;
    logger.i('🎯 currentKey for step $_currentStep is $key');
    return key;
  }

  String? get currentDescription {
    final desc =
        (_currentStep < _steps.length)
            ? _steps[_currentStep].description
            : null;
    logger.i('📝 currentDescription for step $_currentStep is $desc');
    return desc;
  }

  String? get currentStepId {
    final id = (_currentStep < _steps.length) ? _steps[_currentStep].id : null;
    logger.i('🔖 currentStepId for step $_currentStep is $id');
    return id;
  }

  bool get isTourActive => _currentStep < _steps.length;

  GlobalKey getKeyForStep(String id) {
    return _stepKeys.putIfAbsent(id, () => GlobalKey(debugLabel: id));
  }

  void addStep({
    required String id,
    required GlobalKey key,
    required String description,
  }) {
    _stepKeys[id] = key;
    _steps.add(TourStepData(id: id, key: key, description: description));
  }

  void nextStep() {
    if (_currentStep < _steps.length - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void endTour() {
    logger.i('🛑 TourController.endTour() called');
    _currentStep = _steps.length;
    notifyListeners();
  }

  void reset() {
    logger.i('🔁 TourController.reset() triggered');
    _currentStep = 0;
    notifyListeners();
  }
}
