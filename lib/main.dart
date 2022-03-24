import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_models/globalVariables_viewModel.dart';
import '../../../views/home/home_screen.dart';
import '../../../utils/theme.dart';
import 'view_models/auth_viewModel.dart';
import '../../../utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AuthViewModel(FirebaseAuth.instance).AnonymousOrCurrent();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthViewModel>(create: (_) => AuthViewModel(FirebaseAuth.instance)),
        StreamProvider(
          initialData: 0,
          create: (context) => context.read<AuthViewModel>().authStateChanges,
        ),
        ChangeNotifierProvider(create: (context) => globalVars()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce',
        theme: theme(),
        home: HomeScreen(),
        routes: routes,
      ),
    );
  }
}
