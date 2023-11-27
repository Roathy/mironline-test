import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mironline/firebase_options.dart';

import 'package:mironline/views/verify_email_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false) {
                return const SizedBox.shrink();
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VerifyEmailView()));
                return const VerifyEmailView();
              }
            // return const Text('done');
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
