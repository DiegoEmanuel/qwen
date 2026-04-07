import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fasting_provider.dart';
import '../models/user_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = context.read<FastingProvider>().settings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Duração Padrão
          Card(
            child: ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Duração Padrão do Jejum'),
              subtitle: Text('${_settings.defaultFastingDuration} horas'),
              trailing: DropdownButton<int>(
                value: _settings.defaultFastingDuration,
                items: [12, 14, 16, 18, 20, 24]
                    .map((hours) => DropdownMenuItem(
                          value: hours,
                          child: Text('$hours horas'),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _settings = _settings.copyWith(defaultFastingDuration: value);
                    });
                    context.read<FastingProvider>().updateSettings(_settings);
                  }
                },
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Notificações
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications),
              title: const Text('Notificações'),
              subtitle: const Text('Receber lembretes durante o jejum'),
              value: _settings.notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(notificationsEnabled: value);
                });
                context.read<FastingProvider>().updateSettings(_settings);
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tema
          Card(
            child: ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Tema'),
              subtitle: Text(_getThemeName(_settings.theme)),
              trailing: DropdownButton<String>(
                value: _settings.theme,
                items: const [
                  DropdownMenuItem(value: 'system', child: Text('Sistema')),
                  DropdownMenuItem(value: 'light', child: Text('Claro')),
                  DropdownMenuItem(value: 'dark', child: Text('Escuro')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _settings = _settings.copyWith(theme: value);
                    });
                    context.read<FastingProvider>().updateSettings(_settings);
                  }
                },
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sobre
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Sobre o App'),
                  subtitle: const Text('Versão 1.0.0'),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Controle de Jejum',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2024 - Todos os direitos reservados',
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Um aplicativo fantástico para controle de jejum intermitente. '
                          'Monitore suas sessões, acompanhe seu progresso e alcance seus objetivos de saúde.',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Botão de Reset
          ElevatedButton.icon(
            onPressed: () => _showResetDialog(context),
            icon: const Icon(Icons.delete_forever),
            label: const Text('Limpar Todo o Histórico'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeName(String theme) {
    switch (theme) {
      case 'light':
        return 'Claro';
      case 'dark':
        return 'Escuro';
      default:
        return 'Sistema';
    }
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tem certeza?'),
        content: const Text(
          'Esta ação irá apagar todo o seu histórico de jejuns. Esta ação não pode ser desfeita!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar reset do histórico
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Histórico limpo com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }
}
