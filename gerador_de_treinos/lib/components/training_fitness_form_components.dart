// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_field, prefer_const_constructors_in_immutables, prefer_final_fields, avoid_unnecessary_containers

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_de_treinos/components/decoration_form.dart';
import 'package:gerador_de_treinos/models/fitness_item.dart';
import 'package:gerador_de_treinos/models/fitness_list.dart';
import 'package:provider/provider.dart';

class TrainingFitnessFormComponents extends StatefulWidget {
  FitnessItem fitnessItem;
  final int index;
  final void Function(String, int, int, int, int) onSubmit;

  TrainingFitnessFormComponents(
      {required this.fitnessItem, required this.onSubmit, required this.index});

  @override
  State<TrainingFitnessFormComponents> createState() =>
      _TrainingFitnessFormComponentsState();
}

class _TrainingFitnessFormComponentsState
    extends State<TrainingFitnessFormComponents> {
  final _form = GlobalKey<FormState>();

  bool _isLoading = true;
  bool _isRepetition = false;
  bool _isTime = false;
  bool _isUpdate = false;

  String? _fitness;
  Duration _duration = Duration.zero;
  TextEditingController _controllerRepetition = TextEditingController();
  TextEditingController _controllerQtdRepetition = TextEditingController();

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
    if (widget.fitnessItem.fitness.isNotEmpty) {
      _fitness = widget.fitnessItem.fitness;

      final isSerie = widget.fitnessItem.qdtRepetitions != 0 &&
          widget.fitnessItem.repetitions != 0;
      if (isSerie) {
        _isRepetition = true;
        _controllerRepetition.text = widget.fitnessItem.repetitions.toString();
        _controllerQtdRepetition.text =
            widget.fitnessItem.qdtRepetitions.toString();
      }

      final isTime = widget.fitnessItem.time != 0;
      if (isTime) {
        _isTime = true;
        _duration = Duration(minutes: widget.fitnessItem.time);
      }

      _isUpdate = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshListFitness(BuildContext context) async {
    return Provider.of<FitnessList>(context, listen: false).loadListFitness();
  }

  _pickerDuration() async {
    final resultDuration = (await showDurationPicker(
      context: context,
      initialTime: Duration(minutes: 0),
      baseUnit: BaseUnit.minute,
    ));

    if (!mounted) return;

    setState(() {
      _duration = resultDuration!;
      widget.fitnessItem.time = _duration.inMinutes;
    });
  }

  void validate() {
    final isValid = _form.currentState?.validate() ?? false;

    if (!isValid) return;

    _form.currentState?.save();

    if (_controllerRepetition.text.isEmpty) {
      _controllerRepetition.text = '0';
    }
    if (_controllerQtdRepetition.text.isEmpty) {
      _controllerQtdRepetition.text = '0';
    }

    if (_isTime && _duration.inMinutes == 0) {
      _showDialog(_fitness!);
      return;
    }

    if (!_isUpdate) {
      widget.onSubmit(
        _fitness!,
        int.parse(_controllerRepetition.text),
        int.parse(_controllerQtdRepetition.text),
        _duration.inMinutes,
        widget.index,
      );
    } else {
      widget.onSubmit(
        _fitness!,
        int.parse(_controllerRepetition.text),
        int.parse(_controllerQtdRepetition.text),
        _duration.inMinutes,
        widget.index,
      );
      Navigator.of(context).pop();
    }

    setState(() {
      _fitness = null;
      _duration = Duration.zero;
      _controllerQtdRepetition.clear();
      _controllerRepetition.clear();
      widget.fitnessItem = FitnessItem();
      _isRepetition = false;
      _isTime =false;
    });
  }

  void _showDialog(String fitness) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Campo tempo obrigatório'),
        content: Text(
            'Exercício $fitness não cadastrado, favor informar o tempo de duração do exercício'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Sair'),
          ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    final listFitness = Provider.of<FitnessList>(context, listen: false);
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return _isLoading
        ? Container(
            height: 120,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Nenhum exercício foi cadastrado'),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Sair'),
                  ),
                ],
              ),
            ),
          )
        : SingleChildScrollView(
            child: Container(
              height: 260 + keyboardHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.zero,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RefreshIndicator(
                  onRefresh: () => _refreshListFitness(context),
                  child: listFitness.listFitness.where((ele) {
                   return ele.name == _fitness;
                  }).isEmpty && _isUpdate
                      ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Exercício $_fitness não existe mais na lista, favor cadastrar o exercício escolhido ou exclua este da lista de treino'),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.exit_to_app),
                              label: Text('Sair'),
                            ),
                          ],
                        ),
                      )
                      : Form(
                          key: _form,
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  width: 390,
                                  child: DropdownButtonFormField<String>(
                                    validator: (value) => value == null
                                        ? 'Selecione o Exercício'
                                        : null,
                                    decoration: DecorationForm()
                                        .decorationDropDown(
                                            context, 'Exercício'),
                                    isExpanded: false,
                                    hint: Text('Selecione o Exercício'),
                                    items: listFitness.listFitness.map((e) {
                                      return DropdownMenuItem(
                                        value: e.name,
                                        child: Text(e.name),
                                      );
                                    }).toList(),
                                    value: _fitness,
                                    onChanged: (option) {
                                      setState(() {
                                        _fitness = option!;
                                        _isRepetition = listFitness.listFitness
                                            .where((value) {
                                              return value.name == _fitness;
                                            })
                                            .first
                                            .isRepetition;
                                        _isTime = listFitness.listFitness
                                            .where((value) {
                                              return value.name == _fitness;
                                            })
                                            .first
                                            .isTime;

                                        _duration = Duration.zero;
                                        _controllerQtdRepetition.clear();
                                        _controllerRepetition.clear();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              if (_isRepetition)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          controller: _controllerRepetition,
                                          validator: (_value) {
                                            final value = _value ?? '';
                                            if (value.isEmpty) {
                                              return 'Campo obrigatório esta vazio';
                                            }
                                            if (int.parse(value) == 0) {
                                              return 'Informe um valor maior que 0';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: DecorationForm()
                                              .decorationTextField(
                                                  context, 'Série'),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          onFieldSubmitted: (value) =>
                                              validate(),
                                          controller: _controllerQtdRepetition,
                                          validator: (_value) {
                                            final value = _value ?? '';
                                            if (value.isEmpty) {
                                              return 'Campo obrigatório esta vazio';
                                            }
                                            if (int.parse(value) == 0) {
                                              return 'Informe um valor maior que 0';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          decoration: DecorationForm()
                                              .decorationTextField(
                                                  context, 'Repetições'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 10),
                              if (_isTime)
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _duration.inMinutes == 0
                                            ? 'Defina o tempo do Exercício'
                                            : 'Tempo: ${_duration.inMinutes} min',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _pickerDuration,
                                        child: Text(
                                          'Selecionar Tempo',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.exit_to_app),
                                    label: Text('Sair'),
                                  ),
                                  TextButton.icon(
                                    onPressed: validate,
                                    icon: Icon(
                                        _isUpdate ? Icons.update : Icons.add),
                                    label: Text(_isUpdate
                                        ? 'Alterar Exercício'
                                        : 'Adicionar Exercício'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          );
  }
}
