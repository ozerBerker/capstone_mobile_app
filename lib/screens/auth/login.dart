import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/consts/firebase_consts.dart';
import 'package:mobile_app/fetch_screen.dart';
import 'package:mobile_app/screens/auth/forgot_passwprd.dart';
import 'package:mobile_app/screens/auth/register.dart';
import 'package:mobile_app/screens/loading_manager.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/widgets/button_widget.dart';
import 'package:mobile_app/widgets/google_auth_button.dart';
import 'package:mobile_app/widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  var _obscureText = true;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    if (isValid) {
      _formKey.currentState!.save();

      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const FetchScreen(),
        ));
        print('Succefully logged in');
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    TextWidget(
                      text: 'Welcome Back',
                      color: Color(0xff163674),
                      textSize: 30,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextWidget(
                      text: 'Sign in to continue',
                      color: Color(0xff6B7891),
                      textSize: 18,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // EMAIL
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xff344D7D), // Change background color to orange
                                borderRadius: BorderRadius.circular(
                                    8.0), // Adjust border radius if needed
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(_passFocusNode),
                                  controller: _emailTextController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@')) {
                                      return 'Please enter a valid email adress';
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            // PASSWORD
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xff344D7D), // Change background color to orange
                                borderRadius: BorderRadius.circular(
                                    8.0), // Adjust border radius if needed
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  onEditingComplete: () => _submitFormOnLogin(),
                                  controller: _passTextController,
                                  focusNode: _passFocusNode,
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 7) {
                                      return 'Please enter a valid passord';
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          child: Icon(
                                            _obscureText
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.white,
                                          )),
                                      hintText: 'Password',
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          GlobalMethods.navigateTo(
                              ctx: context,
                              routeName: ForgotPasswordScreen.routeName);
                        },
                        child: const Text(
                          'Forgot password?',
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xff6B7891),
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ButtonWidget(
                      fct: _submitFormOnLogin,
                      buttonText: 'Login',
                      primary: Color(0xff8494CD),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GoogleButton(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                            text: 'OR', color: Colors.white, textSize: 18),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                            child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ButtonWidget(
                      fct: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FetchScreen(),
                          ),
                        );
                      },
                      buttonText: 'Continue as a guest',
                      primary: Color(0xff6B7891),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Don't have an account?",
                            style: TextStyle(
                                color: Color(0xff163674), fontSize: 18),
                            children: [
                          TextSpan(
                              text: "   Sign up",
                              style: TextStyle(
                                  color: Color(0xff6B7891),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  GlobalMethods.navigateTo(
                                      ctx: context,
                                      routeName: RegisterScreen.routeName);
                                }),
                        ]))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
