import 'package:belajar_ai_flutter_batch6/model/open_ai.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final GptData gptData;
  const ResultPage({super.key, required this.gptData});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Recommendation'),
      ),
      body: Text(
        widget.gptData.choices?[0].message?.content ?? "-",
      ),
    );
  }
}
