import 'package:flutter/material.dart';
import '../models/fasting_milestone.dart';

class BodyProgressScreen extends StatefulWidget {
  final Duration elapsedTime;
  final Duration targetDuration;

  const BodyProgressScreen({
    super.key,
    required this.elapsedTime,
    required this.targetDuration,
  });

  @override
  State<BodyProgressScreen> createState() => _BodyProgressScreenState();
}

class _BodyProgressScreenState extends State<BodyProgressScreen> {
  BodySystem? _selectedSystem;
  PageController? _pageController;
  int _currentPage = 0;

  List<FastingMilestone> get _achievedMilestones =>
      FastingTimeline.getAchievedMilestones(widget.elapsedTime);

  FastingMilestone? get _currentMilestone =>
      FastingTimeline.getMilestoneForDuration(widget.elapsedTime);

  double get _overallProgress =>
      FastingTimeline.getProgress(widget.elapsedTime, widget.targetDuration);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _onSystemTap() {
    setState(() {});
  }

  void _selectSystem(BodySystem system) {
    setState(() {
      _selectedSystem = _selectedSystem == system ? null : system;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade900,
              Colors.grey.shade800,
              Colors.blueGrey.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildBodyVisualization(),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildBenefitsPanel(),
                    ),
                  ],
                ),
              ),
              _buildMilestoneCarousel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                'Progresso do Jejum',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        LinearProgressIndicator(
          value: _overallProgress,
          backgroundColor: Colors.grey.shade700,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.lightBlue),
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(widget.elapsedTime),
              style: TextStyle(color: Colors.grey.shade300),
            ),
            Text(
              '${(_overallProgress * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              _formatDuration(widget.targetDuration),
              style: TextStyle(color: Colors.grey.shade300),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBodyVisualization() {
    final activeSystems = _currentMilestone?.affectedSystems ?? [];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedSystem = null),
              child: HumanBodyWidget(
                activeSystems: activeSystems,
                onSystemTap: _onSystemTap,
                selectedSystem: _selectedSystem,
              ),
            ),
          ),
          if (_selectedSystem != null) ...[
            const Divider(color: Colors.white24),
            _buildSystemDetailCard(_selectedSystem!),
          ],
        ],
      ),
    );
  }

  Widget _buildSystemDetailCard(BodySystem system) {
    final milestone = _currentMilestone;
    if (milestone == null) return const SizedBox.shrink();

    final systemBenefits = milestone.benefits
        .where((b) => _benefitRelatesToSystem(b, system))
        .toList();

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getSystemColor(system)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(_getSystemIcon(system), color: _getSystemColor(system)),
              const SizedBox(width: 8),
              Text(
                system.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            system.category,
            style: TextStyle(color: Colors.grey.shade400),
          ),
          if (systemBenefits.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...systemBenefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 16, color: Colors.green.shade400),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(color: Colors.grey.shade200),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  bool _benefitRelatesToSystem(String benefit, BodySystem system) {
    final keywords = {
      BodySystem.brain: ['mental', 'cognitivo', 'neuro', 'cérebro', 'foco'],
      BodySystem.liver: ['fígado', 'hepático', 'detox'],
      BodySystem.muscles: ['muscular', 'músculo'],
      BodySystem.fat: ['gordura', 'lipídeo', 'queima'],
      BodySystem.heart: ['coração', 'cardiovascular', 'sangue'],
      BodySystem.cells: ['celular', 'autofagia', 'mitocôndria'],
      BodySystem.immune: ['imune', 'defesa', 'inflamação'],
      BodySystem.gut: ['digestivo', 'intestino', 'estômago'],
    };

    final benefitLower = benefit.toLowerCase();
    return keywords[system]?.any((k) => benefitLower.contains(k)) ?? false;
  }

  Widget _buildBenefitsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Benefícios Alcançados',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          if (_currentMilestone != null) ...[
            _buildCurrentMilestoneCard(),
            const SizedBox(height: 16),
          ],
          Expanded(child: _buildAchievedMilestonesList()),
        ],
      ),
    );
  }

  Widget _buildCurrentMilestoneCard() {
    final milestone = _currentMilestone!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade700, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlue.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.amber.shade400),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  milestone.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            milestone.description,
            style: TextStyle(color: Colors.grey.shade200),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: milestone.affectedSystems.map((system) {
              return Chip(
                avatar: Icon(_getSystemIcon(system), size: 18),
                label: Text(system.name, style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.white.withOpacity(0.2),
                labelStyle: const TextStyle(color: Colors.white),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievedMilestonesList() {
    if (_achievedMilestones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_outlined, size: 64, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            Text(
              'Continue jejuando para desbloquear benefícios!',
              style: TextStyle(color: Colors.grey.shade400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _achievedMilestones.length,
      itemBuilder: (context, index) {
        final milestone = _achievedMilestones[index];
        return _buildMilestoneTile(milestone, index);
      },
    );
  }

  Widget _buildMilestoneTile(FastingMilestone milestone, int index) {
    final isLatest = index == _achievedMilestones.length - 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLatest ? Colors.green.withOpacity(0.2) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLatest ? Colors.green : Colors.grey.shade700,
          width: isLatest ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isLatest ? Colors.green : Colors.grey,
          child: Icon(
            isLatest ? Icons.check : Icons.lock_outline,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          milestone.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isLatest ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          '${milestone.hours.toStringAsFixed(0)}h • ${milestone.benefits.length} benefícios',
          style: TextStyle(color: Colors.grey.shade400),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade400,
        ),
        onTap: () => _showMilestoneDetails(milestone),
      ),
    );
  }

  Widget _buildMilestoneCarousel() {
    return Container(
      height: 140,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemCount: FastingTimeline.milestones.length,
        itemBuilder: (context, index) {
          final milestone = FastingTimeline.milestones[index];
          final achieved = widget.elapsedTime >= milestone.duration;
          
          return _buildCarouselItem(milestone, achieved);
        },
      ),
    );
  }

  Widget _buildCarouselItem(FastingMilestone milestone, bool achieved) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: achieved ? Colors.green.shade900 : Colors.grey.shade800,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                achieved ? Icons.check_circle : Icons.lock_outline,
                color: achieved ? Colors.green.shade400 : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                '${milestone.hours.toStringAsFixed(0)}h',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                milestone.title,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMilestoneDetails(FastingMilestone milestone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              milestone.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${milestone.hours.toStringAsFixed(0)} horas de jejum',
              style: TextStyle(color: Colors.lightBlue.shade400),
            ),
            const SizedBox(height: 24),
            Text(
              milestone.description,
              style: TextStyle(color: Colors.grey.shade300),
            ),
            const SizedBox(height: 24),
            Text(
              'Benefícios:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...milestone.benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade400),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(color: Colors.grey.shade200),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
            Text(
              'Sistemas afetados:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: milestone.affectedSystems.map((system) {
                return Chip(
                  avatar: Icon(_getSystemIcon(system), size: 18),
                  label: Text(system.name),
                  backgroundColor: _getSystemColor(system).withOpacity(0.3),
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
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

  Color _getSystemColor(BodySystem system) {
    switch (system) {
      case BodySystem.brain:
        return Colors.purple;
      case BodySystem.liver:
        return Colors.red;
      case BodySystem.muscles:
        return Colors.orange;
      case BodySystem.fat:
        return Colors.yellow;
      case BodySystem.heart:
        return Colors.redAccent;
      case BodySystem.cells:
        return Colors.blue;
      case BodySystem.immune:
        return Colors.green;
      case BodySystem.gut:
        return Colors.brown;
    }
  }

  IconData _getSystemIcon(BodySystem system) {
    switch (system) {
      case BodySystem.brain:
        return Icons.psychology;
      case BodySystem.liver:
        return Icons.water_drop;
      case BodySystem.muscles:
        return Icons.fitness_center;
      case BodySystem.fat:
        return Icons.local_fire_department;
      case BodySystem.heart:
        return Icons.favorite;
      case BodySystem.cells:
        return Icons.blur_circle;
      case BodySystem.immune:
        return Icons.shield;
      case BodySystem.gut:
        return Icons.restaurant;
    }
  }
}
