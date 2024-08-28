
// ignore_for_file: prefer_final_fields, unused_element

import 'package:flutter/material.dart';

class Fitness with ChangeNotifier{
  final String id;
  final String name;
  bool isRepetition;
  bool isTime;  
  
  Fitness({
    required this.id,
    required this.name,
    required this.isRepetition,
    required this.isTime,
  });

  void _toggleRepetition(){
    isRepetition = !isRepetition;
    isTime = isRepetition ? false : true;
    notifyListeners();
  }

  void _toggleTime(){
    isTime = !isTime;
    isRepetition = isTime ? false : true;
    notifyListeners();
  }
}