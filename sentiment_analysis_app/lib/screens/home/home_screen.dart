import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.g.dart';
import 'package:sentiment_analysis_app/core/ui/components/form_container.dart';
import 'package:sentiment_analysis_app/core/ui/components/shimmer/shimmer_review_widget.dart';
import 'package:sentiment_analysis_app/core/ui/helpers/debouncer.dart';
import 'package:sentiment_analysis_app/core/ui/helpers/loader.dart';
import 'package:sentiment_analysis_app/core/ui/helpers/messages.dart';
import 'package:sentiment_analysis_app/core/ui/helpers/size_extensions.dart';
import 'package:sentiment_analysis_app/core/ui/styles/text_styles.dart';
import 'package:sentiment_analysis_app/models/sentiment_probability_model.dart';
import 'package:sentiment_analysis_app/screens/home/components/review_tile.dart';
import 'package:sentiment_analysis_app/screens/home/components/sentiment_probability_widget.dart';
import 'package:sentiment_analysis_app/screens/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobx/mobx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with Loader, Messages {
  final controller = HomeController();
  final debouncer = Debouncer(milisseconds: 700);
  final commentEC = TextEditingController();
  List<ReactionDisposer> disposers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stateDisposer = reaction((_) => controller.stateStatus, (stateStatus) {
        switch (stateStatus) {
          case HomeStateStatus.initial:
            break;
          case HomeStateStatus.loading:
            showLoader();
            break;
          case HomeStateStatus.loaded:
            hideLoader();
            break;
          case HomeStateStatus.error:
            hideLoader();
            showError(controller.errorMessage ?? 'Erro desconhecido');
            break;
        }
      });

      final ecDisposer = autorun((_) {
        if (commentEC.text != controller.comment) commentEC.text = controller.comment;
      });

      disposers.addAll([stateDisposer, ecDisposer]);
    });
  }

  @override
  void dispose() {
    for (var disposer in disposers) {
      disposer();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliar Comentário'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: FormContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Observer(
                  builder: (_) {
                    return TextFormField(
                      controller: commentEC,
                      onChanged: (value) {
                        debouncer.run(() {
                          controller.setComment(value);
                        });
                      },
                      minLines: 3,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Digite sua avaliação',
                        alignLabelWithHint: true,
                        errorText: controller.commentError,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Observer(
                  builder: (context) {
                    if (controller.stateStatus == HomeStateStatus.initial) {
                      return SizedBox(
                        height: screenHeight * .7,
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedEmoji(
                                  AnimatedEmojis.indexFinger,
                                  size: 90,
                                  repeat: true,
                                  animate: true,
                                ),
                                SizedBox(height: 32.0),
                                Text(
                                  'Aguardando comentário para analisar...',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    if (controller.loadingAnalyzeComment) {
                      return const ShimmerReviewWidget();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Sujestão de Classificação:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: Observer(builder: (_) {
                            return RatingBar.builder(
                              initialRating: controller.sentimentEnum.value.toDouble() + 1,
                              minRating: 1,
                              itemCount: 5,
                              itemSize: 50,
                              wrapAlignment: WrapAlignment.center,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                                shadows: [
                                  Shadow(
                                    color: Colors.yellowAccent.withAlpha(90),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              onRatingUpdate: (rating) {
                                controller.setSentiment(rating.toInt() - 1);
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Sentimento Avaliado no Texto:',
                          textAlign: TextAlign.center,
                          style: context.textStyles.textBold.copyWith(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Observer(builder: (_) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Observer(builder: (_) {
                                return AnimatedEmoji(
                                  controller.sentimentEnum.emoji,
                                  size: 90,
                                  repeat: true,
                                  animate: true,
                                );
                              }),
                              const SizedBox(height: 8.0),
                              Text(
                                controller.sentimentEnum.label,
                                style: context.textStyles.textTitle,
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 16.0),
                        Observer(builder: (_) {
                          return controller.sentimentPrediction == null
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    Text(
                                      'Probabilidade de Classificação:',
                                      textAlign: TextAlign.center,
                                      style: context.textStyles.textBold.copyWith(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children: controller.sentimentPrediction!.probabilities.map(
                                        (SentimentProbabilityModel sentimentProbability) {
                                          return SentimentProbabilityWidget(
                                            sentimentProbability: sentimentProbability,
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ],
                                );
                        }),
                        const SizedBox(height: 16.0),
                        Observer(
                          builder: (_) {
                            return Center(
                              child: GestureDetector(
                                onTap: () => controller.inalidSendPressed(),
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: controller.sendPressed,
                                    icon: const Icon(Icons.save),
                                    label: const Text('Salvar Avaliação'),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24.0),
                Observer(
                  builder: (context) => Visibility(
                    visible: controller.listReviews.isNotEmpty,
                    child: Column(
                      children: [
                        Text(
                          'Avaliações Salvas:',
                          textAlign: TextAlign.start,
                          style: context.textStyles.textBold.copyWith(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.listReviews.length,
                          itemBuilder: (context, index) {
                            final review = controller.listReviews[index];
                            return ReviewTile(reviewModel: review);
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
