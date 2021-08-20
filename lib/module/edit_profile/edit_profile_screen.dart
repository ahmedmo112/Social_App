import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/socialCubit.dart';
import 'package:social_app/layout/cubit/socialstatus.dart';
import 'package:social_app/shared/componants/components.dart';
import 'package:social_app/shared/styles/icon.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var userModel = SocialCubit.get(context).userModel;
          var profileImage = SocialCubit.get(context).profileImage;
          var coverImage = SocialCubit.get(context).coverImage;

          nameController.text = userModel!.name!;
          bioController.text = userModel.bio!;
          phoneController.text = userModel.phone!;

          return Scaffold(
            appBar: defaultAppBar(
                context: context,
                title: 'Edit Profile',
                actions: [
                  TextButton(
                      onPressed: () {
                        SocialCubit.get(context).updateUser(
                            name: nameController.text,
                            phone: phoneController.text,
                            bio: bioController.text);
                      },
                      child: Text('Update')),
                  SizedBox(
                    width: 15,
                  )
                ]),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 190,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? NetworkImage('${userModel.cover}')
                                        : FileImage(coverImage)
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
                                              .getCoverImage();
                                        },
                                        icon: Icon(
                                          IconBroken.Camera,
                                          size: 19,
                                        ))),
                              )
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: profileImage == null
                                      ? NetworkImage('${userModel.image}')
                                      : FileImage(profileImage)
                                          as ImageProvider),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                  radius: 18,
                                  // backgroundColor: Colors.white,
                                  child: IconButton(
                                      onPressed: () {
                                        SocialCubit.get(context)
                                            .getProfileImage();
                                      },
                                      icon: Icon(
                                        IconBroken.Camera,
                                        size: 19,
                                      ))),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'name must not be empty';
                        }
                      },
                      label: 'Name',
                      prefix: IconBroken.User),
                  SizedBox(
                    height: 10,
                  ),
                  defaultFormField(
                      controller: bioController,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'bio must not be empty';
                        }
                      },
                      label: 'Bio',
                      prefix: IconBroken.Info_Circle),
                  SizedBox(
                    height: 10,
                  ),
                  defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'phone number must not be empty';
                        }
                      },
                      label: 'Phone',
                      prefix: IconBroken.Call)
                ],
              ),
            ),
          );
        });
  }
}
