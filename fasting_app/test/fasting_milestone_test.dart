import 'package:flutter_test/flutter_test.dart';
import 'package:fasting_app/models/fasting_milestone.dart';

void main() {
  group('FastingMilestone', () {
    test('deve calcular corretamente as horas decimais', () {
      const milestone = FastingMilestone(
        duration: Duration(hours: 12, minutes: 30),
        title: 'Teste',
        description: 'Descrição',
        benefits: [],
        affectedSystems: [],
      );

      expect(milestone.hours, equals(12.5));
    });

    test('deve criar milestone com duração de 24 horas', () {
      const milestone = FastingMilestone(
        duration: Duration(hours: 24),
        title: 'Reset Metabólico',
        description: 'Um dia completo',
        benefits: ['Benefício 1'],
        affectedSystems: [BodySystem.cells],
      );

      expect(milestone.duration.inHours, equals(24));
      expect(milestone.title, equals('Reset Metabólico'));
      expect(milestone.benefits.length, equals(1));
    });
  });

  group('BodySystem', () {
    test('deve ter todos os sistemas corporais definidos', () {
      expect(BodySystem.values.length, equals(8));
      expect(BodySystem.values.contains(BodySystem.brain), isTrue);
      expect(BodySystem.values.contains(BodySystem.liver), isTrue);
      expect(BodySystem.values.contains(BodySystem.heart), isTrue);
      expect(BodySystem.values.contains(BodySystem.cells), isTrue);
      expect(BodySystem.values.contains(BodySystem.immune), isTrue);
      expect(BodySystem.values.contains(BodySystem.gut), isTrue);
      expect(BodySystem.values.contains(BodySystem.muscles), isTrue);
      expect(BodySystem.values.contains(BodySystem.fat), isTrue);
    });

    test('deve ter nome e categoria para cada sistema', () {
      expect(BodySystem.brain.name, equals('Cérebro'));
      expect(BodySystem.brain.category, equals('Sistema Nervoso'));
      
      expect(BodySystem.heart.name, equals('Coração'));
      expect(BodySystem.heart.category, equals('Sistema Cardiovascular'));
      
      expect(BodySystem.liver.name, equals('Fígado'));
      expect(BodySystem.liver.category, equals('Sistema Digestivo'));
    });
  });

  group('FastingTimeline', () {
    test('deve ter todos os milestones definidos', () {
      expect(FastingTimeline.milestones.length, equals(11));
    });

    test('milestones devem estar em ordem crescente de duração', () {
      for (var i = 1; i < FastingTimeline.milestones.length; i++) {
        expect(
          FastingTimeline.milestones[i].duration.inMinutes,
          greaterThan(FastingTimeline.milestones[i - 1].duration.inMinutes),
        );
      }
    });

    test('primeiro milestone deve ser 12 horas', () {
      expect(FastingTimeline.milestones.first.duration.inHours, equals(12));
    });

    test('último milestone deve ser 5 dias', () {
      expect(FastingTimeline.milestones.last.duration.inDays, equals(5));
    });

    test('getMilestoneForDuration deve retornar null para 0 horas', () {
      final result = FastingTimeline.getMilestoneForDuration(Duration.zero);
      expect(result, isNull);
    });

    test('getMilestoneForDuration deve retornar 12h para 12 horas', () {
      final result = FastingTimeline.getMilestoneForDuration(
        const Duration(hours: 12),
      );
      expect(result, isNotNull);
      expect(result!.duration.inHours, equals(12));
    });

    test('getMilestoneForDuration deve retornar 16h para 17 horas', () {
      final result = FastingTimeline.getMilestoneForDuration(
        const Duration(hours: 17),
      );
      expect(result, isNotNull);
      expect(result!.duration.inHours, equals(16));
    });

    test('getMilestoneForDuration deve retornar 24h para 24 horas', () {
      final result = FastingTimeline.getMilestoneForDuration(
        const Duration(hours: 24),
      );
      expect(result, isNotNull);
      expect(result!.title, equals('Reset Metabólico Completo'));
    });

    test('getMilestoneForDuration deve retornar 72h para 3 dias', () {
      final result = FastingTimeline.getMilestoneForDuration(
        const Duration(days: 3),
      );
      expect(result, isNotNull);
      expect(result!.title, equals('Rejuvenescimento Celular'));
    });

    test('getMilestoneForDuration deve retornar 5 dias para 5 dias completos', () {
      final result = FastingTimeline.getMilestoneForDuration(
        const Duration(days: 5),
      );
      expect(result, isNotNull);
      expect(result!.title, equals('Renovação Total'));
    });

    test('getAchievedMilestones deve retornar lista vazia para 0 horas', () {
      final result = FastingTimeline.getAchievedMilestones(Duration.zero);
      expect(result, isEmpty);
    });

    test('getAchievedMilestones deve retornar 1 milestone para 12 horas', () {
      final result = FastingTimeline.getAchievedMilestones(
        const Duration(hours: 12),
      );
      expect(result.length, equals(1));
    });

    test('getAchievedMilestones deve retornar múltiplos milestones para 24 horas', () {
      final result = FastingTimeline.getAchievedMilestones(
        const Duration(hours: 24),
      );
      expect(result.length, greaterThan(1));
      expect(result.every((m) => m.duration.inHours <= 24), isTrue);
    });

    test('getProgress deve retornar 0 para 0 tempo', () {
      final progress = FastingTimeline.getProgress(
        Duration.zero,
        const Duration(hours: 16),
      );
      expect(progress, equals(0.0));
    });

    test('getProgress deve retornar 0.5 para metade do tempo', () {
      final progress = FastingTimeline.getProgress(
        const Duration(hours: 8),
        const Duration(hours: 16),
      );
      expect(progress, equals(0.5));
    });

    test('getProgress deve retornar 1.0 para tempo completo', () {
      final progress = FastingTimeline.getProgress(
        const Duration(hours: 16),
        const Duration(hours: 16),
      );
      expect(progress, equals(1.0));
    });

    test('getProgress deve retornar 1.0 para tempo excedido', () {
      final progress = FastingTimeline.getProgress(
        const Duration(hours: 20),
        const Duration(hours: 16),
      );
      expect(progress, equals(1.0));
    });

    test('milestone de 16h deve mencionar autofagia', () {
      final milestone16h = FastingTimeline.milestones.firstWhere(
        (m) => m.duration.inHours == 16,
      );
      expect(
        milestone16h.description.toLowerCase().contains('autofagia'),
        isTrue,
      );
    });

    test('milestone de 24h deve ter múltiplos sistemas afetados', () {
      final milestone24h = FastingTimeline.milestones.firstWhere(
        (m) => m.duration.inHours == 24,
      );
      expect(milestone24h.affectedSystems.length, greaterThan(3));
    });

    test('todos os milestones devem ter pelo menos um benefício', () {
      for (var milestone in FastingTimeline.milestones) {
        expect(milestone.benefits.isNotEmpty, isTrue,
            reason: 'Milestone ${milestone.title} não tem benefícios');
      }
    });

    test('todos os milestones devem ter pelo menos um sistema afetado', () {
      for (var milestone in FastingTimeline.milestones) {
        expect(milestone.affectedSystems.isNotEmpty, isTrue,
            reason: 'Milestone ${milestone.title} não tem sistemas afetados');
      }
    });
  });
}
