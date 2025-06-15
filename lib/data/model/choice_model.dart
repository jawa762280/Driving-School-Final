import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ChoiceModel {
  TextEditingController textController = TextEditingController();
  RxBool isCorrect = false.obs;

  ChoiceModel({String text = '', bool correct = false}) {
    textController.text = text;
    isCorrect.value = correct;
  }
}
