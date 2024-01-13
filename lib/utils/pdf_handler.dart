import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:school_management/models/result.dart';

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
  static Future<File> generatePDF(String currTerm, Results results) async {
    final pdf = Document();

    // pdf.addPage(
    //   MultiPage(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (context) => [
    //       _buildHeader(),
    //       SizedBox(height: 3 * PdfPageFormat.cm),
    //       TableHelper.fromTextArray(
    //         cellAlignment: Alignment.center,
    //         context: context,
    //         data: [
    //           ['Subject', 'Score', 'Grade'],
    //           ['Mathematics', '90', 'A'],
    //           ['English', '80', 'B'],
    //           ['Physics', '70', 'C'],
    //           ['Chemistry', '60', 'D'],
    //           ['Biology', '50', 'E'],
    //         ],
    //       ),
    //     ],
    //   ),
    // );
    var term = results.result!.map((results) => results.term).toSet().toList();
    pdf.addPage(
      Page(
        build: (Context context) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${results.student!.firstName} '
                        '${results.student!.lastName}'),
                    Text('Class: ${results.student!.className}'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    Text(
                      'Subject Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Grade Level',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                ...results.result!.map((item) {
                  if (item.term == currTerm) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('${item.subjectId} ${item.subjectName!}'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            item.gradeLevel!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return TableRow(children: [
                      SizedBox(),
                      SizedBox(),
                    ]);
                  }
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );

    final file = await PdfHandler.saveDocument(
      name: 'Result ${results.student!.firstName} .pdf',
      pdf: pdf,
    );

    return file;
  }

  static Future<File> generateWarningLetter({
    required String studentName,
    required int merits,
  }) async {
    final pdf = Document();

    pdf.addPage(
      Page(
        build: (Context context) => Center(
          child: Column(
            children: [
              Text('Warning Letter', style: TextStyle(fontSize: 40)),
              SizedBox(height: 20),
              Text('Dear $studentName,', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text(
                'This letter is to inform you that you currently have $merits merits left. '
                'Please be aware that if your merit count falls below 10, you may face disciplinary action.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Please take this warning seriously. We encourage you to improve your behavior and increase your merit count.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text('Sincerely,', style: TextStyle(fontSize: 20)),
              Text('School Administration', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/warning_letter.pdf");
    await file.writeAsBytes(await pdf.save());

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
