// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/socialCubit.dart';
import 'package:social_app/layout/cubit/socialstatus.dart';
import 'package:social_app/shared/componants/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon.dart';

class NewPostScreen extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialCreatePostSuccessState) {
          Navigator.pop(context);
          SocialCubit.get(context).removePostImage();
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: defaultAppBar(
              context: context,
              title: 'Create Post',
              actions: [
                TextButton(
                    onPressed: () {
                      var naw = DateTime.now();
                      if (SocialCubit.get(context).postImage == null) {
                        SocialCubit.get(context).createPost(
                            text: textController.text,
                            datetime: naw.toString());
                      } else {
                        SocialCubit.get(context).uploadPostImage(
                            text: textController.text,
                            datetime: naw.toString());
                      }
                    },
                    child: Text('Post')),
              ],
            ),
            body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    if (state is SocialCreatePostLoadingState)
                      LinearProgressIndicator(),
                    if (state is SocialCreatePostLoadingState)
                      SizedBox(
                        height: 10,
                      ),
                    Row(children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            '${SocialCubit.get(context).userModel!.image}'),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: Text(
                          '${SocialCubit.get(context).userModel!.name}',
                          style: TextStyle(height: 1.4),
                        ),
                      ),
                    ]),
                    Expanded(
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                            hintText: 'What is on your mind ....',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    if (SocialCubit.get(context).postImage != null)
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              image: DecorationImage(
                                image: FileImage(
                                        SocialCubit.get(context).postImage!)
                                    as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircleAvatar(
                                radius: 18,
                                // backgroundColor: Colors.white,
                                child: IconButton(
                                    onPressed: () {
                                      SocialCubit.get(context)
                                          .removePostImage();
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      size: 19,
                                    ))),
                          )
                        ],
                      ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                SocialCubit.get(context).getPostImage();
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(IconBroken.Image),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Add photo'),
                                  ])),
                        ),
                        Expanded(
                          child: TextButton(
                              onPressed: () {},
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('# Tags'),
                                  ])),
                        ),
                      ],
                    )
                  ],
                )));
      },
    );
  }
}
