import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_management/models/members.dart';
import 'package:school_management/models/student.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/services/student_service.dart';
import 'package:school_management/services/teacher_service.dart';

// FIXME: CHANGE TO ADD MEMBERS
class AddStudentScreen extends StatelessWidget {
  // final bool isStudent; //TODO: Implement for teacher
  const AddStudentScreen({
    super.key,
    // required this.isStudent,
  });

  @override
  Widget build(BuildContext context) {
    final bool isStudent =
        Provider.of<MembersProvider>(context, listen: false).memberType ==
            'Student';
    final String? processType =
        Provider.of<MembersProvider>(context, listen: false).getProcessType;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        // title: isStudent ? Text('Add Student') : Text('Add Teacher'),
        title: isStudent
            ? (processType == 'Edit'
                ? Text('Edit Student')
                : Text('Add Student'))
            : (processType == 'Edit'
                ? Text('Edit Teacher')
                : Text('Add Teacher')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Card(
            color: Colors.red.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.red.withOpacity(0.4)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Warning'),
                      Text(
                          'You are adding a ${Provider.of<MembersProvider>(context, listen: false).memberType}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   color: Colors.amber,
          //   height: 100,
          // ),
          // SafeArea(
          //   child:
          // Text(
          //   'Add Student',
          //   style: GoogleFonts.inter(
          //     fontSize: 24,
          //     fontWeight: FontWeight.w900,
          //     color: Colors.white,
          //   ),
          // ),
          // ),
          // Text('data'),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: (processType == 'Edit' || isStudent)
                    ? AddStudentForm()
                    : AddTeacherForm(),
                // isStudent ? AddStudentForm() : AddTeacherForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTeacherForm extends StatefulWidget {
  const AddTeacherForm({super.key});

  @override
  State<AddTeacherForm> createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  String? selectedValue;

  // form value
  String firstName = '';
  String lastName = '';
  String phone = '';
  String address = '';
  String gender = '';
  String className = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      TeacherService().addTeacher(
        context: context,
        firstName: firstName,
        lastName: lastName,
        address: address,
        gender: gender,
        className: className,
        schoolId: 'SMKATAHAP', //FIXME: change this
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextFormField(
            // cursorColor: Colors.red,
            decoration: InputDecoration(
              // labelText: 'Name',
              // floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Icon(Icons.person),
              hintText: 'Enter First Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter first name.';
              }
              return null;
            },
            onSaved: (value) {
              firstName = value.toString();
            },
          ),
          TextFormField(
            // cursorColor: Colors.red,
            decoration: InputDecoration(
              // labelText: 'Name',
              // floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: Icon(Icons.person),
              hintText: 'Enter Last Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter last name.';
              }
              return null;
            },
            onSaved: (value) {
              lastName = value.toString();
            },
          ),
          // TextFormField(
          //   decoration: InputDecoration(
          //     // labelText: 'Email',
          //     prefixIcon: Icon(Icons.email),
          //     hintText: 'Enter Email',
          //   ),
          // ),
          TextFormField(
            decoration: InputDecoration(
              // labelText: 'Phone',
              prefixIcon: Icon(Icons.phone),
              hintText: 'Enter Phone',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter phone.';
              }
              return null;
            },
            onSaved: (value) {
              phone = value.toString();
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              // labelText: 'Address',
              prefixIcon: Icon(Icons.home),
              hintText: 'Enter Address',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter address.';
              }
              return null;
            },
            onSaved: (value) {
              address = value.toString();
            },
          ),
          // DropdownButtonFormField(
          //   onChanged: (value) {},
          //   decoration: InputDecoration(
          //       prefixIcon: Icon(Icons.boy), hintText: 'Select Gender'),
          //   items: [
          //     DropdownMenuItem(
          //       child: Text('Male'),
          //     ),
          //     // DropdownMenuItem(
          //     //   child: Text('Female'),
          //     // ),
          //   ],
          // ),
          DropdownButtonFormField2<String>(
            isExpanded: true,
            decoration: InputDecoration(
              // Add Horizontal padding using menuItemStyleData.padding so it matches
              // the menu padding when button's width is not specified.
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              // Add more decoration..
            ),
            hint: const Text(
              'Select Your Gender',
              style: TextStyle(fontSize: 14),
            ),
            items: genderItems
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          Icon(
                            item == 'Male' ? Icons.male : Icons.female,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
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
              selectedValue = value.toString();
              gender = value.toString();
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
          DropdownButtonFormField2<String>(
            isExpanded: true,
            decoration: InputDecoration(
              // Add Horizontal padding using menuItemStyleData.padding so it matches
              // the menu padding when button's width is not specified.
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              // Add more decoration..
            ),
            hint: const Text(
              'Select Class',
              style: TextStyle(fontSize: 14),
            ),
            items: genderItems
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          Icon(
                            item == 'Male' ? Icons.male : Icons.female,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
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
              className = value.toString();
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
          // TextFormField(
          //   decoration: InputDecoration(
          //     labelText: 'Section',
          //     hintText: 'Enter Section',
          //   ),
          // ),
          // TextFormField(
          //   decoration: InputDecoration(
          //     labelText: 'Roll No',
          //     hintText: 'Enter Roll No',
          //   ),
          // ),
          ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              child: Text('Submit'))
        ],
      ),
    );
    ;
  }
}

