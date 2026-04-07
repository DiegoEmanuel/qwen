import 'package:flutter_test/flutter_test.dart';
import '../lib/models/user_settings.dart';

void main() {
  group('UserSettings', () {
    test('deve criar configurações padrão corretamente', () {
      final settings = UserSettings();

      expect(settings.defaultFastingDuration, 16);
      expect(settings.favoriteFastingDurations, [12, 14, 16, 18, 20, 24]);
      expect(settings.notificationsEnabled, true);
      expect(settings.theme, 'system');
    });

    test('deve criar configurações personalizadas', () {
      final settings = UserSettings(
        defaultFastingDuration: 18,
        favoriteFastingDurations: [14, 16, 18],
        notificationsEnabled: false,
        theme: 'dark',
      );

      expect(settings.defaultFastingDuration, 18);
      expect(settings.favoriteFastingDurations, [14, 16, 18]);
      expect(settings.notificationsEnabled, false);
      expect(settings.theme, 'dark');
    });

    test('deve copiar configurações com alterações usando copyWith', () {
      final original = UserSettings(
        defaultFastingDuration: 16,
        favoriteFastingDurations: [12, 14, 16],
        notificationsEnabled: true,
        theme: 'system',
      );

      final updated = original.copyWith(
        defaultFastingDuration: 20,
        notificationsEnabled: false,
      );

      expect(updated.defaultFastingDuration, 20);
      expect(updated.favoriteFastingDurations, [12, 14, 16]);
      expect(updated.notificationsEnabled, false);
      expect(updated.theme, 'system');
    });

    test('deve serializar para JSON corretamente', () {
      final settings = UserSettings(
        defaultFastingDuration: 18,
        favoriteFastingDurations: [14, 16, 18, 20],
        notificationsEnabled: false,
        theme: 'light',
      );

      final json = settings.toJson();

      expect(json['defaultFastingDuration'], 18);
      expect(json['favoriteFastingDurations'], [14, 16, 18, 20]);
      expect(json['notificationsEnabled'], false);
      expect(json['theme'], 'light');
    });

    test('deve desserializar de JSON corretamente', () {
      final json = {
        'defaultFastingDuration': 18,
        'favoriteFastingDurations': [14, 16, 18, 20],
        'notificationsEnabled': false,
        'theme': 'dark',
      };

      final settings = UserSettings.fromJson(json);

      expect(settings.defaultFastingDuration, 18);
      expect(settings.favoriteFastingDurations, [14, 16, 18, 20]);
      expect(settings.notificationsEnabled, false);
      expect(settings.theme, 'dark');
    });

    test('deve usar valores padrão ao desserializar JSON incompleto', () {
      final json = <String, dynamic>{};

      final settings = UserSettings.fromJson(json);

      expect(settings.defaultFastingDuration, 16);
      expect(settings.favoriteFastingDurations, [12, 14, 16, 18, 20, 24]);
      expect(settings.notificationsEnabled, true);
      expect(settings.theme, 'system');
    });

    test('deve manter lista imutável nas configurações padrão', () {
      final settings1 = UserSettings();
      final settings2 = UserSettings();

      // Verifica que as listas são instâncias separadas
      expect(identical(settings1.favoriteFastingDurations, settings2.favoriteFastingDurations), isFalse);
    });
  });
}
