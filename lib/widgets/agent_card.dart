import 'package:flutter/material.dart';
import '../models/agent.dart';

class AgentCard extends StatelessWidget {
  final Agent agent;
  final VoidCallback onTap;

  const AgentCard({super.key, required this.agent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      // color: Colors.grey[900], // Removido para usar o tema
      margin: const EdgeInsets.all(12),
      child: ListTile(
        onTap: onTap,
        title: Text(agent.name), // Usa estilo padrão do tema
        subtitle: Text(
          agent.description,
          style: TextStyle(color: theme.hintColor),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
