// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gerador_de_treinos/models/training.dart';
import 'package:gerador_de_treinos/utils/pdf_config.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  PrintingInfo? printingInfo;
  Training? training;

  @override
  void initState(){
    super.initState();
    _init();
  }

  Future<void> _init() async{
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
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
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: Icon(Icons.save),
          onPressed: PdfConfig().saveAsFile,
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Treino de ${training!.nameClient}'),
      ),
      body: PdfPreview(
        actions: actions,
        onPrinted: PdfConfig().showSharedToast,
        onShared: PdfConfig().showSharedToast,
        build: (_) =>  PdfConfig().generatedPdf(training!,_),
      ),
    );
  }
}
