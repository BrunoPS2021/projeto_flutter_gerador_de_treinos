// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, prefer_final_fields, unused_field, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/training_item_trainig.dart';
import 'package:gerador_de_treinos/models/training.dart';

class TrainingsItemsComponents extends StatefulWidget {
  final Training training;
  const TrainingsItemsComponents({
    super.key,
    required this.training,
  });

  @override
  State<TrainingsItemsComponents> createState() =>
      _TrainingsItemsComponentsState();
}


class _TrainingsItemsComponentsState extends State<TrainingsItemsComponents> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.training.trainingItem.length,
        itemBuilder: (ctx, i) {
          return Column(
            children: [
              TrainingItemTraining(
                  trainingItem: widget.training.trainingItem[i]),
            ],
          );
        });
  }
}
