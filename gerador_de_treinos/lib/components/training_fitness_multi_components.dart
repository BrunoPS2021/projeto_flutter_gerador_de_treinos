// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, prefer_is_empty, must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/training_fitness_form_components.dart';
import 'package:gerador_de_treinos/models/fitness_item.dart';
import 'package:gerador_de_treinos/models/training_item.dart';

class TrainingFitnessMultiFormComponents extends StatefulWidget {
  List<FitnessItem>? fitnessItemOld;
  final state = _TrainingFitnessMultiFormComponentsState();
  final void Function(List<FitnessItem>, int) addFitness;
  final TrainingItem trainingItem;

  TrainingFitnessMultiFormComponents(
      {super.key, this.fitnessItemOld, required this.addFitness,required this.trainingItem});
  @override
  State<TrainingFitnessMultiFormComponents> createState() => state;

  List<FitnessItem> listFitnessItem() => state.fitnessItem;
}

class _TrainingFitnessMultiFormComponentsState
    extends State<TrainingFitnessMultiFormComponents> {
  List<FitnessItem> fitnessItem = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.fitnessItemOld != null) {
      fitnessItem.clear();

      for (int x = 0; x < widget.fitnessItemOld!.length; x++) {
        fitnessItem.add(
          FitnessItem(
              fitness: widget.fitnessItemOld![x].fitness,
              qdtRepetitions: widget.fitnessItemOld![x].qdtRepetitions,
              repetitions: widget.fitnessItemOld![x].repetitions,
              time: widget.fitnessItemOld![x].time),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onDelete(int index) {
    setState(() {
      fitnessItem.removeAt(index);
      if (widget.fitnessItemOld != null &&
          widget.fitnessItemOld!.length > index) {
        widget.fitnessItemOld!.removeAt(index);
      }
    });
  }

  void _onAddFitness(
    String fitness,
    int repetitions,
    int qdtRepetitions,
    int time,
    int index,
  ) {
    setState(() {
      fitnessItem.add(
        FitnessItem(
          fitness: fitness,
          repetitions: repetitions,
          qdtRepetitions: qdtRepetitions,
          time: time,
        ),
      );
      widget.addFitness(fitnessItem, widget.trainingItem.posicaoTraining);
    });
  }

  void _onEditFitness(
    String fitness,
    int repetitions,
    int qdtRepetitions,
    int time,
    int index,
  ) {
    setState(() {
      if (index >= 0) {
        fitnessItem[index] = FitnessItem(
          fitness: fitness,
          repetitions: repetitions,
          qdtRepetitions: qdtRepetitions,
          time: time,
        );
        widget.addFitness(fitnessItem, widget.trainingItem.posicaoTraining);
      }
    });
  }

  _openFitnessFormModal(BuildContext context, FitnessItem fitnessItem,
      Function(String, int, int, int, int) fun, int index) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return TrainingFitnessFormComponents(
          fitnessItem: fitnessItem,
          onSubmit: fun,
          index: index,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: () {
            _openFitnessFormModal(context, FitnessItem(), _onAddFitness, -1);
          },
          icon: Icon(Icons.add),
          label: Text('Adicionar novo exercício'),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Divider(
            color: Colors.black,
          ),
        ),
        fitnessItem.length <= 0
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Adicione um exercício'),
                ),
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: fitnessItem.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(
                    fitnessItem[i].fitness,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: fitnessItem[i].qdtRepetitions != 0 &&
                          fitnessItem[i].repetitions != 0
                      ? Text(
                          'Série: ${fitnessItem[i].repetitions}x     Repetições: ${fitnessItem[i].qdtRepetitions}')
                      : fitnessItem[i].time != 0
                          ? Text('Tempo: ${fitnessItem[i].time.toString()} min')
                          : Text(''),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _openFitnessFormModal(
                              context,
                              FitnessItem(
                                fitness: fitnessItem[i].fitness,
                                repetitions: fitnessItem[i].repetitions,
                                qdtRepetitions: fitnessItem[i].qdtRepetitions,
                                time: fitnessItem[i].time,
                              ),
                              _onEditFitness,
                              i,
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => onDelete(i),
                          icon: Icon(
                            Icons.delete_forever,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Divider(
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
