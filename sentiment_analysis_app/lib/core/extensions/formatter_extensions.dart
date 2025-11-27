extension DoubleExtensions on double {
  String get probabilityToStringPercent {
    return (this * 100).toStringAsFixed(2);
  }
}
