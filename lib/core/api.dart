import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:frontend/core/logger.dart';

class Api {
  static const baseUrl = "https://taskforge-backend-deploy.onrender.com";

  static Future<String> sendMessage({
    required String agentId,
    required String prompt,
  }) async {
    logger.i("agent_id: $agentId , prompt: $prompt");
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/agents/$agentId/execute"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "message": "$prompt\n\nResponda em até 5 linhas.Não Use markdown.",
        }),
      );

      if (response.statusCode != 200) {
        final errorMsg =
            "Falha na requisição API:\n"
            "URL: ${response.request?.url}\n"
            "Status Code: ${response.statusCode}\n"
            "Body: ${response.body}";
        logger.e(errorMsg);
        throw Exception(
          "Erro na API (${response.statusCode}): Não foi possível processar sua solicitação.",
        );
      }

      final data = json.decode(response.body);
      final reply = _normalizeOutput(data["response"]);
      logger.i("\nResposta do agent_id ao cliente:\n $reply");
      return reply;
    } on SocketException catch (e) {
      logger.e("Erro de conexão (SocketException): $e");
      throw Exception("Erro de conexão: Verifique sua internet ou o servidor.");
    } on http.ClientException catch (e) {
      logger.e("Erro no cliente HTTP: $e");
      throw Exception("Erro na comunicação com o servidor.");
    } on FormatException catch (e) {
      logger.e("Erro de formatação (JSON inválido): $e");
      throw Exception("Resposta inválida do servidor.");
    } catch (e) {
      logger.e("\nErro inesperado:\n $e");
      rethrow;
    }
  }

  static String _normalizeOutput(String text) {
    return text.trim();
  }
}
