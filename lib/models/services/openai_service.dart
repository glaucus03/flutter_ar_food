import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ar_food/models/datamodels/chat_gpt_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class OpenAIService {
  Future<ChatGPTResponse?> sendImageToGPT4Vision(
      String imagePath, String prompt) async {
    final String? apiKey = dotenv.get('OPENAI_API_KEY'); // 環境変数などからAPIキーを取得
    if ((apiKey ?? '').isEmpty) {
      throw Exception('APIKEYの設定が必要です。');
    }

    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey"
      };

      final payload = {
        "model": "gpt-4-vision-preview",
        "messages": [
          {
            "role": "user",
            "content": [
              {"type": "text", "text": prompt},
              {
                "type": "image_url",
                "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
              }
            ]
          }
        ],
        "max_tokens": 1200
      };

      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return ChatGPTResponse(
            responseText: responseData['choices'][0]['message']['content']);
      } else {
        throw Exception('GPT-4 Vision APIからのレスポンスの取得に失敗しました。');
      }
    } catch (e) {
      debugPrint("sendImage error: ${e.toString()}");
    }
    return null;
  }

  Future<String> encodeImageToBase64() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      return base64Encode(bytes);
    } else {
      throw Exception('画像が選択されていません');
    }
  }
}
