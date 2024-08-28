// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/trainings_items_Components.dart';
import 'package:gerador_de_treinos/models/training.dart';
import 'package:gerador_de_treinos/utils/app_routes.dart';
import 'package:gerador_de_treinos/utils/submit.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  Training? training;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arg = ModalRoute.of(context)?.settings.arguments;

    if (arg != null) {
      final trainingArg = arg as Training;
      training = trainingArg;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Treino de ${training?.nameClient ?? ''}'),
        actions: [
          IconButton(
             onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.PDF,
                        arguments: training
                      );
                    },
            icon: Icon(Icons.print),
          ),
          IconButton(
            onPressed: () => Submit().submitCopy(context, training!,true),
            icon: Icon(Icons.move_down),
          ),
          IconButton(
            onPressed:() {
                      Navigator.of(context).pushNamed(
                        AppRoutes.TRAINING_REGISTER,
                        arguments: training
                      );
                    },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: TrainingsItemsComponents(
        training: training!,
      ),
    );
  }
}
