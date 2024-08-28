// ignore_for_file: prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_de_treinos/models/training.dart';
import 'package:gerador_de_treinos/utils/constants.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfConfig {
  Future<void> saveAsFile(
    final BuildContext context,
    final LayoutCallback build,
    final PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/documento${Random().nextDouble()}.pdf');

    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  void showPrintedToast(final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documento impresso com sucesso'),
      ),
    );
  }

  void showSharedToast(final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Documento encontrado com sucesso'),
      ),
    );
  }

  Future<Uint8List> generatedPdf(
      Training training, PdfPageFormat format) async {
    final doc = pw.Document(
      title: 'Treino de ${training.nameClient}',
    );

    /*final logoImage = pw.MemoryImage(
      (await rootBundle.load('')).buffer.asUint8List(),
    );

    final footerImage = pw.MemoryImage(
      (await rootBundle.load('')).buffer.asUint8List(),
    );

*/
    final font = await rootBundle.load('assets/arlrdbd.ttf');
    final ttf = pw.Font.ttf(font);

    final pageTheme = await _myPageTheme(format);

    doc.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        header: (ctx) => pw.Center(
          child: pw.Container(
            alignment: pw.Alignment.center,
            height: 115,
            width: 320,
            child: pw.Stack(
              children: [
                pw.Positioned(
                  child: pw.Text(
                    '|',
                    style: pw.TextStyle(
                      fontSize: 78,
                      color: PdfColors.red,
                      fontWeight: pw.FontWeight.bold,
                      font: ttf,
                    ),
                  ),
                ),
                pw.Positioned(
                  left: 45,
                  bottom: 35,
                  child: pw.Text(
                    'MEXA-SE!',
                    style: pw.TextStyle(
                      fontSize: 48,
                      color: PdfColors.red,
                      fontWeight: pw.FontWeight.bold,
                      font: ttf,
                    ),
                  ),
                ),
                pw.Positioned(
                  bottom: 15,
                  left: 35,
                  child: pw.Text(
                    'PLANOS DE TREINOS DE DEYSE',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      font: ttf,
                    ),
                  ),
                ),
                pw.Positioned(
                  right: 0,
                  child: pw.Text(
                    '|',
                    style: pw.TextStyle(
                      fontSize: 78,
                      color: PdfColors.red,
                      fontWeight: pw.FontWeight.bold,
                      font: ttf,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        /*footer: (ctx) => pw.Image(
          footerImage,
          fit: pw.BoxFit.scaleDown,
        ),*/
        build: (ctx) => [
          pw.Container(
            padding: pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.ListView.builder(
              itemCount: training.trainingItem.length,
              itemBuilder: (ctx, i) => pw.Column(
                children: [
                  pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    width: double.infinity,
                    color: PdfColor.fromInt(
                        training.trainingItem[i].colorTraining),
                    child: pw.Text(
                      'TREINO ${Constants.ALFABETO[training.trainingItem[i].posicaoTraining]}',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        font: ttf,
                        fontSize: 16,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Container(
                    width: double.infinity,
                    child: pw.Table(
                      columnWidths: {
                        0: pw.FlexColumnWidth(25),
                        1: pw.FixedColumnWidth(270),
                      },
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                      ),
                      defaultVerticalAlignment:
                          pw.TableCellVerticalAlignment.middle,
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Text(
                              'Exercício',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                font: ttf,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(horizontal: 55),
                              child: pw.Row(
                                children: [
                                  pw.Text(
                                    'Série',
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,
                                      font: ttf,
                                    ),
                                    textAlign: pw.TextAlign.end,
                                  ),
                                  pw.Container(
                                    height: 20,
                                    width: 80,
                                    child: pw.VerticalDivider(
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pw.Text(
                                    'Repetições',
                                    style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,
                                      font: ttf,
                                    ),
                                    textAlign: pw.TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ...List.generate(
                            training.trainingItem[i].fitnessItems.length,
                            (index) {
                          return pw.TableRow(
                            children: training.trainingItem[i]
                                        .fitnessItems[index].time !=
                                    0
                                ? [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Row(
                                        children: [
                                          pw.Text(
                                            '${index + 1}',
                                            style: pw.TextStyle(
                                              font: ttf,
                                              fontSize: 12,
                                            ),
                                            textAlign: pw.TextAlign.center,
                                          ),
                                          pw.Container(
                                            height: 20,
                                            width: 10,
                                            child: pw.VerticalDivider(
                                              color: PdfColors.black,
                                            ),
                                          ),
                                          pw.Text(
                                            training.trainingItem[i]
                                                .fitnessItems[index].fitness,
                                            style: pw.TextStyle(
                                              fontSize: 12,
                                              font: ttf,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    pw.Text(
                                      '${training.trainingItem[i].fitnessItems[index].time}min',
                                      style: pw.TextStyle(
                                        fontSize: 12,
                                        font: ttf,
                                      ),
                                      textAlign: pw.TextAlign.center,
                                    ),
                                  ]
                                : [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Row(
                                        children: [
                                          pw.Text(
                                            '${index + 1}',
                                            style: pw.TextStyle(
                                              font: ttf,
                                              fontSize: 12,
                                            ),
                                            textAlign: pw.TextAlign.center,
                                          ),
                                          pw.Container(
                                            height: 20,
                                            width: 10,
                                            child: pw.VerticalDivider(
                                              color: PdfColors.black,
                                            ),
                                          ),
                                          pw.Text(
                                            training.trainingItem[i]
                                                .fitnessItems[index].fitness,
                                            style: pw.TextStyle(
                                              fontSize: 12,
                                              font: ttf,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 70),
                                      child: pw.Row(
                                        children: [
                                          pw.Text(
                                            '${training.trainingItem[i].fitnessItems[index].repetitions}x',
                                            style: pw.TextStyle(
                                              fontSize: 12,
                                              font: ttf,
                                            ),
                                          ),
                                          pw.Container(
                                            height: 20,
                                            width: 95,
                                            child: pw.VerticalDivider(
                                              color: PdfColors.black,
                                            ),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 25),
                                            child: pw.Text(
                                              '${training.trainingItem[i].fitnessItems[index].qdtRepetitions}',
                                              style: pw.TextStyle(
                                                fontSize: 12,
                                                font: ttf,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                          );
                        }),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return doc.save();
  }

  Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
    /* final logoImage = pw.MemoryImage(
      (await rootBundle.load('')).buffer.asUint8List(),
    );
*/
    return pw.PageTheme(
      margin: pw.EdgeInsets.symmetric(
        horizontal: 1 * PdfPageFormat.cm,
        vertical: 0.5 * PdfPageFormat.cm,
      ),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      /*buildBackground: (ctx) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Watermark(
          angle: 20,
          child: pw.Opacity(
            opacity: 0.5,
            child: pw.Image(
              alignment: pw.Alignment.center,
              logoImage,
              fit: pw.BoxFit.cover,
            ),
          ),
        ),
      ),*/
    );
  }
}
