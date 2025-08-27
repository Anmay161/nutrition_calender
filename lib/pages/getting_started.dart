import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrition_calender/constants/values.dart';
import 'package:nutrition_calender/pages/navigate_page.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({super.key});

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  final _formkey_1 = GlobalKey<FormState>();

  String firstbox = Values.list1[0];
  String secondbox = Values.list2[0];
  String thirdbox = Values.list3[0];
  String gender = Values.gender[0];

  late TextEditingController height;
  late TextEditingController weight;
  late TextEditingController username;
  late TextEditingController age;

  @override
  void initState() {
    height = TextEditingController();
    weight = TextEditingController();
    age = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    username.dispose();
    age.dispose();
    height.dispose();
    weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 113, 139, 87),
        centerTitle: true,
        title: Text(
          'GET STARTED',
          style: GoogleFonts.merriweather(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            wordSpacing: 2,
            color: Colors.black,
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Getting_started.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: [
            Form(
              key: _formkey_1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Age:',
                        style: GoogleFonts.merriweather(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: age,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please fill up this section';
                          }
                          return null;
                        },
                        style: GoogleFonts.merriweather(fontSize: 10),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Color.fromARGB(255, 181, 187, 155),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 3,
                            vertical: 6,
                          ),
                          focusedBorder: containerborder,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: containerborder,
                          focusedErrorBorder: containerborder,
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Height (In cm):',
                        style: GoogleFonts.merriweather(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: height,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please fill up this section';
                          }
                          try {
                            int check = int.parse(value.trim());
                            if (check <= 0) return 'Enter valid values';
                          } catch (e) {
                            return 'Enter valid values';
                          }
                          return null;
                        },
                        style: GoogleFonts.merriweather(fontSize: 10),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Color.fromARGB(255, 181, 187, 155),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 3,
                            vertical: 6,
                          ),
                          focusedBorder: containerborder,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: containerborder,
                          focusedErrorBorder: containerborder,
                        ),
                      ),
                    ),

                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Weight (In kg):',
                        style: GoogleFonts.merriweather(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: weight,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.merriweather(fontSize: 10),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please fill up this section';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Color.fromARGB(255, 181, 187, 155),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 3,
                          ),
                          focusedBorder: containerborder,
                          errorBorder: containerborder,
                          focusedErrorBorder: containerborder,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Gender:',
                        style: GoogleFonts.merriweather(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    Container(
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 181, 187, 155),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        border: Border.all(color: Colors.black),
                      ),
                      width: 150,
                      height: 30,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: gender,
                          isExpanded: true,
                          items:
                              Values.gender.map<DropdownMenuItem<String>>((
                                String item,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              gender = newValue!;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Form 2
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Goal:',
                        style: GoogleFonts.merriweather(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    Container(
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      width: 150,
                      child: DropdownButtonFormField(
                        value: firstbox,
                        style: GoogleFonts.merriweather(fontSize: 10),
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 3,
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 181, 187, 155),
                          border: containerborder,
                          isDense: true,
                          enabledBorder: containerborder,
                          errorBorder: containerborder,
                          focusedErrorBorder: containerborder,
                        ),
                        items:
                            Values.list1.map<DropdownMenuItem<String>>((
                              String item,
                            ) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: GoogleFonts.merriweather(
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            firstbox = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a goal';
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 5),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Goal Duration (Optional):',
                        style: GoogleFonts.merriweather(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    Container(
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 181, 187, 155),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        border: Border.all(color: Colors.black),
                      ),
                      width: 150,
                      height: 30,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: secondbox,
                          isExpanded: true,
                          items:
                              Values.list2.map<DropdownMenuItem<String>>((
                                String item,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              secondbox = newValue!;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Underlying Condition (Optional):',
                        style: GoogleFonts.merriweather(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    Container(
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 181, 187, 155),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        border: Border.all(color: Colors.black),
                      ),
                      width: 150,
                      height: 30,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: thirdbox,
                          isExpanded: true,
                          items:
                              Values.list3.map<DropdownMenuItem<String>>((
                                String item,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              thirdbox = newValue!;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          submit_2();
        },
        child: Container(
          height: 35,
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'Done',
              style: GoogleFonts.merriweather(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit_2() async {
    final form1 = _formkey_1.currentState!.validate();

    if (!form1) {
    } else {
      bool check = await updateUserData();

      if (mounted) {
        if (check) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigatePage()),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Something went wrong")));
        }
      }
    }
  }

  Future<bool> updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    try {
      await userRef.update({
        'Height': height.text.trim(),
        'Weight': weight.text.trim(),
        'Gender': gender,
        'Goal': firstbox,
        'BMI':
            (int.parse(weight.text.trim()) /
                ((int.parse(height.text.trim()) * 0.01) *
                    (int.parse(height.text.trim()) * 0.01))),
      });
    } catch (e) {
      return false;
    }
    return true;
  }
}

final containerborder = OutlineInputBorder(
  borderRadius: BorderRadius.only(
    topRight: Radius.circular(12),
    bottomRight: Radius.circular(12),
  ),
  borderSide: BorderSide(color: Colors.black, width: 1),
);
