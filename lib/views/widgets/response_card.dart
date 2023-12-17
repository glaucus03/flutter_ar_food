import 'package:flutter/material.dart';

class ResponseCard extends StatefulWidget {
  final String content; // カードに表示するレスポンスの内容

  const ResponseCard({Key? key, required this.content}) : super(key: key);

  @override
  _ResponseCardState createState() => _ResponseCardState();
}

class _ResponseCardState extends State<ResponseCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 画面サイズを取得
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Positioned(
          right: 10,
          bottom: 10,
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(seconds: 1), // フェードアウトの時間
            child: Card(
              child: Container(
                width: screenSize.width / 3, // カードの幅
                height: screenSize.height / 3, // カードの高さ
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.content),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
