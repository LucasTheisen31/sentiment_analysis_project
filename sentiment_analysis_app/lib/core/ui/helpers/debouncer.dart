/* 
Debouncing é uma técnica usada para evitar processamento 
desnecessário, definindo um atraso antes de executar uma 
função, de modo que se a função for chamada novamente dentro 
do atraso, a função anterior seja cancelada e o cronômetro seja zerado novamente.
*/

import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final int milisseconds;
  Timer? _timer;

  Debouncer({
    required this.milisseconds,
  });

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }

    //A função [callback] é invocada após a [duração] fornecida
    _timer = Timer(Duration(milliseconds: milisseconds), action);
  }
}
