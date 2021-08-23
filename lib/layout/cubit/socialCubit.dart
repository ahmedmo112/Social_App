// ignore_for_file: file_names
import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/socialstatus.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/model/message_model.dart';
import 'package:social_app/model/post_model.dart';
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
      // messsage = [];
      // currentIndex = 0;
      // posts = [];
      // postID = [];
      // likes = [];
      // users = [];
      // userModel = null;
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
    if (index == 1) {
      getAllUsers();
    }
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

  String? profileImageUrl;

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('SUCCESS: $value');
        profileImageUrl = value;

        updateUser(name: name, phone: phone, bio: bio, image: profileImageUrl);

        emit(SocialUploadProfileImageSuccessState());
      }).catchError((e) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((e) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  String? coverImageUrl;

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('SUCCESS: $value');
        coverImageUrl = value;
        updateUser(name: name, phone: phone, bio: bio, cover: coverImageUrl);
        emit(SocialUploadCoverImageSuccessState());
      }).catchError((e) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((e) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void uploadCoverAndProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    //! first upload cover
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;

        //! then upload profile
        firebase_storage.FirebaseStorage.instance
            .ref()
            .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
            .putFile(profileImage!)
            .then((value) {
          value.ref.getDownloadURL().then((value) {
            print('SUCCESS: $value');
            profileImageUrl = value;

            updateUser(
                name: name,
                phone: phone,
                bio: bio,
                image: profileImageUrl,
                cover: coverImageUrl);

            emit(SocialUploadProfileAndCoverImageSuccessState());
          }).catchError((e) {
            emit(SocialUploadProfileAndCoverImageErrorState());
          });
        }).catchError((e) {
          emit(SocialUploadProfileImageErrorState());
        });
      }).catchError((e) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((e) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void checkBeforeUpdateUserData({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    if (coverImage != null && profileImage != null) {
      uploadCoverAndProfileImage(name: name, phone: phone, bio: bio);
      print('cover& profile');
    } else if (coverImage != null || profileImage != null) {
      if (coverImage != null) {
        uploadCoverImage(name: name, phone: phone, bio: bio);
        print('cover');
      } else if (profileImage != null) {
        uploadProfileImage(name: name, phone: phone, bio: bio);
        print('profile');
      }
    } else {
      updateUser(name: name, phone: phone, bio: bio);
    }
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    UserModel updateModel = UserModel(
        name: name,
        phone: phone,
        bio: bio,
        cover: cover ?? userModel!.cover,
        image: image ?? userModel!.image,
        email: userModel!.email,
        uId: userModel!.uId,
        isEmailVerified: false);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(updateModel.toMap())
        .then((value) {
      coverImage = null;
      profileImage = null;
      getUserData();
      emit(SocialUserUpdateSuccessState());
    }).catchError((e) {
      emit(SocialUserUpdateErrorState());
    });
  }

  //! Posts

  File? postImage;

  void removePostImage() {
    postImage = null;
    emit(SocialPostImageRemovedState());
  }

  Future getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void uploadPostImage({
    required String text,
    required String datetime,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text, datetime: datetime, postImage: value);

        emit(SocialCreatePostSuccessState());
      }).catchError((e) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((e) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String text,
    required String datetime,
    String? postImage,
  }) {
    PostModel postModel = PostModel(
        name: userModel!.name,
        image: userModel!.image,
        uId: userModel!.uId,
        dateTime: datetime,
        text: text,
        postImage: postImage ?? '');

    emit(SocialCreatePostLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      posts = [];
      //getPosts();
      emit(SocialCreatePostSuccessState());
    }).catchError((e) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postID = [];
  List<int> likes = [];
  List<int> postCommentsNum = [];

  void getPosts() {
    emit(SocialGetPostLoadingState());

    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((valuelike) {
          element.reference.collection("comments").get().then((value) {
            likes.add(valuelike.docs.length);
            postCommentsNum.add(value.docs.length);
            postID.add(element.id);
            posts.add(PostModel.fromJson(element.data()));
            emit(SocialGetPostSuccessState());
          });
        }).catchError((e) {});
      });
      emit(SocialGetPostSuccessState());
    }).catchError((e) {
      emit(SocialGetPostErrorState(e.toString()));
    });
  }

  void test() {}

  //? create method to get realTime likes like [likePost] with change set to snapshot like [getMessage]

  void likePost(String? postID) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((e) {
      emit(SocialLikePostErrorState(e.toString()));
    });
  }

  void sendCommentPost(String? postID, String? text) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('comments')
        .doc()
        .set({'postId': postID, 'text': text, 'image': userModel!.image}).then(
            (value) {
      emit(SocialCommentPostSuccessState());
    }).catchError((e) {
      emit(SocialCommentPostErrorState());
    });
  }

  List<CommentModel> comments = [];
  CommentModel? commentModel;

  void getcomments({required String postId}) {
    emit(SocialGetCommentPostLoadingState());
    comments = [];
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        commentModel = CommentModel.fromJson(element.data());
        comments.add(commentModel!);
      });

      emit(SocialGetCommentPostSuccessState());
    }).catchError((e) {
      emit(SocialGetCommentPostErrorState());
    });
  }

  //! Chat
  List<UserModel> users = [];

  void getAllUsers() {
    emit(SocialGetAllUsersLoadingState());
    if (users.length == 0) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId) {
            users.add(UserModel.fromJson(element.data()));
          }
        });
        emit(SocialGetAllUsersSuccessState());
      }).catchError((e) {
        emit(SocialGetAllUsersErrorState(e.toString()));
      });
    }
  }

  void sendMessage({
    required String text,
    required String reciverId,
    required String dateTime,
  }) {
    MessageModel messageModel = MessageModel(
        text: text,
        senderId: userModel!.uId,
        reciverId: reciverId,
        dateTime: dateTime);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(reciverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((e) {
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(reciverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((e) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messsage = [];
  // var scroll = ScrollController();

  void getMessage({required String reciverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(reciverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messsage = [];
      event.docs.forEach((element) {
        messsage.add(MessageModel.fromJson(element.data()));
      });

      emit(SocialGetMessageSuccessState());
    });
  }

  void refreshHome() async {
    posts = [];
    getPosts();
  }

  // void scrollChat(){
  //     scroll.animateTo(
  //                                     scroll.position.maxScrollExtent,
  //                                       duration: Duration(milliseconds:1),
  //                                       curve: Curves.easeInOut);
  // }
}
