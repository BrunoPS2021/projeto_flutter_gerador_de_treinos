// ignore_for_file: prefer_final_fields, unused_local_variable

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/exceptions/http_exception.dart';
import 'package:gerador_de_treinos/models/fitness_item.dart';
import 'package:gerador_de_treinos/models/training.dart';
import 'package:gerador_de_treinos/models/training_item.dart';
import 'package:gerador_de_treinos/utils/constants.dart';
import 'package:http/http.dart' as http;

class TrainingList with ChangeNotifier {
  String _token;
  List<Training> _listTraining = [];

  TrainingList([
    this._token = '',
    this._listTraining = const [],
  ]);

  List<Training> get listTraining => [..._listTraining];

  int get trainingLength {
    return _listTraining.length;
  }

  Future<void> loadListTraining() async {
    _listTraining.clear();

    final response = await http.get(
      Uri.parse('${Constants.TRAINING_BASE_URL}.json?auth=$_token'),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((trainingId, trainingData) {
      _listTraining.add(
        Training(
          id: trainingId,
          nameClient: trainingData['nameClient'],
          trainingItem:
              (trainingData['trainingItem'] as List<dynamic>).map((t) {
            return TrainingItem(
              colorTraining: t['colorTraining'],
              posicaoTraining: t['posicaoTraining'],
              fitnessItems: (t['fitnessItems'] as List<dynamic>).map((f) {
                return FitnessItem(
                  fitness: f['fitness'],
                  repetitions: f['repetitions'],
                  qdtRepetitions: f['qdtRepetitions'],
                  time: f['time'],
                );
              }).toList(),
            );
          }).toList(),
        ),
      );
    });

    _listTraining.sort((a, b) =>
        a.nameClient.toUpperCase().compareTo(b.nameClient.toUpperCase()));

    notifyListeners();
  }

  Future<void> saveTraining(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final training = Training(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      nameClient: data['nameClient']
          .toString()
          .split(' ')
          .map((letra) =>
              letra.toString()[0].toUpperCase() + letra.toString().substring(1))
          .join(' '),
      trainingItem: data['trainingItem'] as List<TrainingItem>,
    );

    if (hasId) {
      return updateTraining(training);
    } else {
      return addTraining(training);
    }
  }

  Future<void> addTraining(Training training) async {
    final response = await http.post(
      Uri.parse('${Constants.TRAINING_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          'nameClient': training.nameClient,
          'trainingItem': training.trainingItem
              .map((t) => {
                    'colorTraining': t.colorTraining,
                    'posicaoTraining': t.posicaoTraining,
                    'fitnessItems': t.fitnessItems
                        .map((f) => {
                              'fitness': f.fitness,
                              'qdtRepetitions': f.qdtRepetitions,
                              'repetitions': f.repetitions,
                              'time': f.time
                            })
                        .toList(),
                  })
              .toList(),
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _listTraining.add(
      Training(
        id: id,
        nameClient: training.nameClient,
        trainingItem: training.trainingItem,
      ),
    );
    _listTraining.sort((a, b) =>
        a.nameClient.toUpperCase().compareTo(b.nameClient.toUpperCase()));
    notifyListeners();
  }

  Future<void> removeTraining(Training training) async {
    int index = _listTraining.indexWhere((f) => f.id == training.id);

    if (index >= 0) {
      final trai = _listTraining[index];

      _listTraining.remove(trai);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.TRAINING_BASE_URL}/${training.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _listTraining.insert(index, training);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o treino de ${training.nameClient}',
          statusCode: response.statusCode,
        );
      }
    }
  }
  Future<void> updateTraining(Training training) async {
    int index = _listTraining.indexWhere((t) => t.id == training.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.TRAINING_BASE_URL}/${training.id}.json?auth=$_token'),
        body: jsonEncode(
        {
          'nameClient': training.nameClient,
          'trainingItem': training.trainingItem
              .map((t) => {
                    'colorTraining': t.colorTraining,
                    'posicaoTraining': t.posicaoTraining,
                    'fitnessItems': t.fitnessItems
                        .map((f) => {
                              'fitness': f.fitness,
                              'qdtRepetitions': f.qdtRepetitions,
                              'repetitions': f.repetitions,
                              'time': f.time
                            })
                        .toList(),
                  })
              .toList(),
        },
      )
      );
      _listTraining[index] = training;
      notifyListeners();
    }

    //return Future.value();
  }
}
