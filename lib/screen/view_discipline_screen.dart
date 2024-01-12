import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management/providers/data_provider.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/services/discipline_service.dart';

class ViewDisciplineScreen extends StatelessWidget {
  ViewDisciplineScreen({super.key});

  final int initialDisciplineScore = 100;
  List<String> scores = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<DataNotifier>(
      builder: (context, dataNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('View Discipline Records'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: DisciplineService().getDisciplineRecords(
                context: context,
                userId: Provider.of<MembersProvider>(context, listen: false)
                    .getMemberId!, //FIXME: why lmao
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  for (var i = 0; i < snapshot.data!.discipline!.length; i++) {
                    scores.add(snapshot.data!.discipline![i].score!);
                  }
                  var totalScore = scores.isNotEmpty
                      ? (initialDisciplineScore -
                              scores
                                  .map((e) => int.parse(e))
                                  .reduce((value, element) => value + element))
                          .toString()
                      : initialDisciplineScore.toString();
                  ;
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
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(3),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(1),
                                },
                                children: [
                                  const TableRow(
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
                                  ...snapshot.data!.discipline!.map((item) {
                                    return TableRow(
                                      children: [
                                        Text(item.description!),
                                        Text(
                                          item.score!,
                                          textAlign: TextAlign.center,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            Provider.of<MembersProvider>(
                                                    context,
                                                    listen: false)
                                                .setProcessType('Edit');
                                            Provider.of<MembersProvider>(
                                                    context,
                                                    listen: false)
                                                .setDisciplineId(
                                                    item.recordID.toString());
                                            Navigator.pushNamed(
                                                context, '/add-discipline');
                                          },
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Score',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            totalScore,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<MembersProvider>(context, listen: false)
                              .setProcessType('Add');
                          Navigator.pushNamed(context, '/add-discipline');
                        },
                        child: const Text('Add New Records'),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text('No data'));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
