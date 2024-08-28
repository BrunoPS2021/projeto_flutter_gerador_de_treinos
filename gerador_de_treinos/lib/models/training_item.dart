import 'package:gerador_de_treinos/models/fitness_item.dart';

class TrainingItem {
  int colorTraining;
  int posicaoTraining;
  List<FitnessItem> fitnessItems;

  TrainingItem({
    this.colorTraining = 0,
    this.posicaoTraining = 0,
    this.fitnessItems = const [],
  });
}
