import 'package:animated_emoji/emoji.dart';
import 'package:sentiment_analysis_app/models/review_model.dart';
import 'package:sentiment_analysis_app/screens/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewTile extends StatelessWidget {
  final ReviewModel reviewModel;

  const ReviewTile({super.key, required this.reviewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.black.withAlpha(30),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]),
      child: Row(
        children: [
          Expanded(child: Text(reviewModel.comment)),
          const SizedBox(width: 8.0),
          Column(
            children: [
              AnimatedEmoji(
                SentimentEnum.fromValue(reviewModel.sentiment).emoji,
                size: 50,
                repeat: true,
              ),
              const SizedBox(
                height: 4,
              ),
              RatingBar.builder(
                initialRating: reviewModel.sentiment + 1,
                itemCount: 5,
                itemSize: 20,
                ignoreGestures: true,
                wrapAlignment: WrapAlignment.center,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
