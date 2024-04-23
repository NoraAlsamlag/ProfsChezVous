import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/models/user_models.dart';
import '../../models/user_cubit.dart';
import 'package:profschezvousfrontend/layout/BottomNavigationBar.dart'; // Import your custom bottom navigation bar

import '../../models/user_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Text("Home page"),
      ),
    );
  }
}
