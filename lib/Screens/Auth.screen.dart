// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/auth.services.dart';
import 'package:postgram/Utils/Toast.service.dart';
import 'package:postgram/Utils/route.reuse.dart';
import '../Components/text.form.field.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController passwordC1 = TextEditingController();
  File? image;

  bool isPasswordVisible = true;
  bool isPasswordVisible1 = true;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.login;

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  void initState() {
    emailC = TextEditingController();
    passwordC = TextEditingController();
    passwordC1 = TextEditingController();
    super.initState();
  }

  void selectImage() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 23, 155),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 20,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  blurRadius: 20,
                  offset: Offset(0, 5),
                ),
              ],
              color: Color.fromARGB(255, 35, 35, 35),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Column(
                children: <Widget>[
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(_authMode == AuthMode.login ? 'Login' : 'Sign Up',
                            style: const TextStyle(
                              fontSize: 30,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          height: 100,
                        ),
                        if (_authMode == AuthMode.signup)
                          image != null
                              ? InkWell(
                                  onTap: () {
                                    selectImage();
                                  },
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        MemoryImage(image!.readAsBytesSync()),
                                    backgroundColor: Colors.transparent,
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    selectImage();
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://i.stack.imgur.com/l60Hf.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ),
                        TextEnterArea(
                          controller: emailC,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          hintText: 'Enter your email Address',
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!p0.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextEnterArea(
                          controller: passwordC,
                          textInputAction: TextInputAction.next,
                          obscureText:
                              isPasswordVisible == false ? true : false,
                          hintText: 'Enter your Password',
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return 'Please enter your Password';
                            }
                            if (p0.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            if (_authMode == AuthMode.signup &&
                                p0 != passwordC1.text) {
                              return 'Password does not match';
                            }
                            return null;
                          },
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible == false
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (_authMode == AuthMode.signup)
                          TextEnterArea(
                            enabled: _authMode == AuthMode.signup,
                            controller: passwordC1,
                            textInputAction: TextInputAction.next,
                            obscureText:
                                isPasswordVisible1 == false ? true : false,
                            hintText: 'Enter your Confirmed Password',
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return 'Please enter your Password';
                              }
                              if (p0.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              if (p0 != passwordC.text) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible1 == false
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible1 = !isPasswordVisible1;
                                });
                              },
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) {
                              // Invalid!
                              return;
                            }
                            formKey.currentState!.save();
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              if (_authMode == AuthMode.login) {
                                final res = await AuthMethod().loginUser(
                                  email: emailC.text,
                                  password: passwordC.text,
                                );
                                if (res == "Logged In Successfully") {
                                  ToastService.show(
                                    msg: "Login Success",
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MyRouter.generateRoute(
                                      const RouteSettings(name: MyRouter.home),
                                    ),
                                  );
                                } else {
                                  ToastService.show(
                                    msg: res,
                                  );
                                }
                              } else {
                                if (image == null) {
                                  ToastService.show(
                                    msg: "Please select an image",
                                  );
                                  return;
                                }

                                final res = await AuthMethod().signUpUser(
                                  email: emailC.text,
                                  password: passwordC.text,
                                  gender: "",
                                  name: emailC.text.split("@")[0],
                                  image: File(image!.path).readAsBytesSync(),
                                );

                                if (res == "Verification Email Sent") {
                                  Navigator.pushReplacement(
                                    context,
                                    MyRouter.generateRoute(
                                      const RouteSettings(name: MyRouter.home),
                                    ),
                                  );

                                  ToastService.show(
                                    msg: "Verification Email Sent",
                                  );
                                } else {
                                  ToastService.show(
                                    msg: res,
                                  );
                                }
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                ToastService.show(
                                  msg: "No user found for that email",
                                );
                              } else if (e.code == 'wrong-password') {
                                ToastService.show(
                                  msg: "Wrong password provided for that user",
                                );
                              } else if (e.code == 'email-already-in-use') {
                                ToastService.show(
                                  msg:
                                      "The account already exists for that email",
                                );
                              }
                            } catch (e) {
                              ToastService.show(
                                msg: "Error",
                              );
                            }

                            setState(() {
                              isLoading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 0, 92, 167),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  _authMode == AuthMode.login
                                      ? 'Login'
                                      : 'Signup',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _switchAuthMode();
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(150, 30),
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 92, 167),
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            child: Text(
                              "${_authMode == AuthMode.login ? 'Signup' : 'Login'} Instead",
                            )),
                      ],
                    ),
                  ),
                ],
              )),
            ),
          ),
          const Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(145, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ]),
      ),
    );
  }
}
