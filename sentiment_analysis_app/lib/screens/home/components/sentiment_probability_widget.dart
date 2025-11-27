import 'package:animated_emoji/emoji.dart';
import 'package:sentiment_analysis_app/core/extensions/formatter_extensions.dart';
import 'package:sentiment_analysis_app/core/ui/styles/custom_colors.dart';
import 'package:sentiment_analysis_app/core/ui/styles/text_styles.dart';
import 'package:sentiment_analysis_app/models/sentiment_probability_model.dart';
import 'package:sentiment_analysis_app/screens/home/home_controller.dart';
import 'package:flutter/material.dart';

class SentimentProbabilityWidget extends StatefulWidget {
  const SentimentProbabilityWidget({super.key, required this.sentimentProbability});

  final SentimentProbabilityModel sentimentProbability;

  @override
  State<SentimentProbabilityWidget> createState() => _SentimentProbabilityWidgetState();
}

class _SentimentProbabilityWidgetState extends State<SentimentProbabilityWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CustomColors.instance.primary.withAlpha(30),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.instance.secondary.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedEmoji(
            SentimentEnum.fromValue(widget.sentimentProbability.sentimentClass).emoji,
            size: 40,
            repeat: true,
          ),
          const SizedBox(height: 8),
          Text(
            SentimentEnum.fromValue(widget.sentimentProbability.sentimentClass).label,
            style: context.textStyles.textMedium.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${widget.sentimentProbability.probability.probabilityToStringPercent}%',
            style: context.textStyles.textMedium.copyWith(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
