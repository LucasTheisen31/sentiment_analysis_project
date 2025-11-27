import 'dart:developer';

void logError({required String title, dynamic error, required StackTrace? stackTrace}) {
  log('⚠️ $title', error: '❌ Error: ${error.toString()}');
  log('🧵 Stacktrace:\n$stackTrace');
}
