import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_management/models/discipline.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/services/discipline_service.dart';

class AddDisciplineScreen extends StatelessWidget {
  const AddDisciplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discipline Record'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [AddDisciplineForm()],
        ),
      ),
    );
  }
}

class AddDisciplineForm extends StatefulWidget {
  const AddDisciplineForm({
    super.key,
  });

  @override
  State<AddDisciplineForm> createState() => _AddDisciplineFormState();
}

class _AddDisciplineFormState extends State<AddDisciplineForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  String description = '';
  String score = '';

  @override
  Widget build(BuildContext context) {
    final bool isEdit =
        Provider.of<MembersProvider>(context, listen: false).processType ==
            'Edit';
    Future<Discipline> fetchDisciplineRecord() async {
      var discpline = await DisciplineService().getSingleRecord(
        context: context,
        recordId:
            Provider.of<MembersProvider>(context, listen: false).disciplineId!,
      );
      return discpline;
    }

    void submitForm() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        isEdit
            ? DisciplineService().updateDisciplineRecord(
                context: context,
                recordId: Provider.of<MembersProvider>(context, listen: false)
                    .disciplineId!,
                incidentDate: date,
                description: description,
                score: score,
              )
            : DisciplineService().addDisciplineRecords(
                context: context,
                userId: Provider.of<MembersProvider>(context, listen: false)
                    .getMemberId!, //FIXME: why?
                incidentDate: date,
                description: description,
                score: score,
              );
      }
    }

    return FutureBuilder<Discipline>(
        future: isEdit ? fetchDisciplineRecord() : Future.value(Discipline()),
        builder: (BuildContext context, AsyncSnapshot<Discipline> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading spinner while waiting for future to complete
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Student ID',
                    ),
                    enabled: false,
                    initialValue:
                        Provider.of<MembersProvider>(context, listen: false)
                            .getMemberId!,
                  ),
                  TextFormField(
                    // controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 365 * 1)),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            // Format the date as a string and set it as the text of the TextFormField
                            date = DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                      ),
                    ),
                    initialValue: isEdit
                        ? DateFormat('yyyy-MM-dd').format(
                            DateTime.parse(snapshot.data!.incidentDate!))
                        : date,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      date = value!;
                    },
                  ),
                  TextFormField(
                    // controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    initialValue: isEdit ? snapshot.data!.description! : '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      description = value!;
                    },
                  ),
                  TextFormField(
                    // controller: scoreController,
                    decoration: const InputDecoration(
                      labelText: 'Score',
                    ),
                    initialValue: isEdit ? snapshot.data!.score! : '',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a score';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      score = value!;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submitForm();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          }
        });
  }
}
