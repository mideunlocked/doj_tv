import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart';
import 'helpers/auth_state_helper.dart';
import 'providers/channel_provider.dart';
import 'providers/user_provider.dart';
import 'screens/create_user_screen.dart';
import 'screens/cu_channel_screen.dart';
import 'screens/home_screen.dart';
import 'screens/live_video_screen.dart';
import 'screens/login_screen.dart';
import 'screens/user_credentials_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final Auth auth = Auth();
  final bool isLogged = auth.isLogged();
  final MainApp mainApp = MainApp(
    initialRoute: isLogged ? '/' : '/LoginScreen',
  );

  runApp(mainApp);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ChannelProvider(),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF101010),
            primaryColor: const Color(0xFFFFE500),
            iconTheme: const IconThemeData(color: Colors.white),
            appBarTheme: AppBarTheme(
              elevation: 0,
              color: Colors.transparent,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                letterSpacing: 1,
              ),
            ),
          ),
          initialRoute: initialRoute,
          routes: {
            HomeScreen.routeName: (context) => const HomeScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            LiveVideoScreen.routeName: (context) => const LiveVideoScreen(),
            UserCredentailsScreen.routeName: (context) =>
                const UserCredentailsScreen(),
            CreateUserScreen.routeName: (context) => const CreateUserScreen(),
            CUChannelScreen.routeName: (context) => const CUChannelScreen(),
          },
        ),
      ),
    );
  }
}
