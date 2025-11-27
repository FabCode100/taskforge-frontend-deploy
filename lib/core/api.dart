import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "https://taskforge-backend-deploy.vercel.app/";

  static Future<String> sendMessage({
    required String agentId,
    required String prompt,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/agents/$agentId/execute"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"message": prompt}),
    );

    final data = json.decode(response.body);
    return data["response"];
  }
}
