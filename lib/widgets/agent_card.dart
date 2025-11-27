import 'package:flutter/material.dart';
import '../models/agent.dart';

class AgentCard extends StatelessWidget {
  final Agent agent;
  final VoidCallback onTap;

  const AgentCard({super.key, required this.agent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.all(12),
      child: ListTile(
        onTap: onTap,
        title: Text(agent.name, style: TextStyle(color: Colors.white)),
        subtitle: Text(
          agent.description,
          style: TextStyle(color: Colors.white70),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.orange),
      ),
    );
  }
}