class AddStudentForm extends StatefulWidget {
  const AddStudentForm({super.key});

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> genderItems = [
    'Male',
    'Female',
  ];
  String? selectedValue;

  // form value
  String firstName = '';
  String lastName = '';
  String phone = '';
  String address = '';
  String gender = '';
  String className = '';
  final studentService = StudentService();

  @override
  Widget build(BuildContext context) {
    final bool isStudent =
        Provider.of<MembersProvider>(context, listen: false).memberType ==
            'Student';
    final String? processType =
        Provider.of<MembersProvider>(context, listen: false).getProcessType;
    final String? userId =
        Provider.of<MembersProvider>(context, listen: false).getMemberId;
    Future<Members> fetchStudentInfo() async {
      var student = await studentService.getStudentInfo(
          context: context, userId: userId!);
      return student;
    }

    void submitForm() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (processType == 'Edit') {
          await studentService.updateStudent(
            context: context,
            userId: userId!,
            firstName: firstName,
            lastName: lastName,
            address: address,
            gender: gender,
            className: className,
            schoolId: 'SMKATAHAP', //FIXME: change this to provider
          );
        } else {
          await studentService.addStudent(
            context: context,
            firstName: firstName,
            lastName: lastName,
            address: address,
            gender: gender,
            className: className,
            schoolId: 'SMKATAHAP', //FIXME: change this to provider
          );
        }
      }
    }

    // if (processType == 'Edit') {
    //   var student = await fetchStudentInfo();
    // }

    return FutureBuilder<Members>(
        future: processType == 'Edit'
            ? fetchStudentInfo()
            : Future.value(Members()),
        // isStudent
        // ? (processType == 'Edit'
        //     ? Text('Edit Student')
        //     : Text('Add Student'))
        // : (processType == 'Edit'
        //     ? Text('Edit Teacher')
        //     : Text('Add Teacher')),,
        builder: (BuildContext context, AsyncSnapshot<Members> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading spinner while waiting for future to complete
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    // cursorColor: Colors.red,
                    decoration: InputDecoration(
                      // labelText: 'Name',
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Enter First Name',
                    ),
                    initialValue: processType == 'Edit'
                        ? snapshot.data!.member![0].firstName
                        : null,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter first name.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firstName = value.toString();
                    },
                  ),
                  TextFormField(
                    // cursorColor: Colors.red,
                    decoration: InputDecoration(
                      // labelText: 'Name',
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Enter Last Name',
                    ),
                    initialValue: processType == 'Edit'
                        ? snapshot.data!.member![0].lastName
                        : null,
                    // initialValue:
                    //     processType == 'Edit' ? snapshot.data!.lastName : null,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter last name.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      lastName = value.toString();
                    },
                  ),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     // labelText: 'Email',
                  //     prefixIcon: Icon(Icons.email),
                  //     hintText: 'Enter Email',
                  //   ),
                  // ),
                  TextFormField(
                    decoration: InputDecoration(
                      // labelText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Enter Phone',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter phone.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value.toString();
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      // labelText: 'Address',
                      prefixIcon: Icon(Icons.home),
                      hintText: 'Enter Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      address = value.toString();
                    },
                  ),
                  // DropdownButtonFormField(
                  //   onChanged: (value) {},
                  //   decoration: InputDecoration(
                  //       prefixIcon: Icon(Icons.boy), hintText: 'Select Gender'),
                  //   items: [
                  //     DropdownMenuItem(
                  //       child: Text('Male'),
                  //     ),
                  //     // DropdownMenuItem(
                  //     //   child: Text('Female'),
                  //     // ),
                  //   ],
                  // ),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      // Add Horizontal padding using menuItemStyleData.padding so it matches
                      // the menu padding when button's width is not specified.
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: const Text(
                      'Select Your Gender',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: genderItems
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Row(
                                children: [
                                  Icon(
                                    item == 'Male' ? Icons.male : Icons.female,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
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
                      selectedValue = value.toString();
                      gender = value.toString();
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
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      // Add Horizontal padding using menuItemStyleData.padding so it matches
                      // the menu padding when button's width is not specified.
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // Add more decoration..
                    ),
                    hint: const Text(
                      'Select Class',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: genderItems
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Row(
                                children: [
                                  Icon(
                                    item == 'Male' ? Icons.male : Icons.female,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
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
                      className = value.toString();
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
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     labelText: 'Section',
                  //     hintText: 'Enter Section',
                  //   ),
                  // ),
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     labelText: 'Roll No',
                  //     hintText: 'Enter Roll No',
                  //   ),
                  // ),
                  processType == 'Edit'
                      ? ElevatedButton(
                          onPressed: () {
                            submitForm();
                          },
                          child: Text('Update'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            submitForm();
                          },
                          child: Text('Submit'),
                        ),
                  processType == 'Edit'
                      ? ElevatedButton(
                          onPressed: () {
                            studentService.deleteStudent(
                              context: context,
                              userId: userId!, //FIXME:
                            );
                            Navigator.pop(context);
                          },
                          child: Text('Delete'))
                      : SizedBox(),
                ],
              ),
            );
          }
        });
  }
}
