import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:school_management/models/student.dart';
import 'package:school_management/models/teacher.dart';
import 'package:school_management/providers/data_provider.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/services/student_service.dart';
import 'package:school_management/services/teacher_service.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:school_management/widgets/shared/toast.dart';
import 'package:toastification/toastification.dart';

class LazyRowPagination extends StatefulWidget {
  const LazyRowPagination({super.key});

  @override
  State<LazyRowPagination> createState() => _LazyRowPaginationState();
}

class _LazyRowPaginationState extends State<LazyRowPagination> {
  late final PlutoGridStateManager stateManager;

  final List<PlutoColumn> columns = [];

  final List<PlutoRow> rows = [];

  @override
  void initState() {
    super.initState();
    final bool isStudent =
        Provider.of<MembersProvider>(context, listen: false).memberType ==
            'Student';
    isStudent
        ? columns.addAll(
            [
              PlutoColumn(
                title: 'Edit',
                field: 'editUser',
                width: 50,
                frozen: PlutoColumnFrozen.start,
                type: PlutoColumnType.text(),
                renderer: (rendererContext) => IconButton(
                  onPressed: () {
                    Provider.of<MembersProvider>(context, listen: false)
                        .setMemberId(rendererContext.row.cells['userId']!.value
                            .toString());
                    Provider.of<MembersProvider>(context, listen: false)
                        .setProcessType('Edit');
                    Navigator.pushNamed(
                      context,
                      '/add-member',
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              PlutoColumn(
                title: 'User ID',
                field: 'userId',
                type: PlutoColumnType.text(),
                width: 100,
                frozen: PlutoColumnFrozen.start,
                enableEditingMode: false,
              ),
              PlutoColumn(
                title: 'First Name',
                field: 'firstName',
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                title: 'Last Name',
                field: 'lastName',
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                title: 'Gender',
                field: 'gender',
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                title: 'Class Name',
                field: 'className',
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                title: 'Discipline Record',
                field: 'viewDisciplineRecord',
                type: PlutoColumnType.text(),
                renderer: (rendererContext) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (rendererContext.row.cells['className']!.value ==
                          'Class not assigned') {
                        showErrorToast(context, 'Please assign class first!');
                        // ScaffoldMessenger.of(context)
                        //   ..hideCurrentSnackBar()
                        //   ..showSnackBar(
                        //       errorSnackBar('Please assign class first!'));
                      } else {
                        Provider.of<MembersProvider>(context, listen: false)
                            .setMemberId(rendererContext
                                .row.cells['userId']!.value
                                .toString());

                        Navigator.pushNamed(context, '/view-discipline');
                      }
                    },
                    child: Text('View Record'),
                  ),
                ),
              ),
              PlutoColumn(
                title: 'View Result',
                field: 'viewResultUrl',
                type: PlutoColumnType.text(),
                renderer: (rendererContext) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (rendererContext.row.cells['className']!.value ==
                          'Class not assigned') {
                        // ScaffoldMessenger.of(context)
                        //   ..hideCurrentSnackBar()
                        //   ..showSnackBar(
                        //       errorSnackBar('Please assign class first!'));
                        showErrorToast(context, 'Please assign class first!');
                      } else {
                        Provider.of<MembersProvider>(context, listen: false)
                            .setMemberId(rendererContext
                                .row.cells['userId']!.value
                                .toString());

                        Navigator.pushNamed(context, '/view-result');
                      }
                    },
                    child: Text('View Result'),
                  ),
                ),
              ),
            ],
          )
        : columns.addAll(
            [
              PlutoColumn(
                title: 'Edit',
                field: 'editUser',
                width: 50,
                frozen: PlutoColumnFrozen.start,
                type: PlutoColumnType.text(),
                renderer: (rendererContext) => IconButton(
                  onPressed: () {
                    Provider.of<MembersProvider>(context, listen: false)
                        .setMemberId(rendererContext.row.cells['userId']!.value
                            .toString());
                    Provider.of<MembersProvider>(context, listen: false)
                        .setProcessType('Edit');
                    Navigator.pushNamed(
                      context,
                      '/add-member',
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
              PlutoColumn(
                title: 'User ID',
                field: 'userId',
                width: 100,
                frozen: PlutoColumnFrozen.start,
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                title: 'First Name',
                field: 'firstName',
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                title: 'Last Name',
                field: 'lastName',
                type: PlutoColumnType.text(),
              ),
              PlutoColumn(
                title: 'Gender',
                field: 'gender',
                type: PlutoColumnType.text(),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    Future<PlutoLazyPaginationResponse> fetch(
      PlutoLazyPaginationRequest request,
    ) async {
      final bool isStudent =
          Provider.of<MembersProvider>(context, listen: false).memberType ==
              'Student';
      final page = request.page;

      var members = isStudent
          ? await StudentService().getAllStudentWithoutPagination(
              context: context,
              schoolId: 'SMKATAHAP', //FIXME:
            )
          : await TeacherService().getAllTeacher(
              context: context,
              schoolId: 'SMKATAHAP', //FIXME:
            );

      const pageSize = 11;

      final totalPage = (members.length / pageSize).ceil();

      final start = (page - 1) * pageSize;
      final end = start + pageSize;

      List<PlutoRow> fetchedRows = members
          .getRange(
        max(0, start),
        min(members.length, end),
      )
          .map((member) {
        if (member is Students) {
          return PlutoRow(
            cells: {
              'editUser': PlutoCell(value: member.userId),
              'userId': PlutoCell(value: member.userId),
              'firstName': PlutoCell(value: member.firstName),
              'lastName': PlutoCell(value: member.lastName),
              'gender': PlutoCell(value: member.gender),
              'className':
                  PlutoCell(value: member.className ?? "Class not assigned"),
              'viewDisciplineRecord': PlutoCell(value: member.userId),
              'viewResultUrl': PlutoCell(value: member.viewResultUrl),
            },
          );
        } else if (member is Teachers) {
          return PlutoRow(
            cells: {
              'editUser': PlutoCell(value: member.userId),
              'userId': PlutoCell(value: member.userId),
              'firstName': PlutoCell(value: member.firstName),
              'lastName': PlutoCell(value: member.lastName),
              'gender': PlutoCell(value: member.gender),
            },
          );
        } else {
          throw Exception('Unknown member type');
        }
      }).toList();

      return Future.value(
        PlutoLazyPaginationResponse(
          totalPage: totalPage,
          rows: fetchedRows,
        ),
      );
    }

    return Consumer<DataNotifier>(
      builder: (context, notifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${Provider.of<MembersProvider>(context, listen: false).memberType}s List',
            ),
          ),
          body: PlutoGrid(
            columns: columns,
            rows: rows,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              stateManager = event.stateManager;
              stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
              stateManager.setShowColumnFilter(true);
            },
            onChanged: (PlutoGridOnChangedEvent event) {},
            configuration: const PlutoGridConfiguration(),
            createFooter: (stateManager) {
              return PlutoLazyPagination(
                fetchWithFiltering: false,
                fetchWithSorting: false,
                fetch: fetch,
                stateManager: stateManager,
              );
            },
          ),
        );
      },
    );
  }
}
