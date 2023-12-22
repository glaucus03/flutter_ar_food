class OpenAILogic {
  int extractCalories(String response) {
    // カロリーの値を探すための正規表現パターン
    final RegExp regex = RegExp(r'\s*"(\d+|\d+\.\d+)\s*kcal"');

    // レスポンス文字列からカロリーの値を検索
    final match = regex.firstMatch(response);

    if (match != null && match.groupCount >= 1) {
      // カロリーの値が見つかった場合、数値部分を取得し整数に変換
      return int.tryParse(match.group(1)!) ?? 0;
    } else {
      // カロリーの値が見つからなかった場合、0を返す
      return 0;
    }
  }
}
