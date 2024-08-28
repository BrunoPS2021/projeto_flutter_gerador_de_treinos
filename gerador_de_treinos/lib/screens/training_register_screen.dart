// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/training_form_components.dart';
import 'package:gerador_de_treinos/components/training_multi_form_components.dart';
import 'package:gerador_de_treinos/models/fitness_item.dart';
import 'package:gerador_de_treinos/models/training.dart';
import 'package:gerador_de_treinos/models/training_item.dart';
import 'package:gerador_de_treinos/models/training_list.dart';
import 'package:gerador_de_treinos/utils/app_routes.dart';
import 'package:provider/provider.dart';

class TrainingRegisterScreen extends StatefulWidget {
  const TrainingRegisterScreen({super.key});

  @override
  State<TrainingRegisterScreen> createState() => _TrainingRegisterScreenState();
}

class _TrainingRegisterScreenState extends State<TrainingRegisterScreen> {
  final _formData = Map<String, Object>();
  Training? training;
  TrainingMultiFormComponents? trainingMultiFormComponents;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        training = arg as Training;
        _formData['id'] = training!.id;
        _formData['nameClient'] = training!.nameClient;
        _formData['trainingItem'] = training!.trainingItem;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _isLoading = false;
  Future<void> _save(Map<String, Object> training) async {
    setState(() {
      _isLoading = true;
    });
    List<TrainingItem> listItems = [];
    final trainings = training['trainings'] as List<TrainingFormComponents>;

    for (var itemTraining in trainings) {
      final training = itemTraining.trainingItem;
      List<FitnessItem> listItemsFitness = [];

      for (var itemFitness in training.fitnessItems) {
        listItemsFitness.add(FitnessItem(
          fitness: itemFitness.fitness,
          repetitions: itemFitness.repetitions,
          qdtRepetitions: itemFitness.qdtRepetitions,
          time: itemFitness.time,
        ));
      }

      listItems.add(
        TrainingItem(
          colorTraining: training.colorTraining,
          posicaoTraining: training.posicaoTraining,
          fitnessItems: listItemsFitness,
        ),
      );
    }

    _formData['nameClient'] = training['nameClient'] as String;
    _formData['trainingItem'] = listItems;

    try {
      await Provider.of<TrainingList>(context, listen: false).saveTraining(
        _formData,
      );
      Navigator.of(context).pushNamed(AppRoutes.HOME);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro para salvar o treino'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _erroSubmit(String msg) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro!'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void submitForm() {
    if (trainingMultiFormComponents?.isValid()['result'] as bool) {
      _save(
          trainingMultiFormComponents?.isValid()['msg'] as Map<String, Object>);
    } else {
      _erroSubmit(trainingMultiFormComponents?.isValid()['msg'] as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    trainingMultiFormComponents =
        TrainingMultiFormComponents(key: GlobalKey(), training: training);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Treinos'),
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : trainingMultiFormComponents,
      /*body: ElevatedButton(
        onPressed: _submitForm,
        child: Text('oi'),
      ),*/
    );
  }
}
