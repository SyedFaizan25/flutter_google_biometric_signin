import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'finger_biometeric.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// Initialize FirebaseApp
  await Firebase.initializeApp();
// Initialize the Vertex AI service and the generative model
// Specify a model that supports your use case
// Gemini 1.5 Pro is versatile and can accept both text-only and multimodal prompt inputs
  final model =
  FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-pro-preview-0409');
  // runApp(const FingerAuth());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _login() async {
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn()
        .signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount
        ?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken:googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    final user=FirebaseAuth.instance.currentUser;
    debugPrint(user!.displayName.toString());
    debugPrint(user.photoURL.toString());
    setState(() {

    });
  }
  void _signOut() async {

    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(FirebaseAuth.instance.currentUser?.displayName.toString() ?? ''),
            TextButton.icon(
              onPressed: _login,
              icon: const Icon(Icons.login),
              label: const Text('Sign In with Google'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.logout),
              onPressed: _signOut,
              label: const Text('Logout'),
            )

          ],
        ),
      ),
    );
  }
}


