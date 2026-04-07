import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fasting_provider.dart';
import '../widgets/fasting_timer.dart';
import '../widgets/stats_card.dart';
import '../widgets/fasting_history.dart';
import 'body_progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildNavigationRail(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _buildCurrentPage()),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
      },
      labelType: NavigationRailLabelType.all,
      leading: FloatingActionButton(
        onPressed: () => _startNewFast(),
        child: const Icon(Icons.play_arrow),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Início'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart),
          label: Text('Estatísticas'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.history),
          selectedIcon: Icon(Icons.history),
          label: Text('Histórico'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Configurações'),
        ),
      ],
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildStatsTab();
      case 2:
        return const FastingHistoryWidget();
      case 3:
        return const Center(child: Text('Configurações'));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHomeTab() {
    return Consumer<FastingProvider>(
      builder: (context, provider, child) {
        final isFasting = provider.isFasting;
        final elapsedTime = provider.elapsedTime;
        final targetDuration = provider.targetDuration;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(provider),
              const SizedBox(height: 32),
              if (isFasting) ...[
                FastingTimerWidget(
                  elapsedTime: elapsedTime,
                  targetDuration: targetDuration,
                  onPause: provider.pauseFasting,
                  onResume: provider.resumeFasting,
                  onStop: provider.stopFasting,
                ),
                const SizedBox(height: 24),
                _buildProgressButton(provider),
              ] else ...[
                _buildStartFastCard(provider),
              ],
              const SizedBox(height: 32),
              StatsCard(
                totalFasts: provider.completedFasts.length,
                totalHours: provider.totalFastingHours,
                currentStreak: provider.currentStreak,
                longestStreak: provider.longestStreak,
              ),
              const SizedBox(height: 24),
              _buildQuickActions(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsTab() {
    return Consumer<FastingProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estatísticas Detalhadas',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              _buildStatsOverview(provider),
              const SizedBox(height: 24),
              _buildWeeklyChart(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(FastingProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${provider.userName}!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              provider.isFasting ? 'Em jejum agora' : 'Pronto para começar?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildProgressButton(FastingProvider provider) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BodyProgressScreen(
              elapsedTime: provider.elapsedTime,
              targetDuration: provider.targetDuration,
            ),
          ),
        );
      },
      icon: const Icon(Icons.visibility),
      label: const Text('Ver Progresso do Corpo'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildStartFastCard(FastingProvider provider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Começar Novo Jejum',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Selecione a duração do seu jejum:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildDurationChip('12h', const Duration(hours: 12), provider),
                _buildDurationChip('14h', const Duration(hours: 14), provider),
                _buildDurationChip('16h', const Duration(hours: 16), provider),
                _buildDurationChip('18h', const Duration(hours: 18), provider),
                _buildDurationChip('20h', const Duration(hours: 20), provider),
                _buildDurationChip('24h', const Duration(hours: 24), provider),
                _buildDurationChip('36h', const Duration(hours: 36), provider),
                _buildDurationChip('48h', const Duration(hours: 48), provider),
                _buildDurationChip('72h', const Duration(hours: 72), provider),
                _buildDurationChip('4 dias', const Duration(days: 4), provider),
                _buildDurationChip('5 dias', const Duration(days: 5), provider),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => provider.startFastingWithDuration(provider.selectedDuration),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar Jejum'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(
    String label,
    Duration duration,
    FastingProvider provider,
  ) {
    final isSelected = provider.selectedDuration == duration;
    
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          provider.setSelectedDuration(duration);
        }
      },
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildQuickActions(FastingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.water_drop,
                title: 'Registrar Água',
                color: Colors.blue,
                onTap: () => _showWaterDialog(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.restaurant,
                title: 'Quebrar Jejum',
                color: Colors.orange,
                onTap: () => _showBreakFastDialog(provider),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsOverview(FastingProvider provider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatItem(
          'Total de Jejuas',
          '${provider.completedFasts.length}',
          Icons.timer,
          Colors.green,
        ),
        _buildStatItem(
          'Horas Totais',
          '${provider.totalFastingHours.toInt()}h',
          Icons.schedule,
          Colors.blue,
        ),
        _buildStatItem(
          'Sequência Atual',
          '${provider.currentStreak}',
          Icons.local_fire_department,
          Colors.orange,
        ),
        _buildStatItem(
          'Maior Sequência',
          '${provider.longestStreak}',
          Icons.emoji_events,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(FastingProvider provider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jejuas na Semana',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Gráfico semanal disponível em breve',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startNewFast() {
    setState(() => _selectedIndex = 0);
  }

  void _showWaterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Água'),
        content: const Text('Quantos mL você bebeu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Água registrada!')),
              );
            },
            child: const Text('250 mL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Água registrada!')),
              );
            },
            child: const Text('500 mL'),
          ),
        ],
      ),
    );
  }

  void _showBreakFastDialog(FastingProvider provider) {
    if (!provider.isFasting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você não está em jejum atualmente')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quebrar Jejum'),
        content: Text(
          'Você jejuou por ${_formatDuration(provider.elapsedTime)}. Tem certeza que deseja parar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.stopFasting();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Jejum completado! Parabéns!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Quebrar Jejum'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
