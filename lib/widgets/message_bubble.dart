import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMe = message.sender == 'user';
    final time = DateFormat('HH:mm').format(message.timestamp);

    final backgroundColor = isMe
        ? theme.colorScheme.primary
        : theme.cardTheme.color ?? Colors.grey[200];

    final textColor = isMe
        ? theme.colorScheme.onPrimary
        : theme.textTheme.bodyMedium?.color ?? Colors.black;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MarkdownBody(
              data: message.text,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(color: textColor),
                strong: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                em: TextStyle(color: textColor, fontStyle: FontStyle.italic),
                listBullet: TextStyle(color: textColor),
                code: TextStyle(
                  color: isMe ? textColor : theme.colorScheme.primary,
                  backgroundColor: isMe
                      ? Colors.black12
                      : theme.colorScheme.surfaceContainerHighest ??
                            Colors.grey[200],
                  fontFamily: 'monospace',
                ),
                codeblockDecoration: BoxDecoration(
                  color: isMe
                      ? Colors.black12
                      : theme.colorScheme.surfaceContainerHighest ??
                            Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
