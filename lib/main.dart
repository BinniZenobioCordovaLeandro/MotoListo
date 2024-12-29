import 'package:firebase_analytics/firebase_analytics.dart';
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
import 'package:motolisto/cubits/messenger/messenger_cubit.dart';
import 'package:motolisto/hooks/use_config.dart';
import 'package:motolisto/hooks/use_messaging.dart';
import 'package:motolisto/screens/driver_home_page.dart';
import 'package:motolisto/screens/home_page.dart';
import 'package:motolisto/screens/login_page.dart';
import 'package:motolisto/screens/onboarding_page.dart';
import 'package:motolisto/screens/requests_page.dart';
import 'package:motolisto/themes/index.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeMessaging();
  FirebaseRemoteConfig.instance.fetchAndActivate();

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
        BlocProvider<MessengerCubit>(create: (context) => MessengerCubit()),
        BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
        BlocProvider<SessionBloc>(create: (context) => SessionBloc()),
        BlocProvider<RequestBloc>(create: (context) => RequestBloc()),
        BlocProvider<ServiceBloc>(create: (context) => ServiceBloc()),
      ],
      child: BlocListener<MessengerCubit, MessengerState>(
        listener: (context, state) {
          if (state is MessengerShowSnackbar) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: getAppTheme(),
          darkTheme: getAppTheme(darkMode: true),
          themeMode: ThemeMode.system,
          locale: const Locale('es', 'PE'),
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
          navigatorObservers: [
            FirebaseAnalyticsObserver(
              analytics: FirebaseAnalytics.instance,
              nameExtractor: (RouteSettings settings) {
                print('⭐️⭐️⭐️ FirebaseAnalyticsObserver: ${settings.name}');
                validateMinimumVersion();
                return settings.name ?? 'NON_ROUTE_NAME';
              },
            ),
          ],
        ),
      ),
    );
  }
}
