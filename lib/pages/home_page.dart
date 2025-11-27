import 'package:flutter/material.dart';
import '../models/agent.dart';
import 'chat_page.dart';
import '../widgets/agent_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final agents = [
    Agent(id: "vendedor", name: "Vendedor", description: "Persuasão e vendas."),
    Agent(
      id: "estagiario",
      name: "Estagiário",
      description: "Tarefas simples.",
    ),
    Agent(
      id: "copywriter",
      name: "Copywriter",
      description: "Textos persuasivos.",
    ),
    Agent(
      id: "suporte",
      name: "Suporte Técnico",
      description: "Ajuda técnica.",
    ),
  ];

  Agent? selectedAgent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("TaskForge-AI"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            // Layout Desktop (Master-Detail)
            return Row(
              children: [
                SizedBox(
                  width: 300,
                  child: ListView.builder(
                    itemCount: agents.length,
                    itemBuilder: (context, index) {
                      final agent = agents[index];
                      return Container(
                        color: selectedAgent?.id == agent.id
                            ? Colors.white10
                            : null,
                        child: AgentCard(
                          agent: agent,
                          onTap: () {
                            setState(() {
                              selectedAgent = agent;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black54,
                    child: selectedAgent == null
                        ? Center(
                            child: Text(
                              "Selecione um agente para conversar",
                              style: TextStyle(color: Colors.white54),
                            ),
                          )
                        : ChatPage(
                            key: ValueKey(selectedAgent!.id),
                            agent: selectedAgent!,
                          ),
                  ),
                ),
              ],
            );
          } else {
            // Layout Mobile (Lista Simples)
            return ListView.builder(
              itemCount: agents.length,
              itemBuilder: (context, index) {
                final agent = agents[index];
                return AgentCard(
                  agent: agent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatPage(agent: agent)),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
