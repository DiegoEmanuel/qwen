import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fasting_session.dart';
import '../models/user_settings.dart';

class StorageService {
  static const String _sessionsKey = 'fasting_sessions';
  static const String _settingsKey = 'user_settings';
  static const String _currentSessionKey = 'current_session';

  Future<List<FastingSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getStringList(_sessionsKey) ?? [];
    return sessionsJson
        .map((json) => FastingSession.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveSession(FastingSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getSessions();
    sessions.add(session);
    final sessionsJson = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_sessionsKey, sessionsJson);
  }

  Future<void> updateSession(FastingSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      sessions[index] = session;
      final sessionsJson = sessions.map((s) => jsonEncode(s.toJson())).toList();
      await prefs.setStringList(_sessionsKey, sessionsJson);
    }
  }

  Future<FastingSession?> getCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_currentSessionKey);
    if (sessionJson != null) {
      return FastingSession.fromJson(jsonDecode(sessionJson));
    }
    return null;
  }

  Future<void> saveCurrentSession(FastingSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentSessionKey, jsonEncode(session.toJson()));
  }

  Future<void> clearCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentSessionKey);
  }

  Future<UserSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    if (settingsJson != null) {
      return UserSettings.fromJson(jsonDecode(settingsJson));
    }
    return UserSettings();
  }

  Future<void> saveSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  Future<int> getTotalFastingHours() async {
    final sessions = await getSessions();
    final completedSessions = sessions.where((s) => s.isCompleted).toList();
    int totalMinutes = 0;
    for (var session in completedSessions) {
      totalMinutes += session.elapsedDuration.inMinutes;
    }
    return totalMinutes ~/ 60;
  }

  Future<int> getCompletedSessionsCount() async {
    final sessions = await getSessions();
    return sessions.where((s) => s.isCompleted).length;
  }
}
