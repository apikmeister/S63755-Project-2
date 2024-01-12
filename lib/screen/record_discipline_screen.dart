import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_management/providers/members_provider.dart';

class RecordDisciplineScreen extends StatefulWidget {
  const RecordDisciplineScreen({super.key});

  @override
  State<RecordDisciplineScreen> createState() => _RecordDisciplineScreenState();
}

class _RecordDisciplineScreenState extends State<RecordDisciplineScreen> {
  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat.yMd()
        .format(DateTime.now()); // Set initial value to current date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Discipline'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                ),
                initialValue:
                    Provider.of<MembersProvider>(context, listen: false)
                        .memberId!,
                readOnly: true,
                enabled: false,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Discipline',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      // Below line stops keyboard from appearing
                      FocusScope.of(context).requestFocus(FocusNode());

                      // Show Date Picker here
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        // Format the date and set it to the controller text
                        dateController.text =
                            DateFormat.yMd().format(pickedDate);
                      }
                    },
                  ),
                ),
                // initialValue: DateTime.now().toString(),
                controller: dateController,
                readOnly:
                    true, // Make this field read-only to prevent keyboard popup
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
