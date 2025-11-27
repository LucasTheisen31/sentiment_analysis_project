class ReviewModel {
  final String comment;
  final int sentiment;

  ReviewModel({required this.comment, required this.sentiment});

  @override
  String toString() => 'ReviewModel(comment: $comment, sentiment: $sentiment)';
}
