import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/consts/firebase_consts.dart';
import 'package:mobile_app/fetch_screen.dart';
import 'package:mobile_app/screens/auth/login.dart';
import 'package:mobile_app/screens/loading_manager.dart';
import 'package:mobile_app/services/global_methods.dart';
import 'package:mobile_app/services/utils.dart';
import 'package:mobile_app/widgets/button_widget.dart';
import 'package:mobile_app/widgets/text_widget.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/RegisterScreen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();

  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  var _obscureText = true;

  @override
  void dispose() {
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();

    _passFocusNode.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        final User? user = authInstance.currentUser;
        final _uid = user!.uid;
        user.updateDisplayName(_fullNameTextController.text);
        user.reload();
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameTextController.text,
          'email': _emailTextController.text.toLowerCase(),
          'bio': '',
          'userWallet': 0,
          'createTime': Timestamp.now(),
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const FetchScreen(),
        ));
        print('Succefully registered');
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
    final Utils utils = Utils(context);
    final theme = utils.getTheme;
    Color color = utils.color;
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
                  children: <Widget>[
                    const SizedBox(
                      height: 60,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : null,
                      child: Icon(
                        IconlyLight.arrowLeft2,
                        color: theme == false
                            ? Colors.white
                            : Colors.black, //LOOK AGAIN
                        size: 24,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextWidget(
                      text: 'Welcome',
                      color: Color(0xff546890),
                      textSize: 30,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextWidget(
                      text: 'Sign up to continue',
                      color: Color(0xff6CACD0),
                      textSize: 18,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // FULL NAME
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xff368697), // Change background color to orange
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
                                          .requestFocus(_addressFocusNode),
                                  controller: _fullNameTextController,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This Field is missing';
                                    } else {
                                      return null;
                                    }
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Full Name',
                                    hintStyle: TextStyle(color: Colors.white),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            // EMAIL
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xff368697), // Change background color to orange
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
                                    0xff368697), // Change background color to orange
                                borderRadius: BorderRadius.circular(
                                    8.0), // Adjust border radius if needed
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(_addressFocusNode),
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
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {},
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
                      fct: _submitFormOnRegister,
                      buttonText: 'Sign up',
                      primary: Color(0xff045071),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Already a user?",
                            style: TextStyle(
                                color: Color(0xff163674), fontSize: 18),
                            children: [
                          TextSpan(
                              text: "   Sign in",
                              style: const TextStyle(
                                  color: Color(0xff6B7891),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.routeName);
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
