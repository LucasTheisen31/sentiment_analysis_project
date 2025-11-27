import 'dart:convert';

import 'package:sentiment_analysis_app/core/global/constants/endpoints.dart';
import 'package:sentiment_analysis_app/core/global/helpers/logger.dart';
import 'package:sentiment_analysis_app/models/sentiment_prediction_model.dart';
import 'package:http/http.dart' as http;

import './sentiment_repository.dart';

class SentimentRepositoryImpl extends SentimentRepository {
  @override
  Future<SentimentPredictionModel> evaluateSentiment(String comment) async {
    final url = Uri.parse(Endpoints.prediURL);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'text': comment,
          },
        ),
      );

      if (response.statusCode != 200) {
        logError(title: 'SentimentRepository: Erro ao avaliar o sentimento.', error: response.body, stackTrace: null);
        return Future.error('Erro ao avaliar o sentimento.');
      }

      return SentimentPredictionModel.fromMap(
        jsonDecode(
          response.body,
        ),
      );
    } catch (e, s) {
      logError(title: 'SentimentRepository: Erro ao avaliar o sentimento.', error: e, stackTrace: s);
      return Future.error('Erro ao avaliar o sentimento.');
    }
  }
}
