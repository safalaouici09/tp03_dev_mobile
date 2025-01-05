import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cloudinary_url_gen/cloudinary.dart';

import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:quizz_app/screens/avatar_ipload_page.dart';
import 'package:quizz_app/screens/quizz_page.dart';

import 'package:quizz_app/screens/signup_in.dart';

import 'providers/quizzProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configuration de Cloudinary
  //cloudinary = CloudinaryObject.fromCloudName(cloudName: 'dlpp5i2wa');
  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: 'dlpp5i2wa');

  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignInSignUpScreen(),
    );
  }
}
