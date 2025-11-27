// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on HomeControllerBase, Store {
  Computed<bool>? _$commentValidComputed;

  @override
  bool get commentValid =>
      (_$commentValidComputed ??= Computed<bool>(() => super.commentValid,
              name: 'HomeControllerBase.commentValid'))
          .value;
  Computed<String?>? _$commentErrorComputed;

  @override
  String? get commentError =>
      (_$commentErrorComputed ??= Computed<String?>(() => super.commentError,
              name: 'HomeControllerBase.commentError'))
          .value;
  Computed<SentimentEnum>? _$sentimentEnumComputed;

  @override
  SentimentEnum get sentimentEnum => (_$sentimentEnumComputed ??=
          Computed<SentimentEnum>(() => super.sentimentEnum,
              name: 'HomeControllerBase.sentimentEnum'))
      .value;
  Computed<bool>? _$formValidComputed;

  @override
  bool get formValid =>
      (_$formValidComputed ??= Computed<bool>(() => super.formValid,
              name: 'HomeControllerBase.formValid'))
          .value;
  Computed<dynamic>? _$sendPressedComputed;

  @override
  dynamic get sendPressed =>
      (_$sendPressedComputed ??= Computed<dynamic>(() => super.sendPressed,
              name: 'HomeControllerBase.sendPressed'))
          .value;

  late final _$_stateStatusAtom =
      Atom(name: 'HomeControllerBase._stateStatus', context: context);

  HomeStateStatus get stateStatus {
    _$_stateStatusAtom.reportRead();
    return super._stateStatus;
  }

  @override
  HomeStateStatus get _stateStatus => stateStatus;

  @override
  set _stateStatus(HomeStateStatus value) {
    _$_stateStatusAtom.reportWrite(value, super._stateStatus, () {
      super._stateStatus = value;
    });
  }

  late final _$_commentAtom =
      Atom(name: 'HomeControllerBase._comment', context: context);

  String get comment {
    _$_commentAtom.reportRead();
    return super._comment;
  }

  @override
  String get _comment => comment;

  @override
  set _comment(String value) {
    _$_commentAtom.reportWrite(value, super._comment, () {
      super._comment = value;
    });
  }

  late final _$_sentimentAtom =
      Atom(name: 'HomeControllerBase._sentiment', context: context);

  int get sentiment {
    _$_sentimentAtom.reportRead();
    return super._sentiment;
  }

  @override
  int get _sentiment => sentiment;

  @override
  set _sentiment(int value) {
    _$_sentimentAtom.reportWrite(value, super._sentiment, () {
      super._sentiment = value;
    });
  }

  late final _$_sentimentPredictionAtom =
      Atom(name: 'HomeControllerBase._sentimentPrediction', context: context);

  SentimentPredictionModel? get sentimentPrediction {
    _$_sentimentPredictionAtom.reportRead();
    return super._sentimentPrediction;
  }

  @override
  SentimentPredictionModel? get _sentimentPrediction => sentimentPrediction;

  @override
  set _sentimentPrediction(SentimentPredictionModel? value) {
    _$_sentimentPredictionAtom.reportWrite(value, super._sentimentPrediction,
        () {
      super._sentimentPrediction = value;
    });
  }

  late final _$_listReviewsAtom =
      Atom(name: 'HomeControllerBase._listReviews', context: context);

  ObservableList<ReviewModel> get listReviews {
    _$_listReviewsAtom.reportRead();
    return super._listReviews;
  }

  @override
  ObservableList<ReviewModel> get _listReviews => listReviews;

  @override
  set _listReviews(ObservableList<ReviewModel> value) {
    _$_listReviewsAtom.reportWrite(value, super._listReviews, () {
      super._listReviews = value;
    });
  }

  late final _$_loadingAnalyzeCommentAtom =
      Atom(name: 'HomeControllerBase._loadingAnalyzeComment', context: context);

  bool get loadingAnalyzeComment {
    _$_loadingAnalyzeCommentAtom.reportRead();
    return super._loadingAnalyzeComment;
  }

  @override
  bool get _loadingAnalyzeComment => loadingAnalyzeComment;

  @override
  set _loadingAnalyzeComment(bool value) {
    _$_loadingAnalyzeCommentAtom
        .reportWrite(value, super._loadingAnalyzeComment, () {
      super._loadingAnalyzeComment = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'HomeControllerBase._errorMessage', context: context);

  String? get errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  String? get _errorMessage => errorMessage;

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$_showErrorMessageAtom =
      Atom(name: 'HomeControllerBase._showErrorMessage', context: context);

  bool get showErrorMessage {
    _$_showErrorMessageAtom.reportRead();
    return super._showErrorMessage;
  }

  @override
  bool get _showErrorMessage => showErrorMessage;

  @override
  set _showErrorMessage(bool value) {
    _$_showErrorMessageAtom.reportWrite(value, super._showErrorMessage, () {
      super._showErrorMessage = value;
    });
  }

  late final _$_saveCommentAsyncAction =
      AsyncAction('HomeControllerBase._saveComment', context: context);

  @override
  Future<void> _saveComment() {
    return _$_saveCommentAsyncAction.run(() => super._saveComment());
  }

  late final _$_analyzeCommentAsyncAction =
      AsyncAction('HomeControllerBase._analyzeComment', context: context);

  @override
  Future<void> _analyzeComment() {
    return _$_analyzeCommentAsyncAction.run(() => super._analyzeComment());
  }

  late final _$HomeControllerBaseActionController =
      ActionController(name: 'HomeControllerBase', context: context);

  @override
  void setComment(String value) {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.setComment');
    try {
      return super.setComment(value);
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSentiment(int value) {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.setSentiment');
    try {
      return super.setSentiment(value);
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSentimentPrediction(SentimentPredictionModel value) {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.setSentimentPrediction');
    try {
      return super.setSentimentPrediction(value);
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void inalidSendPressed() {
    final _$actionInfo = _$HomeControllerBaseActionController.startAction(
        name: 'HomeControllerBase.inalidSendPressed');
    try {
      return super.inalidSendPressed();
    } finally {
      _$HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
commentValid: ${commentValid},
commentError: ${commentError},
sentimentEnum: ${sentimentEnum},
formValid: ${formValid},
sendPressed: ${sendPressed}
    ''';
  }
}
