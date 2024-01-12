import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/services/discipline_service.dart';

class EditDisciplineScreen extends StatelessWidget {
  const EditDisciplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Discipline Record'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [EditDisciplineForm()],
        ),
      ),
    );
  }
}

class EditDisciplineForm extends StatefulWidget {
  const EditDisciplineForm({
    super.key,
  });

  @override
  State<EditDisciplineForm> createState() => _EditDisciplineFormState();
}

class _EditDisciplineFormState extends State<EditDisciplineForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController descriptionController = TextEditingController();
  TextEditingController scoreController = TextEditingController();

  void addDisciplineRecord() {
    if (_formKey.currentState!.validate()) {
      DisciplineService().addDisciplineRecords(
        context: context,
        userId: Provider.of<MembersProvider>(context, listen: false)
            .getMemberId!, //FIXME: why?
        incidentDate: dateController.text,
        description: descriptionController.text,
        score: scoreController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Student ID',
            ),
            enabled: false,
            initialValue: Provider.of<MembersProvider>(context, listen: false)
                .getMemberId!,
          ),
          TextFormField(
            controller: dateController,
            decoration: InputDecoration(
              labelText: 'Date',
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365 * 1)),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    // Format the date as a string and set it as the text of the TextFormField
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a date';
              }
              return null;
            },
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          TextFormField(
            controller: scoreController,
            decoration: const InputDecoration(
              labelText: 'Score',
            ),
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
          ),
          ElevatedButton(
            onPressed: () {
              addDisciplineRecord();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
