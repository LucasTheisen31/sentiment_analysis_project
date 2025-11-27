import 'package:sentiment_analysis_app/models/sentiment_prediction_model.dart';

abstract class SentimentRepository {
  Future<SentimentPredictionModel> evaluateSentiment(String comment);
}
