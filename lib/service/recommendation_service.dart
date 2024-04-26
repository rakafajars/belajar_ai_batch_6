import 'dart:convert';

import 'package:belajar_ai_flutter_batch6/constant/open_ai.dart';
import 'package:belajar_ai_flutter_batch6/model/open_ai.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class RecommendationService {
  Future<GptData> getRecommendation({
    required String carRegion,
    required String budget,
  }) async {
    late GptData gptData = GptData(
      id: "",
      object: "",
      created: 0,
      model: "",
      choices: [],
      usage: Usage(
        promptTokens: 0,
        completionTokens: 0,
        totalTokens: 0,
      ),
    );

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $apiKey'
      };

      final currency = NumberFormat.currency(
          locale: 'id_ID', symbol: 'IDR ', decimalDigits: 0);

      String carBudget = currency.format(
        int.parse(
          budget,
        ),
      );

      final data = jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "user",
            "content":
                "Please give me a car recommendation from ${carRegion.toLowerCase()} manufacturers with budget equals to $carBudget"
          }
        ],
        "temperature": 1,
        "max_tokens": 256,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0
      });

      final response = await Dio().post(
        'https://api.openai.com/v1/chat/completions',
        data: data,
        options: Options(
          headers: headers,
        ),
      );

      return GptData.fromJson(response.data);
    } on DioException catch (e) {
      throw 'Error $e';
    }
  }
}
