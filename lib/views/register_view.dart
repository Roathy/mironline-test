import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:mironline/constants/routes.dart';
import 'package:mironline/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration:
                const InputDecoration(hintText: 'Please enter your email'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter your password'),
            autocorrect: false,
            obscureText: true,
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  devtools.log(userCredential.toString());
                } on FirebaseAuthException catch (error) {
                  devtools.log('CODE: ${error.code} MESSAGE: ${error.message}');
                  if (error.code == 'invalid-email') {
                    if (mounted) {
                      await showErrorDialog(context, error.message.toString());
                    }
                    devtools.log(error.message.toString());
                  } else if (error.code == 'weak-password') {
                    if (mounted) {
                      await showErrorDialog(context, error.message.toString());
                    }
                    devtools.log(error.message.toString());
                  } else if (error.code == 'email-already-in-use') {
                    if (mounted) {
                      await showErrorDialog(context, error.message.toString());
                    }
                    devtools.log('The email address is already in use');
                  } else {
                    if (mounted) {
                      await showErrorDialog(context, 'Error: ${error.code}');
                    }
                  }
                } catch (error) {
                  if (mounted) {
                    await showErrorDialog(context, error.toString());
                  }
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already registered? Login here'))
        ],
      ),
    );
  }
}
