import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:motolisto/blocs/sesion/session_bloc.dart';
import 'package:pinput/pinput.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  String _verificationId = '';

  Future<void> _verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Sign the user in directly if the code is retrieved automatically
        await FirebaseAuth.instance.signInWithCredential(credential);
        debugPrint('🎸 verificationCompleted');
        // Sign-in successful
        Navigator.of(context).pushReplacementNamed('/home');
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle error
        print('Error: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Update the UI to ask the user for the verification code
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    String smsCode = _codeController.text.trim();
    if (smsCode.length != 6) {
      return;
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _codeController.text.trim(),
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint('🎸 verificationCompleted');
      // Sign-in successful
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          if (state is SessionInitial) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    if (_verificationId.isEmpty) ...[
                      Text(
                        'Ingresa tu número de teléfono para verificar tu identidad',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      Icon(
                        Icons.phone_android,
                        size: 100,
                      ),
                      Spacer(),
                      SizedBox(height: 16),
                      InternationalPhoneNumberInput(
                        initialValue: PhoneNumber(isoCode: 'PE'),
                        onInputChanged: (PhoneNumber number) {
                          print(number.phoneNumber);
                          _phoneController.text = number.phoneNumber!;
                        },
                        inputDecoration: InputDecoration(
                          labelText: 'Número de teléfono',
                          hintText: '990 000 000',
                        ),
                        keyboardType: TextInputType.phone,
                        autoFocus: true,
                        selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _verifyPhoneNumber,
                        child: Text('Enviame el código de verificación'),
                      ),
                    ],
                    if (_verificationId.isNotEmpty) ...[
                      Text(
                        'Ingresa el código de verificación que recibiste por SMS al número ${_phoneController.text}',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      Icon(
                        Icons.sms_outlined,
                        size: 100,
                      ),
                      Spacer(),
                      SizedBox(height: 16),
                      Pinput(
                        length: 6,
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.minLength(6),
                        ]),
                        onCompleted: (value) {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            _signInWithPhoneNumber();
                            context
                                .read<SessionBloc>()
                                .add(SessionLoggedIn(_phoneController.text));
                          } else {
                            print('Validation failed');
                          }
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            );
          } else if (state is SessionAuthenticated) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Bienvenido, ${state.phoneNumber}'),
                Text('Has iniciado sesión correctamente'),
              ],
            ));
          } else if (state is SessionUnauthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No has iniciado sesión'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SessionBloc>().add(SessionLoggedIn(''));
                    },
                    child: Text('Log in'),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
