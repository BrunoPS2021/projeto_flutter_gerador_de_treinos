// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_field, prefer_collection_literals, prefer_final_fields, use_build_context_synchronously, iterable_contains_unrelated_type, avoid_print, dead_code

import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/components/decoration_form.dart';
import 'package:gerador_de_treinos/exceptions/http_exception.dart';
import 'package:gerador_de_treinos/models/fitness.dart';
import 'package:gerador_de_treinos/models/fitness_list.dart';
import 'package:provider/provider.dart';

class FitnessFormScreen extends StatefulWidget {
  const FitnessFormScreen({super.key});

  @override
  State<FitnessFormScreen> createState() => _FitnessFormScreenState();
}

class _FitnessFormScreenState extends State<FitnessFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final fitness = arg as Fitness;
        _formData['id'] = fitness.id;
        _formData['name'] = fitness.name;
        _formData['isRepetition'] = fitness.isRepetition;
        _formData['isTime'] = fitness.isTime;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    final isValidOptionSwitchRepetition =
        _formData['isRepetition']?.toString() == null ? false : true;
    final isValidOptionSwitchTime =
        _formData['isTime']?.toString() == null ? false : true;

    if (!isValidOptionSwitchRepetition) {
      _formData['isRepetition'] = _isRepetition;
    }

    if (!isValidOptionSwitchTime) {
      _formData['isTime'] = _isTime;
    }

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<FitnessList>(context, listen: false).saveFitness(
        _formData,
      );
      Navigator.of(context).pop();
    } on HttpException catch (httpError) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text(httpError.msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro para salvar o exercício'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _isRepetition = true;
  bool _isTime = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Exercício'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  children: [
                    TextFormField(
                      decoration: DecorationForm().decorationTextField(
                        context,
                        'Nome do Exercício',
                      ),
                      validator: (_name) {
                        final name = _name ?? '';

                        if (name.trim().isEmpty) {
                          return 'Nome é obrigatório!';
                        }

                        if (name.trim().length < 3) {
                          return 'Nome precisa no mínimo de 3 letras!';
                        }

                        return null;
                      },
                      onSaved: (name) => _formData['name'] = name ?? '',
                      initialValue: _formData['name']?.toString(),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Exercício por série?'),
                        Switch(
                          value: _formData['isRepetition']?.toString() == null
                              ? _isRepetition
                              : _formData['isRepetition'] as bool,
                          onChanged: (value) {
                            setState(() {
                              _formData['isRepetition'] = value;
                              _formData['isTime'] = !value;
                            });
                          },
                        ),
                        Text('Exercício por tempo?'),
                        Switch(
                          value: _formData['isTime']?.toString() == null
                              ? _isTime
                              : _formData['isTime'] as bool,
                          onChanged: (value) {
                            setState(() {
                              _formData['isTime'] = value;
                              _formData['isRepetition'] = !value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
