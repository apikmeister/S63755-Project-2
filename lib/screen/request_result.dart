import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management/providers/members_provider.dart';

class RequestResultScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String icNo = '';

  RequestResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void submitForm() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        Provider.of<MembersProvider>(context, listen: false)
            .setProtected('Unprotected');
        Provider.of<MembersProvider>(context, listen: false).setMemberId(icNo);
        Navigator.pushNamed(context, '/view-result');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Result'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                // controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'IC No',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a IC Number';
                  } else if (value.length > 12) {
                    return 'Value must be not more than 12';
                  }
                  return null;
                },
                onSaved: (value) {
                  icNo = value!;
                  // value = icNo;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  submitForm();
                },
                child: const Text('Check Result'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
