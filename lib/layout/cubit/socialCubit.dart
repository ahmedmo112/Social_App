// ignore_for_file: file_names
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/socialstatus.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/module/chats/chats_screen.dart';
import 'package:social_app/module/feeds/feeds_screen.dart';
import 'package:social_app/module/settings/settiings_screen.dart';
import 'package:social_app/module/users/users_screen.dart';
import 'package:social_app/shared/componants/components.dart';
import 'package:social_app/shared/constants/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitnalState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? model;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc('t6GZUN6gdfq6LUgT6hXq')
        .get()
        .then((value) {
      print(value.data());
      model = UserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(SocialGetUserErrorState(e.toString()));
    });
  }

  void signout() {
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uId');
      print('signOut Success');
    }).catchError((e) {
      print(e.toString());
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    
    UsersScreen(),
    SettingsScreen()
  ];

  List<String> titles = ['Home', 'Chat','Users', 'Settings'];

  void changeBottomNav(int index) {
    
    if (index == 2) {
      emit(NewPostState());
    } else {
      currentIndex = index > 2 ? index-1:index;
      emit(ChangeBottomNavState());
    }
  }
}
