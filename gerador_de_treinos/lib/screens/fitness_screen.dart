// ignore_for_file: void_checks, prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/app_drawer.dart';
import 'package:gerador_de_treinos/components/fitness_item_components.dart';
import 'package:gerador_de_treinos/models/fitness_list.dart';
import 'package:gerador_de_treinos/utils/app_routes.dart';
import 'package:provider/provider.dart';

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({super.key});

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Provider.of<FitnessList>(
      context,
      listen: false,
    ).loadListFitness().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshListFitness(BuildContext context) async {
    return Provider.of<FitnessList>(context, listen: false).loadListFitness();
  }

  @override
  Widget build(BuildContext context) {
    final FitnessList fitness = Provider.of<FitnessList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Exercícios Cadastrados'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.FITNESS_FORM,
                );
              },
              icon: const Icon(
                Icons.add_circle,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: Text('Nenhum exercício foi cadastrado'),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshListFitness(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: fitness.fitnessLength,
                  itemBuilder: (ctx, i) => Column(
                    children: [
                      FitnessItemComponents(fitness: fitness.listFitness[i]),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
