class UserSettings {
  final int defaultFastingDuration;
  final List<int> favoriteFastingDurations;
  final bool notificationsEnabled;
  final String theme;

  UserSettings({
    this.defaultFastingDuration = 16,
    this.favoriteFastingDurations = const [12, 14, 16, 18, 20, 24],
    this.notificationsEnabled = true,
    this.theme = 'system',
  });

  UserSettings copyWith({
    int? defaultFastingDuration,
    List<int>? favoriteFastingDurations,
    bool? notificationsEnabled,
    String? theme,
  }) {
    return UserSettings(
      defaultFastingDuration: defaultFastingDuration ?? this.defaultFastingDuration,
      favoriteFastingDurations: favoriteFastingDurations ?? this.favoriteFastingDurations,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      theme: theme ?? this.theme,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultFastingDuration': defaultFastingDuration,
      'favoriteFastingDurations': favoriteFastingDurations,
      'notificationsEnabled': notificationsEnabled,
      'theme': theme,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      defaultFastingDuration: json['defaultFastingDuration'] ?? 16,
      favoriteFastingDurations: List<int>.from(json['favoriteFastingDurations'] ?? [12, 14, 16, 18, 20, 24]),
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      theme: json['theme'] ?? 'system',
    );
  }
}
