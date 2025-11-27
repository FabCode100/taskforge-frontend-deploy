import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/agent.dart';
import '../models/chat_message.dart';
import '../core/api.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatefulWidget {
  final Agent agent;

  const ChatPage({super.key, required this.agent});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  late Box<ChatMessage> box;
  List<ChatMessage> messages = [];
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    final sanitized = widget.agent.name.replaceAll(
      RegExp(r'[^a-zA-Z0-9_]'),
      '',
    );
    final shortName = sanitized.length > 3
        ? sanitized.substring(0, 3)
        : sanitized;
    final boxName = 'chat_${shortName.toLowerCase()}';
    box = await Hive.openBox<ChatMessage>(boxName);
    setState(() {
      messages = box.values.toList();
    });
  }

  Future<void> sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final userMessage = ChatMessage(
      sender: 'user',
      text: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(userMessage);
      isTyping = true; // Ativa indicador
    });
    box.add(userMessage);

    controller.clear();

    try {
      final response = await Api.sendMessage(
        agentId: widget.agent.id,
        prompt: text,
      );

      final botMessage = ChatMessage(
        sender: 'agent',
        text: response,
        timestamp: DateTime.now(),
      );

      setState(() {
        messages.add(botMessage);
      });
      box.add(botMessage);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao enviar mensagem: $e')));
    } finally {
      setState(() {
        isTyping = false; // Desativa indicador
      });
    }
  }

  Future<void> _clearHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Limpar Histórico"),
        content: Text(
          "Tem certeza que deseja apagar todas as mensagens deste chat?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Limpar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await box.clear();
      setState(() {
        messages.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agent.name),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearHistory,
            tooltip: "Limpar Histórico",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Começa de baixo para cima
              padding: EdgeInsets.all(12),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                // Se estiver digitando, o primeiro item (index 0) é o indicador
                if (isTyping && index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircularProgressIndicator(strokeWidth: 2),
                        SizedBox(width: 10),
                        Text(
                          "${widget.agent.name} está digitando...",
                          style: TextStyle(color: theme.hintColor),
                        ),
                      ],
                    ),
                  );
                }

                // Calcula o índice real da mensagem na lista cronológica
                // Se isTyping, index 0 é o loading, então as mensagens começam do index 1
                // Com reverse: true, index 0 (bottom) deve mostrar a ÚLTIMA mensagem da lista
                final msgIndex = isTyping
                    ? messages.length - index
                    : messages.length - 1 - index;

                if (msgIndex < 0 || msgIndex >= messages.length) {
                  return SizedBox.shrink();
                }

                return MessageBubble(message: messages[msgIndex]);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            color: theme
                .scaffoldBackgroundColor, // Mesma cor do fundo para parecer contínuo ou surface
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: "Digite aqui..."),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send, color: theme.colorScheme.primary),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
