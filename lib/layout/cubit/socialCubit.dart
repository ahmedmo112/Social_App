// ignore_for_file: file_names
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/socialstatus.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/module/NewPost/newpost_screen.dart';
import 'package:social_app/module/chats/chats_screen.dart';
import 'package:social_app/module/feeds/feeds_screen.dart';
import 'package:social_app/module/settings/settiings_screen.dart';
import 'package:social_app/module/users/users_screen.dart';
import 'package:social_app/shared/componants/components.dart';
import 'package:social_app/shared/constants/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitnalState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print(value.data());
      userModel = UserModel.fromJson(value.data());
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
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen()
  ];

  List<String> titles = ['Home', 'Chat', 'Add Post', 'Users', 'Settings'];

  void changeBottomNav(int index) {
    if (index == 2) {
      emit(NewPostState());
    } else {
      currentIndex = index;
      emit(ChangeBottomNavState());
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  String profileImageUrl = ' ';

  void uploadProfileImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('SUCCESS: $value');
        profileImageUrl = value;
        emit(SocialUploadProfileImageSuccessState());
      }).catchError((e) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((e) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  String coverImageUrl = ' ';

  void uploadCoverImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('SUCCESS: $value');
        coverImageUrl = value;
        emit(SocialUploadCoverImageSuccessState());
      }).catchError((e) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((e) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
  }) {
    if (coverImage != null) {
      uploadCoverImage();
    }else if (profileImage != null){
      uploadProfileImage();
    }else{
      UserModel model = UserModel(
        name: name,
        phone: phone,
        bio: bio,
        isEmailVerified: false);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((e) {
      emit(SocialUserUpdateErrorState());
    });
    }

    
  }
}
