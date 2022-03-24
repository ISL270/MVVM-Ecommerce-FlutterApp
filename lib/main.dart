import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/global_vars_view_model.dart';
import '../../../views/home/home_screen.dart';
import '../../../utils/theme.dart';
import 'view_models/auth_view_model.dart';
import '../../../utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AuthViewModel(FirebaseAuth.instance).AnonymousOrCurrent();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthViewModel>(create: (_) => AuthViewModel(FirebaseAuth.instance)),
        StreamProvider(
          initialData: 0,
          create: (context) => context.read<AuthViewModel>().authStateChanges,
        ),
        ChangeNotifierProvider(create: (context) => GlobalVars()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce',
        theme: theme(),
        home: const HomeScreen(),
        routes: routes,
      ),
    );
  }
}
