import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:motolisto/blocs/service/service_bloc.dart';
import 'package:motolisto/blocs/location/location_bloc.dart';
import 'package:motolisto/blocs/sesion/session_bloc.dart';
import 'package:motolisto/blocs/request/request_bloc.dart';
import 'package:motolisto/hooks/use_config.dart';
import 'package:motolisto/hooks/use_messaging.dart';
import 'package:motolisto/screens/driver_home_page.dart';
import 'package:motolisto/screens/home_page.dart';
import 'package:motolisto/screens/login_page.dart';
import 'package:motolisto/screens/onboarding_page.dart';
import 'package:motolisto/screens/requests_page.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeMessaging();
  FirebaseRemoteConfig.instance.fetchAndActivate();
  validateMinimumVersion();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
        BlocProvider<SessionBloc>(create: (context) => SessionBloc()),
        BlocProvider<RequestBloc>(create: (context) => RequestBloc()),
        BlocProvider<ServiceBloc>(create: (context) => ServiceBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: FirebaseAuth.instance.currentUser != null
            ? HomePage()
            : LoginPage(),
        routes: {
          '/home': (context) => HomePage(),
          '/login': (context) => LoginPage(),
          '/requests': (context) => RequestsPage(),
          '/onboarding': (context) => OnboardingPage(),
          '/driver_home': (context) => DriverHomePage(),
        },
      ),
    );
  }
}
