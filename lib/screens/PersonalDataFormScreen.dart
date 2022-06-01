import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../utils/Spacing.dart';

class PersonalDataFormScreen extends StatefulWidget {
  const PersonalDataFormScreen({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<PersonalDataFormScreen> createState() => _PersonalDataFormScreenState();
}

class _PersonalDataFormScreenState extends State<PersonalDataFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  late bool isEmployed;
  bool showPicError = false;
  XFile? image;

  @override
  void initState() {
    isEmployed = false;
    super.initState();
  }

  Future pickImage(ImageSource imageSource) async {
    image = await ImagePicker().pickImage(source: imageSource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title),
          ],
        ),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                PersonalDataTextField(
                    controller: firstNameController, hint: 'First Name'),
                const Spacing(
                  vertical: true,
                ),
                PersonalDataTextField(
                    controller: lastNameController, hint: 'Last Name'),
                const Spacing(
                  vertical: true,
                ),
                Row(
                  children: [
                    const Text('Are you employed?'),
                    Checkbox(
                        value: isEmployed,
                        onChanged: (newValue) {
                          setState(() {
                            isEmployed = newValue!;
                          });
                        }),
                    Text(isEmployed ? 'Yes' : 'No'),
                    const Spacing(
                      vertical: true,
                    ),
                  ],
                ),
                PersonalDataTextField(
                  controller: jobController,
                  hint: 'Job Title',
                  req: isEmployed,
                ),
                const Spacing(
                  vertical: true,
                ),
                PersonalDataTextField(
                  controller: salaryController,
                  hint: 'Current Salary (€)',
                  currency: true,
                ),
                const Spacing(vertical: true),
                Text('Upload a picture of the last invoice received'),
                const Spacing(vertical: true),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.60,
                    height: MediaQuery.of(context).size.width * 0.60,
                    child: image == null
                        ? Icon(Icons.camera)
                        : Image.file(File(image!.path))),
                if (showPicError)
                  Text(
                    'required!',
                    style: TextStyle(color: Colors.red[800], fontSize: 12),
                  ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          pickImage(ImageSource.gallery);
                          setState(() {
                            showPicError = false;
                          });
                        },
                        child: Text('Choose a Picture'),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await pickImage(ImageSource.camera);
                          setState(() {
                            showPicError = false;
                          });
                        },
                        child: Text('Take a Picture'),
                      ),
                    ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: ElevatedButton(
                          child: Text('Send Application'),
                          onPressed: () async {
                            if (image == null) {
                              setState(() {
                                showPicError = true;
                              });
                            }
                            if (!_formKey.currentState!.validate()||image == null) return;

                            int eligibilityScore = 0;
                            try {
                              eligibilityScore = int.parse((await http.get(
                                      Uri.parse(
                                          'https://www.random.org/integers/?num=1&min=1&max=6&col=1&base=10&format=plain&rnd=new')))
                                  .body);
                            } catch (e) {
                              showDialog(barrierDismissible: false,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('Error'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              Text(
                                                  'There wa an error with your application'),
                                              Text('Please try again later'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Okey'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ));

                              return;
                            }

                            showDialog(
                              barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text('Eligibility Score'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text(
                                                'Your eligibility is $eligibilityScore/10'),
                                            Text(eligibilityScore < 5
                                                ? 'We are sorry but you are not eligible for this loan'
                                                : 'Congratulations, your loan has been aproved'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Okey'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ));
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class PersonalDataTextField extends StatelessWidget {
  const PersonalDataTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.req = true,
    this.numeric = false,
    this.currency = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final bool req;
  final bool numeric;
  final bool currency;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType:
          numeric || currency ? TextInputType.number : TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
          suffixText: currency ? '€' : null,
          hintText: hint,
          border: const UnderlineInputBorder(
              borderSide:const  BorderSide(color: Colors.blue))),
      validator: !req
          ? null
          : (value) {
              if (value == null || value.isEmpty) {
                return 'required!';
              }
              return null;
            },
    );
  }
}
