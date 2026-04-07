import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/fasting_provider.dart';

class FastingHistory extends StatelessWidget {
  const FastingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FastingProvider>(
      builder: (context, provider, child) {
        if (provider.history.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.history.length > 5 ? 5 : provider.history.length,
          itemBuilder: (context, index) {
            final session = provider.history[index];
            return _buildHistoryItem(session);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum histórico ainda',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete sessões de jejum para ver seu histórico aqui',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(dynamic session) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: session.isCompleted ? Colors.green[100] : Colors.orange[100],
          child: Icon(
            session.isCompleted ? Icons.check : Icons.timer,
            color: session.isCompleted ? Colors.green[700] : Colors.orange[700],
            size: 20,
          ),
        ),
        title: Text(
          '${session.targetDurationHours} horas',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${dateFormat.format(session.startTime)} - ${timeFormat.format(session.startTime)}',
        ),
        trailing: session.endTime != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDuration(session.endTime!.difference(session.startTime)),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    timeFormat.format(session.endTime!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            : const Text('Em andamento'),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
