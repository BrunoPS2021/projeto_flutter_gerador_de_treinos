// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/models/fitness_item.dart';

class TrainingItemsFitnessComponents extends StatelessWidget {
  final List<FitnessItem> fitnessItems;
  TrainingItemsFitnessComponents({
    super.key,
    required this.fitnessItems,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: SingleChildScrollView(
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(25),
            1: FlexColumnWidth(double.parse('Série'.length.toString()) + 3),
            2: FlexColumnWidth(double.parse('Repetições'.length.toString())),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Text(
                    'Exercício',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TableCell(
                  child: Text(
                    'Série',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TableCell(
                  child: Text(
                    'Repetições',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ...List.generate(fitnessItems.length, (index) {
              return TableRow(
                children: fitnessItems[index].time != 0
                    ? [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              '${fitnessItems[index].fitness}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            '${fitnessItems[index].time} min',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ]
                    : [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              '${fitnessItems[index].fitness}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            '${fitnessItems[index].repetitions}x',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TableCell(
                          child: Text(
                            '${fitnessItems[index].qdtRepetitions}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
