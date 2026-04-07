import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/fasting_session.dart';
import '../models/user_settings.dart';
import '../services/storage_service.dart';

class FastingProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  FastingSession? _currentSession;
  UserSettings _settings = UserSettings();
  List<FastingSession> _history = [];
  bool _isLoading = false;

  FastingSession? get currentSession => _currentSession;
  UserSettings get settings => _settings;
  List<FastingSession> get history => _history;
  bool get isLoading => _isLoading;

  bool get isFasting => _currentSession != null && !_currentSession!.isCompleted;

  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentSession = await _storageService.getCurrentSession();
      _settings = await _storageService.getSettings();
      _history = await _storageService.getSessions();
      
      // Ordenar por data, mais recente primeiro
      _history.sort((a, b) => b.startTime.compareTo(a.startTime));
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> startFasting(int durationHours) async {
    final session = FastingSession(
      id: const Uuid().v4(),
      startTime: DateTime.now(),
      targetDurationHours: durationHours,
      isCompleted: false,
    );

    _currentSession = session;
    await _storageService.saveCurrentSession(session);
    notifyListeners();
  }

  Future<void> stopFasting() async {
    if (_currentSession == null) return;

    final completedSession = _currentSession!.copyWith(
      endTime: DateTime.now(),
      isCompleted: true,
    );

    await _storageService.saveSession(completedSession);
    await _storageService.clearCurrentSession();
    
    _history.insert(0, completedSession);
    _currentSession = null;
    notifyListeners();
  }

  Future<void> updateSettings(UserSettings newSettings) async {
    _settings = newSettings;
    await _storageService.saveSettings(newSettings);
    notifyListeners();
  }

  Duration get elapsedDuration {
    if (_currentSession == null) return Duration.zero;
    return _currentSession!.elapsedDuration;
  }

  Duration get remainingDuration {
    if (_currentSession == null) return Duration.zero;
    return _currentSession!.remainingDuration;
  }

  double get progressPercentage {
    if (_currentSession == null) return 0.0;
    return _currentSession!.progressPercentage;
  }

  String get formattedElapsed {
    final duration = elapsedDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedRemaining {
    final duration = remainingDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m restantes';
  }

  Future<int> getTotalFastingHours() async {
    return await _storageService.getTotalFastingHours();
  }

  Future<int> getCompletedSessionsCount() async {
    return await _storageService.getCompletedSessionsCount();
  }
}
