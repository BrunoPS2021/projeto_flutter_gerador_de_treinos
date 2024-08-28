// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_final_fields, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/models/training.dart';
import 'package:gerador_de_treinos/models/training_list.dart';
import 'package:gerador_de_treinos/utils/app_routes.dart';
import 'package:gerador_de_treinos/utils/submit.dart';
import 'package:provider/provider.dart';

class TrainigItemComponents extends StatefulWidget {
  final Training training;
  const TrainigItemComponents({
    super.key,
    required this.training,
  });

  @override
  State<TrainigItemComponents> createState() => _TrainigItemComponentsState();
}

class _TrainigItemComponentsState extends State<TrainigItemComponents> {
  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    void _removerTraining() {
      showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Excluir o treino de ${widget.training.nameClient}'),
          content: Text(
              'Deseja realmente excluir o treino de ${widget.training.nameClient}?'),
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
              Provider.of<TrainingList>(
                context,
                listen: false,
              ).removeTraining(widget.training);
              msg.showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                      'O treino de ${widget.training.nameClient} removido com sucesso'),
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

    return Card(
      color: Colors.blue[50],
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.TRAINING,
                arguments: widget.training,
              );
            },
            title: Text(
              'Treino de ${widget.training.nameClient}',
            ),
            trailing: FittedBox(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.PDF,
                        arguments: widget.training
                      );
                    },
                    icon: Icon(Icons.print),
                  ),
                  IconButton(
                    onPressed: () =>
                        Submit().submitCopy(context, widget.training, false),
                    icon: Icon(Icons.move_down),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.TRAINING_REGISTER,
                        arguments: widget.training
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: _removerTraining,
                    icon: Icon(Icons.delete_forever),
                    color: Theme.of(context).colorScheme.error,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
