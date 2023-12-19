class ChatGPTResponse {
  final String responseText;

  ChatGPTResponse({required this.responseText});

  factory ChatGPTResponse.fromJson(Map<String, dynamic> json) {
    return ChatGPTResponse(
      responseText: json['response_text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response_text': responseText,
    };
  }
}
