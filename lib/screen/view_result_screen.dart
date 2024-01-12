import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management/models/result.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/providers/subject_provider.dart';
import 'package:school_management/services/result_service.dart';
import 'package:school_management/utils/pdf_handler.dart';

class ViewResultScreen extends StatefulWidget {
  const ViewResultScreen({super.key});

  @override
  State<ViewResultScreen> createState() => _ViewResultScreenState();
}

class _ViewResultScreenState extends State<ViewResultScreen> {
  late Future<Results> futureResults;
  String currTerm = "";

  @override
  void initState() {
    super.initState();
    futureResults = ResultService().getResult(
      context: context,
      studentId: Provider.of<MembersProvider>(context, listen: false)
          .getMemberId!, // replace with actual studentId
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: FutureBuilder(
          future: ResultService().getResult(
            context: context,
            studentId: Provider.of<MembersProvider>(context, listen: false)
                .getMemberId!,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var term = snapshot.data!.result!
                  .map((results) => results.term)
                  .toSet()
                  .toList();
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${snapshot.data!.student!.firstName} '
                              '${snapshot.data!.student!.lastName}'),
                          // Text('Student ID: ${snapshot.data!.student!.id}'),
                        ],
                      ),
                      Text('Class: ${snapshot.data!.student!.className}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: term
                              .map<Widget>((e) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currTerm = e.toString();
                                      });
                                      Provider.of<SubjectProvider>(context,
                                              listen: false)
                                          .setSubjectTerm(e.toString());
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(e.toString()),
                                      ),
                                    ),
                                  ))
                              .toList()),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            currTerm = "";
                          });
                        },
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: currTerm != ""
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: {
                                    0: FlexColumnWidth(4),
                                    1: FlexColumnWidth(2),
                                    2: FlexColumnWidth(1),
                                  },
                                  // border: TableBorder.all(color: Colors.black),
                                  children: [
                                    TableRow(
                                      children: [
                                        Text(
                                          'Subject Name',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Grade Level',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox
                                            .shrink(), // Empty cell for the edit button column
                                      ],
                                    ),
                                    ...snapshot.data!.result!.map((item) {
                                      if (item.term == currTerm) {
                                        return TableRow(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  '${item.subjectId} ${item.subjectName!}'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item.gradeLevel!,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Provider.of<MembersProvider>(
                                                        context,
                                                        listen: false)
                                                    .setProcessType(
                                                  'Edit',
                                                );
                                                Provider.of<MembersProvider>(
                                                        context,
                                                        listen: false)
                                                    .setClassId(
                                                  snapshot
                                                      .data!.student!.classId!
                                                      .toString(),
                                                );
                                                Provider.of<SubjectProvider>(
                                                        context,
                                                        listen: false)
                                                    .setGradeId(
                                                  item.gradeId!,
                                                );
                                                Provider.of<SubjectProvider>(
                                                        context,
                                                        listen: false)
                                                    .setSubjectName(
                                                  item.subjectId!,
                                                );
                                                Provider.of<SubjectProvider>(
                                                        context,
                                                        listen: false)
                                                    .setSubjectGrade(
                                                  item.gradeLevel!,
                                                );
                                                Navigator.pushNamed(
                                                    context, '/edit-result');
                                              },
                                              icon: Icon(Icons.edit),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return TableRow(
                                            children: [SizedBox(), SizedBox()]);
                                      }
                                    }).toList(),
                                  ]),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Provider.of<MembersProvider>(context,
                                          listen: false)
                                      .setProcessType(
                                    'Add',
                                  );
                                  Provider.of<MembersProvider>(context,
                                          listen: false)
                                      .setClassId(
                                    snapshot.data!.student!.classId!.toString(),
                                  );
                                  Navigator.pushNamed(context, '/edit-result');
                                },
                                child: Text('Add Result'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final pdfFile =
                                      await PdfGenerator.generatePDF();

                                  PdfHandler.openFile(pdfFile);
                                },
                                child: Text('Print'),
                              ),
                            ],
                          )
                        : Container(
                            child: Center(
                              child: Text('test'),
                            ),
                          ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }
}
