import 'package:chat_app/helper/utility.dart';
import 'package:chat_app/pages/auth/register.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
//Function to validate the text entered form
  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _auth.userLoginEmailPassword(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot data =
              await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .getingUserData(FirebaseAuth.instance.currentUser!.uid);
          await UtilityFunctions.saveUserLoggedInStatus(true);
          if (data.docs.isEmpty) {
            nextScreenReplacement(context, HomePage());
          } else {
            await UtilityFunctions.saveUserEmailSf(email);
            await UtilityFunctions.saveUserNameSF(data.docs[0]['fullName']);
          }
          nextScreenReplacement(context, const HomePage());
        } else {
          showSnackBar(context, value, Colors.red);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child:
                  SpinKitDancingSquare(color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 60.h),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Groupie',
                            style: TextStyle(
                              fontSize: 44.sp,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(height: 10.h),
                        Text('Lets what they are talking about!',
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          child: Image.asset(
                            'assets/ab.png',
                            height: 260.h,
                            //scale: ,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 50.h,
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                              errorStyle: TextStyle(fontSize: 11.sp),
                            ),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                                print(email);
                              });
                            },
                            validator: ((value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)
                                  ? null
                                  : "Invalid Email";
                            }),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 50.h,
                          child: TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              ),
                              errorStyle: TextStyle(fontSize: 11.sp),
                            ),
                            validator: (value) {
                              return value!.length >= 8
                                  ? null
                                  : "Password must be atleast 8 characters";
                            },
                            onChanged: (value) {
                              setState(() {
                                password = value;
                                print(password);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 35.h,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  )),
                              onPressed: () {
                                login();
                              },
                              child: Text(
                                "Signin",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.sp),
                              )),
                        ),
                        SizedBox(height: 10.h),
                        Text.rich(
                          TextSpan(
                              text: "Don't have an accouct?",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.sp),
                              children: [
                                TextSpan(
                                    text: " Register Now",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(context, RegisterPG());
                                      },
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                        decoration: TextDecoration.underline)),
                              ]),
                        ),
                        Text.rich(
                          TextSpan(
                              text: "Guest?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await _auth
                                      .signInAnonamously()
                                      .then((value) async {
                                    if (value == true) {
                                      await UtilityFunctions
                                          .saveUserLoggedInStatus(true);
                                      QuerySnapshot snapshot =
                                          await DataBaseService()
                                              .getingUserData(FirebaseAuth
                                                  .instance.currentUser!.uid);
                                      await UtilityFunctions.saveUserEmailSf(
                                          snapshot.docs[0]['uid']);
                                      await UtilityFunctions.saveUserNameSF(
                                          snapshot.docs[0]['fullName']);
                                      nextScreenReplacement(
                                          context, const HomePage());
                                    } else {
                                      print("signed in");
                                      print(value);
                                    }
                                  });
                                }),
                        )
                      ],
                    )),
              ),
            ),
    );
  }
}
