// ignore_for_file: prefer_const_constructors, prefer_final_fields, no_leading_underscores_for_local_identifiers, must_be_immutable, no_logic_in_create_state, unnecessary_cast, prefer_is_empty

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/decoration_form.dart';
import 'package:gerador_de_treinos/models/fitness_item.dart';
import 'package:gerador_de_treinos/models/training.dart';
import 'package:gerador_de_treinos/models/training_item.dart';
import 'package:gerador_de_treinos/components/training_form_components.dart';
import 'package:gerador_de_treinos/utils/constants.dart';

class TrainingMultiFormComponents extends StatefulWidget {
  Training? training;
  List<TrainingFormComponents> trainingForm = [];
  final state = _TrainingMultiFormComponentsState();

  TrainingMultiFormComponents({
    super.key,
    this.training,
  });

  @override
  State<TrainingMultiFormComponents> createState() => state;

  Map<String, Object> isValid() => state._isValid();
}

class _TrainingMultiFormComponentsState
    extends State<TrainingMultiFormComponents> {
  final focusNodeText = FocusNode();
  void updateText() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    focusNodeText.addListener(updateText);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.training != null) {
      widget.trainingForm.clear();
      _controllerName.text = widget.training!.nameClient;
      for (int x = 0; x < widget.training!.trainingItem.length; x++) {
        widget.trainingForm.add(
          TrainingFormComponents(
            key: GlobalKey(),
            trainingItem: widget.training!.trainingItem[x],
            onDel: _onDelete,
            addFitness: _addFitness,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNodeText.removeListener(updateText);
    focusNodeText.dispose();
  }

  Map<String, Object> _isValid() {
    var isValid = _form.currentState?.validate() ?? false;

    if (!isValid) {
      return {'result': false, 'msg': 'Sem nome do cliente, favor informe o nome válido'};
    }

    _form.currentState?.save();

    if (widget.trainingForm.isEmpty) {
      return {'result': false, 'msg': 'Não existe nenhum treino cadastrado'};
    }

    for (int x = 0; x < widget.trainingForm.length; x++) {
      if (widget.trainingForm[x].trainingFitnessMultiFormComponents!
              .listFitnessItem()
              .length ==
          0) {
        if (widget.trainingForm[x].trainingItem.fitnessItems.length == 0) {
          return {
            'result': false,
            'msg':
                'Não existe nenhum exercício cadastrado no treino ${Constants.ALFABETO[widget.trainingForm[x].trainingItem.posicaoTraining]}'
          };
        }
      } //print();
    }

    return {
      'result': isValid,
      'msg': {
        'nameClient': _controllerName.text,
        'trainings': widget.trainingForm,
      }
    };
  }

  final _form = GlobalKey<FormState>();
  TextEditingController _controllerName = TextEditingController();

  _addForm() {
    Color colorBackground =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    setState(() {
      FocusScope.of(context).unfocus();
      final item = TrainingItem(
        posicaoTraining: widget.trainingForm.length + 1,
        colorTraining: colorBackground.value,
        fitnessItems: [],
      );
      widget.trainingForm.add(
        TrainingFormComponents(
          key: GlobalKey(),
          trainingItem: item,
          onDel: _onDelete,
          addFitness: _addFitness,
        ),
      );
    });
  }

  void _addFitness(List<FitnessItem> fitnessItem, int position) {
    setState(() {
      for (int x = 0; x < widget.trainingForm.length; x++) {
        if (widget.trainingForm[x].trainingItem.posicaoTraining == position) {
          widget.trainingForm[x].trainingItem.fitnessItems = fitnessItem;
          return;
        }
      }
    });
  }

  void _onDelete(int index) {
    setState(() {
      final list = widget.trainingForm
          .where((element) => element.trainingItem.posicaoTraining != index)
          .toList();

      widget.trainingForm = list;

      List<TrainingItem> newTrainingItem = [];
      for (int i = 0; i < widget.trainingForm.length; i++) {
        newTrainingItem.add(
          TrainingItem(
            colorTraining: widget.trainingForm[i].trainingItem.colorTraining,
            posicaoTraining: i + 1,
            fitnessItems: widget.trainingForm[i].trainingItem.fitnessItems,
          ),
        );
      }

      widget.trainingForm.clear();
      for (int x = 0; x < newTrainingItem.length; x++) {
        widget.trainingForm.add(
          TrainingFormComponents(
            trainingItem: newTrainingItem[x],
            onDel: _onDelete,
            addFitness: _addFitness,
            key: GlobalKey(),
          ),
        );
      }
      //widget.trainingForm.removeAt(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Ink(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Form(
                  key: _form,
                  child: TextFormField(
                    focusNode: focusNodeText,
                    //initialValue: widget.training?.nameClient ?? '',
                    controller: _controllerName,
                    validator: (_value) {
                      final value = _value ?? '';
                      if (value.isEmpty) {
                        return 'Campo obrigatório esta vazio';
                      }
                      if (value.trim().length < 2) {
                        return 'Nome do cliente precids no mínimo 2 letras';
                      }
                      return null;
                    },
                    decoration: DecorationForm()
                        .decorationTextField(context, 'Nome do Cliente'),
                  ),
                ),
                TextButton.icon(
                  onPressed:
                      widget.trainingForm.length > 25 ? null : () => _addForm(),
                  icon: Icon(Icons.add),
                  label: Text('Adicionar Treinos'),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.trainingForm.length,
                  itemBuilder: (ctx, i) => widget.trainingForm[i],
                ),
              ],
            ),
          ),
        ),
      ),
    ); //
  }
}
