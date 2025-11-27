import 'package:sentiment_analysis_app/core/ui/helpers/size_extensions.dart';
import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  final Widget child;

  const FormContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;

    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth * (screenWidth > 1200 ? .5 : 1),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}
