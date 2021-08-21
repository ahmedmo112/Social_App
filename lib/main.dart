import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/socialCubit.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/module/Login/login_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/cubit/appCubit.dart';
import 'package:social_app/shared/cubit/appStates.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/dio_helper.dart';

import 'shared/constants/constants.dart';
import 'shared/styles/themes.dart';

void main() async {
//! if we did main async we must add => WidgetsFlutterBinding.ensureInitialized();
//!    and this mean  make sure that do all before RunApp() then runApp
//! بيتاكد ان كل حاجه هنا في الميثود خلصت وبعدين يفتح الابلكيشن

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool? isDark = CacheHelper.getBoolean(key: 'isDark');

  late Widget widget;

  //bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

   uId = CacheHelper.getData(key: 'uId');
  
  print(uId);

  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }

  runApp(MyApp(isDark: isDark, startWidget: widget));
}

class MyApp extends StatelessWidget {
  bool? isDark;
  Widget? startWidget;

  MyApp({
    this.startWidget,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocialCubit()
            ..getUserData()
            ..getPosts()
        ),
        BlocProvider(
            create: (BuildContext context) =>
                AppCubit()..changeAppMode(fromShared: isDark!))
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              title: 'Shop',
              //! //////////// //app theme ////////
              //* //////Light////////////
              theme: lightTheme,
              //* //////Dark////////////
              darkTheme: darktheme,
              themeMode: AppCubit.get(context).isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              //! ///////////////////////////////
              debugShowCheckedModeBanner: false,
              home: startWidget);
        },
      ),
    );
  }
}
