// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/training_items_fitness_components.dart';
import 'package:gerador_de_treinos/models/training_item.dart';
import 'package:gerador_de_treinos/utils/constants.dart';

class TrainingItemTraining extends StatefulWidget {
  final TrainingItem trainingItem;
  const TrainingItemTraining({
    super.key,
    required this.trainingItem,
  });

  @override
  State<TrainingItemTraining> createState() => _TrainingItemTrainingState();
}

class _TrainingItemTrainingState extends State<TrainingItemTraining> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      child: Column(
        children: [
          ListTile(
            tileColor: Color(widget.trainingItem.colorTraining),
            title: Text(
              'Treino ${Constants.ALFABETO[widget.trainingItem.posicaoTraining]}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          if(_expanded)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TrainingItemsFitnessComponents(fitnessItems: widget.trainingItem.fitnessItems),
          ),
        ],
      ),
    );
  }
}
