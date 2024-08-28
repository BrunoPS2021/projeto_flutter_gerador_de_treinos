// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/models/fitness.dart';
import 'package:gerador_de_treinos/models/fitness_list.dart';
import 'package:gerador_de_treinos/utils/app_routes.dart';
import 'package:provider/provider.dart';

class FitnessItemComponents extends StatelessWidget {
  final Fitness fitness;
  const FitnessItemComponents({
    super.key,
    required this.fitness,
  });

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    void _removerFitness() {
      showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Excluir o exercício ${fitness.name}'),
          content:
              Text('Deseja realmente excluir o exercício ${fitness.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Não'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Sim'),
            ),
          ],
        ),
      ).then(
        (value) {
          if (value ?? false) {
            try {
              Provider.of<FitnessList>(
                context,
                listen: false,
              ).removeFitness(fitness);
              msg.showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content:
                      Text('Exercício ${fitness.name} removido com sucesso'),
                ),
              );
            } catch (error) {
              msg.showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(error.toString()),
                ),
              );
            }
          }
        },
      );
    }

    return ListTile(
      title: Text(
        fitness.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      subtitle: Text(fitness.isRepetition
          ? 'Exercício de séries'
          : fitness.isTime
              ? 'Exercício com tempo'
              : 'Não especificado'),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.FITNESS_FORM,
                  arguments: fitness,
                );
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: _removerFitness,
              icon: Icon(Icons.delete_forever),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
