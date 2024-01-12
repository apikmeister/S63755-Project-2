import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_management/models/subject.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/providers/subject_provider.dart';
import 'package:school_management/services/result_service.dart';

class EditResultScreen extends StatelessWidget {
  EditResultScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> gradeItems = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
  ];

  String gradeValue = '';
  String subjectValue = '';

  @override
  Widget build(BuildContext context) {
    final bool isEdit =
        Provider.of<MembersProvider>(context).processType == 'Edit';
    void submitResult() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        isEdit
            ? ResultService().updateResult(
                context: context,
                gradeId: Provider.of<SubjectProvider>(context, listen: false)
                    .getGradeId!
                    .toString(),
                gradeLevel: gradeValue,
              )
            : ResultService().addResult(
                context: context,
                studentId: Provider.of<MembersProvider>(context, listen: false)
                    .getMemberId!,
                subjectId: subjectValue,
                gradeLevel: gradeValue,
                term: Provider.of<SubjectProvider>(context, listen: false)
                    .getSubjectTerm!,
              );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Result Screen'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: isEdit
                        ? FutureBuilder(
                            future: ResultService().getResult(
                              context: context,
                              studentId: Provider.of<MembersProvider>(context)
                                  .getMemberId!,
                            ),
                            builder: (context, snapshot) => snapshot.hasData
                                ? TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Subject Name',
                                    ),
                                    initialValue: snapshot.data!.result!
                                        .firstWhere((element) =>
                                            element.subjectId ==
                                            Provider.of<SubjectProvider>(
                                                    context)
                                                .getSubjectName!)
                                        .subjectId,
                                    onSaved: (value) {
                                      subjectValue = value!;
                                    },
                                    enabled: false,
                                  )
                                : const CircularProgressIndicator(),
                          )
                        : FutureBuilder<SubjectList>(
                            future: ResultService().getSubjects(
                              context: context,
                              classId: '1',
                            ),
                            builder: (BuildContext context,
                                AsyncSnapshot<SubjectList> snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButtonFormField2<String>(
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                                    // the menu padding when button's width is not specified.
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  hint: const Text(
                                    'Grade',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  items: snapshot.data!.subject!
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.subjectID,
                                            child: Text(
                                              item.subjectID!,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select gender.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    //Do something when selected item is changed.
                                  },
                                  onSaved: (value) {
                                    // selectedValue = value.toString();
                                    subjectValue = value!;
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.only(right: 8),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 24,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField2<String>(
                      isExpanded: true,
                      value: isEdit
                          ? Provider.of<SubjectProvider>(context, listen: false)
                              .getSubjectGrade
                          : null,
                      decoration: InputDecoration(
                        // Add Horizontal padding using menuItemStyleData.padding so it matches
                        // the menu padding when button's width is not specified.
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        // Add more decoration..
                      ),
                      hint: const Text(
                        'Grade',
                        style: TextStyle(fontSize: 14),
                      ),
                      items: gradeItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select gender.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        //Do something when selected item is changed.
                      },
                      onSaved: (value) {
                        // selectedValue = value.toString();
                        gradeValue = value!;
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  submitResult();
                },
                child: const Text('Update Result'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
