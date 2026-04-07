import 'package:flutter_test/flutter_test.dart';
import '../lib/models/fasting_session.dart';

void main() {
  group('FastingSession', () {
    test('deve criar uma sessão de jejum com os parâmetros corretos', () {
      final session = FastingSession(
        id: 'test-id',
        startTime: DateTime(2024, 1, 1, 8, 0),
        targetDurationHours: 16,
        isCompleted: false,
      );

      expect(session.id, 'test-id');
      expect(session.startTime, DateTime(2024, 1, 1, 8, 0));
      expect(session.targetDurationHours, 16);
      expect(session.isCompleted, false);
      expect(session.endTime, null);
    });

    test('deve calcular a duração decorrida corretamente', () {
      final startTime = DateTime.now().subtract(const Duration(hours: 5));
      final session = FastingSession(
        id: 'test-id',
        startTime: startTime,
        targetDurationHours: 16,
        isCompleted: false,
      );

      final elapsed = session.elapsedDuration;
      expect(elapsed.inHours, greaterThanOrEqualTo(4));
      expect(elapsed.inHours, lessThanOrEqualTo(6));
    });

    test('deve calcular a duração decorrida com endTime definido', () {
      final startTime = DateTime(2024, 1, 1, 8, 0);
      final endTime = DateTime(2024, 1, 1, 20, 0);
      final session = FastingSession(
        id: 'test-id',
        startTime: startTime,
        endTime: endTime,
        targetDurationHours: 16,
        isCompleted: true,
      );

      expect(session.elapsedDuration.inHours, 12);
    });

    test('deve calcular a duração restante corretamente', () {
      final startTime = DateTime.now().subtract(const Duration(hours: 10));
      final session = FastingSession(
        id: 'test-id',
        startTime: startTime,
        targetDurationHours: 16,
        isCompleted: false,
      );

      final remaining = session.remainingDuration;
      expect(remaining.inHours, greaterThanOrEqualTo(5));
      expect(remaining.inHours, lessThanOrEqualTo(7));
    });

    test('deve retornar zero para duração restante quando completado', () {
      final session = FastingSession(
        id: 'test-id',
        startTime: DateTime.now().subtract(const Duration(hours: 20)),
        targetDurationHours: 16,
        isCompleted: true,
        endTime: DateTime.now(),
      );

      expect(session.remainingDuration, Duration.zero);
    });

    test('deve calcular a porcentagem de progresso corretamente', () {
      final startTime = DateTime.now().subtract(const Duration(hours: 8));
      final session = FastingSession(
        id: 'test-id',
        startTime: startTime,
        targetDurationHours: 16,
        isCompleted: false,
      );

      final progress = session.progressPercentage;
      expect(progress, greaterThanOrEqualTo(0.4));
      expect(progress, lessThanOrEqualTo(0.6));
    });

    test('deve limitar a porcentagem de progresso a 1.0 no máximo', () {
      final startTime = DateTime.now().subtract(const Duration(hours: 20));
      final session = FastingSession(
        id: 'test-id',
        startTime: startTime,
        targetDurationHours: 16,
        isCompleted: false,
      );

      expect(session.progressPercentage, equals(1.0));
    });

    test('deve copiar sessão com alterações usando copyWith', () {
      final original = FastingSession(
        id: 'test-id',
        startTime: DateTime(2024, 1, 1, 8, 0),
        targetDurationHours: 16,
        isCompleted: false,
      );

      final updated = original.copyWith(
        endTime: DateTime(2024, 1, 1, 20, 0),
        isCompleted: true,
      );

      expect(updated.id, 'test-id');
      expect(updated.startTime, DateTime(2024, 1, 1, 8, 0));
      expect(updated.endTime, DateTime(2024, 1, 1, 20, 0));
      expect(updated.targetDurationHours, 16);
      expect(updated.isCompleted, true);
    });

    test('deve serializar para JSON corretamente', () {
      final session = FastingSession(
        id: 'test-id',
        startTime: DateTime(2024, 1, 1, 8, 0),
        endTime: DateTime(2024, 1, 1, 20, 0),
        targetDurationHours: 16,
        isCompleted: true,
      );

      final json = session.toJson();
      
      expect(json['id'], 'test-id');
      expect(json['startTime'], '2024-01-01T08:00:00.000');
      expect(json['endTime'], '2024-01-01T20:00:00.000');
      expect(json['targetDurationHours'], 16);
      expect(json['isCompleted'], true);
    });

    test('deve desserializar de JSON corretamente', () {
      final json = {
        'id': 'test-id',
        'startTime': '2024-01-01T08:00:00.000',
        'endTime': '2024-01-01T20:00:00.000',
        'targetDurationHours': 16,
        'isCompleted': true,
      };

      final session = FastingSession.fromJson(json);

      expect(session.id, 'test-id');
      expect(session.startTime, DateTime(2024, 1, 1, 8, 0));
      expect(session.endTime, DateTime(2024, 1, 1, 20, 0));
      expect(session.targetDurationHours, 16);
      expect(session.isCompleted, true);
    });

    test('deve desserializar JSON com endTime nulo', () {
      final json = {
        'id': 'test-id',
        'startTime': '2024-01-01T08:00:00.000',
        'endTime': null,
        'targetDurationHours': 16,
        'isCompleted': false,
      };

      final session = FastingSession.fromJson(json);

      expect(session.id, 'test-id');
      expect(session.startTime, DateTime(2024, 1, 1, 8, 0));
      expect(session.endTime, null);
      expect(session.targetDurationHours, 16);
      expect(session.isCompleted, false);
    });
  });
}
