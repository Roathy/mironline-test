import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:mironline/constants/routes.dart';
import 'package:mironline/utilities/show_error_dialog.dart';
import 'package:mironline/views/verify_email_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Please enter your email'),
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
                final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  // is verified
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                    devtools.log(userCredential.toString());
                  }
                } else {
                  // is NOT verified
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                    devtools.log(userCredential.toString());
                  }
                }
              } on FirebaseAuthException catch (error) {
                if (mounted) {
                  await showErrorDialog(context, error.code);
                }
                devtools.log('Failed with error code: ${error.code}');
                devtools.log(error.message.toString());
              } catch (error) {
                if (mounted) {
                  await showErrorDialog(context, error.toString());
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              // child: const CircularProgressIndicator())
              child: const Text("Don't have an account yet? Register here"))
        ],
      ),
    );
  }
}
