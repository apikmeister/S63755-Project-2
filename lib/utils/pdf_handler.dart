import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfHandler {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}

class PdfGenerator {
  static Future<File> generatePDF() async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(),
          SizedBox(height: 3 * PdfPageFormat.cm),
          TableHelper.fromTextArray(
            cellAlignment: Alignment.center,
            context: context,
            data: [
              ['Subject', 'Score', 'Grade'],
              ['Mathematics', '90', 'A'],
              ['English', '80', 'B'],
              ['Physics', '70', 'C'],
              ['Chemistry', '60', 'D'],
              ['Biology', '50', 'E'],
            ],
          ),
        ],
      ),
    );

    final file = await PdfHandler.saveDocument(
      name: 'example.pdf',
      pdf: pdf,
    );

    return file;
  }

  static Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: '),
            Text('Student ID: '),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Class: '),
            Text('Term: '),
          ],
        ),
      ],
    );
  }
}
