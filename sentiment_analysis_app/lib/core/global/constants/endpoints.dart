import 'package:sentiment_analysis_app/core/env/env.dart';

class Endpoints {
  Endpoints._();

  static final String baseURL = Env.instance.get('API_URL');
  static final String prediURL = '$baseURL/predict';
}
