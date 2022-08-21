import 'package:chat_app/helper/utility.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegisterPG extends StatefulWidget {
  const RegisterPG({Key? key}) : super(key: key);

  @override
  State<RegisterPG> createState() => _RegisterPGState();
}

class _RegisterPGState extends State<RegisterPG> {
  final formKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(name, email, password)
          .then((value) async {
        if (value == true) {
          //Saving shared preferenced state
          await UtilityFunctions.saveUserLoggedInStatus(true);
          await UtilityFunctions.saveUserEmailSf(email);
          await UtilityFunctions.saveUserNameSF(name);

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
    return _isLoading
        ? Center(
            child: SpinKitCircle(
              color: Theme.of(context).primaryColor,
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 60.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Groupie',
                        style: TextStyle(
                            fontSize: 30.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Create your account now to chat and explore',
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      Image.asset('assets/register.png'),
                      SizedBox(
                        height: 45.h,
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                            labelText: "Full Name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            ),
                            errorStyle: TextStyle(fontSize: 11.sp),
                          ),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          validator: (value) {
                            return value!.isEmpty ? "Enter your name" : null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        height: 45.h,
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                              errorStyle: TextStyle(fontSize: 11.sp)),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          validator: ((value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "Invalid email";
                          }),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 45.h,
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
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => register(),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              )),
                          child: Text(
                            "Register",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                            text: "Already have an account? ",
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Login now",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
                                    })
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
