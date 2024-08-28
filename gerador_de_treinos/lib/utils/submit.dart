// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/decoration_form.dart';
import 'package:gerador_de_treinos/models/training.dart';
import 'package:gerador_de_treinos/models/training_list.dart';
import 'package:provider/provider.dart';

class Submit {
  final _formKey = GlobalKey<FormState>();
  String nameClient = '';

  Future<void> submitCopy(
      BuildContext context, Training training, bool isExit) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Duplicando o treino de ${training.nameClient}'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            validator: (_name) {
              final name = _name ?? '';

              if (name.trim().isEmpty) {
                return 'Nome do cliente não pode esta vazio';
              }
              if (name.trim().length < 3) {
                return 'Nome do cliente precisa no mínimo de 3 letras';
              }

              return null;
            },
            onSaved: (name) => nameClient = name ?? training.nameClient,
            initialValue: training.nameClient.toString(),
            decoration: DecorationForm().decorationTextField(context, 'Nome do Cliente'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _submitForm(context, training, isExit);
            },
            child: Text('Duplicar'),
          ),
        ],
      ),
    );
  }

  Future<void> _actionCopy(
      BuildContext context, Training training, bool isExit) async {
    try {
      await Provider.of<TrainingList>(context, listen: false)
          .addTraining(training);
      if (isExit) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro para duplicar o treino'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _submitForm(
      BuildContext context, Training training, bool isExit) async {
    {
      final isValid = _formKey.currentState?.validate() ?? false;

      if (!isValid) {
        return;
      }
      _formKey.currentState?.save();

      final train = Training(
        id: training.id,
        nameClient: nameClient
        .split(' ')
        .map((letra) => letra.toString()[0].toUpperCase() + letra.toString().substring(1))
        .join(' '),
        trainingItem: training.trainingItem,
      );

      _actionCopy(context, train, isExit);
      Navigator.of(context).pop();
    }
  }
}
