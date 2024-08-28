// ignore_for_file: prefer_final_fields, unused_field

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/exceptions/http_exception.dart';
import 'package:gerador_de_treinos/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:gerador_de_treinos/models/fitness.dart';

class FitnessList with ChangeNotifier {
  String _token;
  List<Fitness> _listFitness = [];

  List<Fitness> get listFitness => [..._listFitness];

  int get fitnessLength {
    return _listFitness.length;
  }

  FitnessList([
    this._token = '',
    this._listFitness = const [],
  ]);

  Future<void> loadListFitness() async {
    _listFitness.clear();

    final response = await http.get(
      Uri.parse('${Constants.FITNESS_BASE_URL}.json?auth=$_token'),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((fitnessId, fitnessData) {
      _listFitness.add(
        Fitness(
          id: fitnessId,
          name: fitnessData['name'],
          isRepetition: fitnessData['isRepetition'],
          isTime: fitnessData['isTime'],
        ),
      );
    });

    _listFitness
        .sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));

    notifyListeners();
  }

  Future<void> saveFitness(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final fitness = Fitness(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'].toString()[0].toUpperCase() +
          data['name'].toString().substring(1),
      isRepetition: data['isRepetition'] as bool,
      isTime: data['isTime'] as bool,
    );

    if (hasId) {
      return updateFitness(fitness);
    } else {
      return addFitness(fitness);
    }
  }

  Future<void> addFitness(Fitness fitness) async {
    final isExist = _listFitness
        .where((element) =>
            element.name.toUpperCase() == fitness.name.toUpperCase())
        .isEmpty;

    if (!isExist) {
      throw HttpException(
          msg:
              'Exercício ${fitness.name} já cadastrado, favor cadastrar um novo ou edite o mesmo',
          statusCode: 500);
    }

    final response = await http.post(
      Uri.parse('${Constants.FITNESS_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "name": fitness.name,
          "isRepetition": fitness.isRepetition,
          "isTime": fitness.isTime,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _listFitness.add(
      Fitness(
        id: id,
        name: fitness.name,
        isRepetition: fitness.isRepetition,
        isTime: fitness.isTime,
      ),
    );
    notifyListeners();
  }

  Future<void> updateFitness(Fitness fitness) async {
    int index = _listFitness.indexWhere((f) => f.id == fitness.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.FITNESS_BASE_URL}/${fitness.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "name": fitness.name,
            "isRepetition": fitness.isRepetition,
            "isTime": fitness.isTime,
          },
        ),
      );
      _listFitness[index] = fitness;
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> removeFitness(Fitness fitness) async {
    int index = _listFitness.indexWhere((f) => f.id == fitness.id);

    if (index >= 0) {
      final fit = _listFitness[index];

      _listFitness.remove(fit);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.FITNESS_BASE_URL}/${fitness.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _listFitness.insert(index, fitness);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o exercício ${fitness.name}',
          statusCode: response.statusCode,
        );
      }
    }
  }

  Future<List<Fitness>> loadListFitnessRegister() async {
    _listFitness.clear();

    final response = await http.get(
      Uri.parse('${Constants.FITNESS_BASE_URL}.json?auth=$_token'),
    );

    if (response.body == 'null') return [];

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((fitnessId, fitnessData) {
      _listFitness.add(
        Fitness(
          id: fitnessId,
          name: fitnessData['name'],
          isRepetition: fitnessData['isRepetition'],
          isTime: fitnessData['isTime'],
        ),
      );
    });

    _listFitness
        .sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));

    notifyListeners();
    return _listFitness;
  }
}
