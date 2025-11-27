// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:animated_emoji/emoji_data.dart';
import 'package:animated_emoji/emojis.g.dart';
import 'package:sentiment_analysis_app/models/review_model.dart';
import 'package:sentiment_analysis_app/models/sentiment_prediction_model.dart';
import 'package:sentiment_analysis_app/repositories/sentiment_repository.dart';
import 'package:sentiment_analysis_app/repositories/sentiment_repository_impl.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

enum SentimentEnum {
  veryNegative(0, 'Extremamente Negativo', AnimatedEmojis.bigFrown),
  negative(1, 'Negativo', AnimatedEmojis.frown),
  neutral(2, 'Neutro', AnimatedEmojis.neutralFace),
  positive(3, 'Positivo', AnimatedEmojis.slightlyHappy),
  veryPositive(4, 'Extremamente Positivo', AnimatedEmojis.smileWithBigEyes);

  final int value;
  final String label;
  final AnimatedEmojiData emoji;

  const SentimentEnum(this.value, this.label, this.emoji);

  static SentimentEnum fromValue(int value) {
    return SentimentEnum.values.firstWhere((element) => element.value == value, orElse: () => neutral);
  }
}

enum HomeStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store {
  HomeControllerBase();

  final SentimentRepository _sentimentRepository = SentimentRepositoryImpl();

  @readonly
  HomeStateStatus _stateStatus = HomeStateStatus.initial;

  @readonly
  String _comment = '';

  @action
  void setComment(String value) {
    _showErrorMessage = true;
    _comment = value;
    if (commentValid) {
      _analyzeComment();
    }
  }

  @computed
  bool get commentValid => _comment.isNotEmpty && _comment.length >= 3;

  @computed
  String? get commentError {
    if (commentValid || !_showErrorMessage) {
      return null;
    } else {
      return 'O comentário deve ter pelo menos 3 caracteres.';
    }
  }

  //* Sentimento selecionado pelo usuário, ou a classe predita pela IA
  @readonly
  int _sentiment = 0;

  @action
  void setSentiment(int value) => _sentiment = value;

  @computed
  SentimentEnum get sentimentEnum {
    return SentimentEnum.fromValue(_sentiment);
  }

  //* Sentimento predito pela IA
  @readonly
  SentimentPredictionModel? _sentimentPrediction;

  @action
  void setSentimentPrediction(SentimentPredictionModel value) => _sentimentPrediction = value;

  @readonly
  ObservableList<ReviewModel> _listReviews = ObservableList();

  @readonly
  bool _loadingAnalyzeComment = false;

  @readonly
  String? _errorMessage;

  @readonly
  bool _showErrorMessage = false;

  @action
  void inalidSendPressed() => _showErrorMessage = true;

  @computed
  bool get formValid => commentValid;

  @computed
  dynamic get sendPressed => formValid ? _saveComment : null;

  @action
  Future<void> _saveComment() async {
    try {
      _stateStatus = HomeStateStatus.loading;

      final review = ReviewModel(comment: _comment, sentiment: _sentiment);
      _listReviews.add(review);

      _comment = '';
      _sentiment = 0;

      _stateStatus = HomeStateStatus.loaded;
    } catch (e, s) {
      log('Erro ao salvar o comentário', error: e, stackTrace: s);
      _errorMessage = 'Erro ao salver o comentário';
      _stateStatus = HomeStateStatus.error;
    }
  }

  @action
  Future<void> _analyzeComment() async {
    _stateStatus = HomeStateStatus.loading;
    _loadingAnalyzeComment = true;
    try {
      _sentimentPrediction = await _sentimentRepository.evaluateSentiment(_comment);
      setSentiment(_sentimentPrediction!.predictedClass);
      _stateStatus = HomeStateStatus.loaded;
    } catch (e, s) {
      log('HomeController: Erro ao analisar o comentário.', error: {e.toString()}, stackTrace: s);
      _errorMessage = 'Erro ao analisar o comentário.';
      _stateStatus = HomeStateStatus.error;
    } finally {
      _loadingAnalyzeComment = false;
    }
  }
}
