// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/app_drawer.dart';
import 'package:gerador_de_treinos/components/training_item_components.dart';
import 'package:gerador_de_treinos/models/training_list.dart';
import 'package:gerador_de_treinos/utils/app_routes.dart';
import 'package:provider/provider.dart';

class TrainingOverviewScreen extends StatefulWidget {
  const TrainingOverviewScreen({super.key});

  @override
  State<TrainingOverviewScreen> createState() => _TrainingOverviewScreenState();
}

class _TrainingOverviewScreenState extends State<TrainingOverviewScreen> {

bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<TrainingList>(
      context,
      listen: false,
    ).loadListTraining().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshTrainingList(BuildContext context) async {
    return Provider.of<TrainingList>(context, listen: false).loadListTraining();
  }


  @override
  Widget build(BuildContext context) {
    final TrainingList training = Provider.of<TrainingList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Treinos Cadastrados'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: IconButton(
              onPressed:  () {
                Navigator.of(context).pushNamed(
                  AppRoutes.TRAINING_REGISTER,
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
              child: Text('Nenhum treino foi cadastrado'),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshTrainingList(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: training.trainingLength,
                  itemBuilder: (ctx, i) => Column(
                    children: [
                      TrainigItemComponents(training: training.listTraining[i],),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
