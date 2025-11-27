// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sentiment_analysis_app/models/sentiment_probability_model.dart';

class SentimentPredictionModel {
  int predictedClass;
  String predictedSentiment;
  double confidence;
  List<SentimentProbabilityModel> probabilities;

  SentimentPredictionModel({
    required this.predictedClass,
    required this.predictedSentiment,
    required this.confidence,
    required this.probabilities,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'predict_class': predictedClass,
      'predicted_sentiment': predictedSentiment,
      'confidence': confidence,
      'probabilities': probabilities.map((x) => x.toMap()).toList(),
    };
  }

  factory SentimentPredictionModel.fromMap(Map<String, dynamic> map) {
    return SentimentPredictionModel(
      predictedClass: (map['predicted_class'] ?? 0) as int,
      predictedSentiment: (map['predicted_sentiment'] ?? '') as String,
      confidence: (map['confidence'] ?? 0.0) as double,
      probabilities: List<SentimentProbabilityModel>.from(
        (map['probabilities'] as List<dynamic>).map<SentimentProbabilityModel>(
          (x) => SentimentProbabilityModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'SentimentPredictionModel(predictedClass: $predictedClass, predictedSentiment: $predictedSentiment, confidence: $confidence, probabilities: $probabilities)';
  }

  SentimentPredictionModel copyWith({
    int? predictedClass,
    String? predictedSentiment,
    double? confidence,
    List<SentimentProbabilityModel>? probabilities,
  }) {
    return SentimentPredictionModel(
      predictedClass: predictedClass ?? this.predictedClass,
      predictedSentiment: predictedSentiment ?? this.predictedSentiment,
      confidence: confidence ?? this.confidence,
      probabilities: probabilities ?? this.probabilities,
    );
  }
}
