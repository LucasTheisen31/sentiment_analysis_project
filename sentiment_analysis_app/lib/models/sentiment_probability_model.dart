class SentimentProbabilityModel {
  String sentiment;
  int sentimentClass;
  double probability;

  SentimentProbabilityModel({
    required this.sentiment,
    required this.sentimentClass,
    required this.probability,
  });

  get probabilityToStringPercent => null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sentiment': sentiment,
      'sentiment_class': sentimentClass,
      'probability': probability,
    };
  }

  factory SentimentProbabilityModel.fromMap(Map<String, dynamic> map) {
    return SentimentProbabilityModel(
      sentiment: (map['sentiment'] ?? '') as String,
      sentimentClass: (map['sentiment_class'] ?? 0) as int,
      probability: (map['probability'] ?? 0.0) as double,
    );
  }

  @override
  String toString() => 'SentimentProbabilityModel(sentiment: $sentiment, sentimentClass: $sentimentClass, probability: $probability)';
}
