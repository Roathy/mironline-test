import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mironline/constants/routes.dart';

import '../utilities/show_custom_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Verify Email'),
      ),
      body: Center(
        child: Column(children: [
          const Text("We've sent you an email verification. Please open it in order to validate your account."),
          const Text("If you haven't received a verificatino email yet, press the button below."),
          TextButton(
            onPressed: () async {
              await showCustomDialog(context, 'Please check your inbox', 'An email has already been sent to confirm your account');
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              }
            },
            child: const Text('Restart'),
          )
        ]),
      ),
    );
  }
}
