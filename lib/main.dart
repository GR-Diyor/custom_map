import 'package:custom_map/core/config/app_screen_style.dart';
import 'package:custom_map/feature/presentation/cubit/home_cubit.dart';
import 'package:custom_map/feature/presentation/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/utill/dimension_utill.dart';

void main() {
  AppStyle.init();

  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(
              create: (BuildContext context) => HomeCubit(),
            ),
          ],
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context , constraints){
      SizerUtil.setScreenSize(constraints);
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom map',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const Home(),
    );
        }
    );
  }
}
