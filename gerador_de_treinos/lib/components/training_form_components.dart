// ignore_for_file: prefer_generic_function_type_aliases,  must_be_immutable, no_logic_in_create_state, prefer_const_constructors, prefer_const_constructors_in_immutables, no_leading_underscores_for_local_identifiers, dead_code, prefer_is_empty
import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/training_fitness_multi_components.dart';
import 'package:gerador_de_treinos/models/fitness_item.dart';
import 'package:gerador_de_treinos/models/training_item.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gerador_de_treinos/utils/constants.dart';

class TrainingFormComponents extends StatefulWidget {
  final TrainingItem trainingItem;
  final state = _TrainingFormComponentsState();
  TrainingFitnessMultiFormComponents? trainingFitnessMultiFormComponents;
  final void Function(int) onDel;
  final void Function(List<FitnessItem>, int) addFitness;

  TrainingFormComponents({
    super.key,
    required this.trainingItem,
    required this.onDel,
    required this.addFitness,
  });

  @override
  State<TrainingFormComponents> createState() => state;

  List<FitnessItem> isValid() => state._isValid();
}

class _TrainingFormComponentsState extends State<TrainingFormComponents> {
  List<FitnessItem> _isValid() {
    if (widget.trainingFitnessMultiFormComponents!.listFitnessItem().length >
        0) {
      return widget.trainingFitnessMultiFormComponents!.listFitnessItem();
    } else if (widget.trainingItem.fitnessItems.length > 0) {
      return widget.trainingItem.fitnessItems;
    }

    return [];
  }

  final _form = GlobalKey<FormState>();

  _showPickerColor() async {
    Color color = Color(widget.trainingItem.colorTraining);
    setState(() {
      FocusScope.of(context).unfocus();
    });
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Selecione uma cor'),
          content: SingleChildScrollView(
            child: ColorPicker(
              enableAlpha: false,
              pickerColor: Color(widget.trainingItem.colorTraining),
              onColorChanged: (newColor) {
                setState(
                  () {
                    color = newColor;
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Sair'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.trainingItem.colorTraining = color.value;
                });
                Navigator.of(context).pop();
              },
              child: Text('Selecionar'),
            ),
          ],
        );
      },
    );
  }

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    widget.trainingFitnessMultiFormComponents =
        TrainingFitnessMultiFormComponents(
      fitnessItemOld: widget.trainingItem.fitnessItems,
      key: GlobalKey(),
      addFitness: widget.addFitness,
      trainingItem: widget.trainingItem,
    );
    return Padding(
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Card(
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppBar(
                    backgroundColor: Color(widget.trainingItem.colorTraining),
                    automaticallyImplyLeading: false,
                    title: Text(
                        'Treino ${Constants.ALFABETO[widget.trainingItem.posicaoTraining]}'),
                    actions: [
                      IconButton(
                        onPressed: _showPickerColor,
                        icon: Icon(Icons.palette),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.onDel(widget.trainingItem.posicaoTraining);
                          FocusScope.of(context).unfocus();
                        },
                        icon: Icon(Icons.delete_forever),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                            FocusScope.of(context).unfocus();
                          });
                        },
                        icon: Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more),
                      ),
                    ],
                  ),
                  if (_expanded)
                    SingleChildScrollView(
                      child: widget.trainingFitnessMultiFormComponents,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
