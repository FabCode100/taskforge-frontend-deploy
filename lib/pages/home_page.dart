import 'package:flutter/material.dart';
import '../models/agent.dart';
import 'chat_page.dart';
import '../widgets/agent_card.dart';
import '../main.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("TaskForge-AI"),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, mode, child) {
              IconData icon;
              if (mode == ThemeMode.light) {
                icon = Icons.wb_sunny;
              } else if (mode == ThemeMode.dark) {
                icon = Icons.nightlight_round;
              } else {
                icon = Icons.brightness_auto;
              }

              return IconButton(
                icon: Icon(icon),
                onPressed: () {
                  if (mode == ThemeMode.light) {
                    themeNotifier.value = ThemeMode.dark;
                  } else if (mode == ThemeMode.dark) {
                    themeNotifier.value = ThemeMode.system;
                  } else {
                    themeNotifier.value = ThemeMode.light;
                  }
                },
                tooltip: "Alternar Tema",
              );
            },
          ),
        ],
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
                      final isSelected = selectedAgent?.id == agent.id;
                      return Container(
                        color: isSelected
                            ? theme.colorScheme.primaryContainer
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
                    color: theme.scaffoldBackgroundColor,
                    child: selectedAgent == null
                        ? Center(
                            child: Text(
                              "Selecione um agente para conversar",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.hintColor,
                              ),
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
