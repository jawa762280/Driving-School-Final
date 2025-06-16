import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'choice_model.dart';

class QuestionModel {
  Rx<XFile?> image = Rx<XFile?>(null);
  RxString imageUrl = ''.obs;
  TextEditingController textController = TextEditingController();
  RxList<ChoiceModel> choices = <ChoiceModel>[].obs;
  QuestionModel() {
    choices.addAll([ChoiceModel(), ChoiceModel()]);
  }
}
