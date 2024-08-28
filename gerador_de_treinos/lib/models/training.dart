import 'package:gerador_de_treinos/models/training_item.dart';

class Training {
  final String id;
  final String nameClient;
  final List<TrainingItem> trainingItem;

  Training({
    required this.id,
    required this.nameClient,
    required this.trainingItem,
  });
}
