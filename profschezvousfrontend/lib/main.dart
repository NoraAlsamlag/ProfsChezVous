import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/ecrans/splash/splash_screen.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';
import 'package:profschezvousfrontend/models/user_models.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:intl/date_symbol_data_local.dart';
import 'api/auth/auth_api.dart';
import 'ecrans/init_screen.dart';
import 'routes.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox('tokenBox');
  await initializeDateFormatting('fr_FR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<User?> refreshUserData() async {
    var box = await Hive.openBox('tokenBox');
    String? token = box.get('token');
    if (token == null) {
      return null;
    }
    
    return await getUser(token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: refreshUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          User? user = snapshot.data;
          return BlocProvider(
            create: (context) {
              return UserCubit(user ?? User());
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'The Flutter Way - Template',
              theme: AppTheme.lightTheme(context),
              initialRoute: user != null ? InitScreen.routeName : SplashScreen.routeName,
              routes: routes,
            ),
          );
        }
      },
    );
  }
}
