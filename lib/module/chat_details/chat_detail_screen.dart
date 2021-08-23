// ignore_for_file: unnecessary_const

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:social_app/layout/cubit/socialCubit.dart';
import 'package:social_app/layout/cubit/socialstatus.dart';
import 'package:social_app/model/message_model.dart';

import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel model;
  ChatDetailsScreen(
    this.model,
  );
  var messageController = TextEditingController();
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessage(reciverId: model.uId.toString());

      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                  titleSpacing: 0.0,
                  title: Row(children: [
                    CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 20.0,
                        backgroundImage: NetworkImage('${model.image}')),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(model.name.toString(), style: TextStyle(fontSize: 16))
                  ])),
              body: Conditional.single(
                  context: context,
                  conditionBuilder: (context) =>
                      SocialCubit.get(context).messsage.length > 0,
                  widgetBuilder: (context) => Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(children: [
                          Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                controller: scrollController,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var message =
                                      SocialCubit.get(context).messsage[index];
                                  if (SocialCubit.get(context).userModel!.uId ==
                                      message.senderId) {
                                    return buildMyMesssage(message);
                                  } else {
                                    return buildSenderMesssage(message);
                                  }
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 15,
                                    ),
                                itemCount:
                                    SocialCubit.get(context).messsage.length),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: TextFormField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'type your messsge here ...'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: defultColor,
                                child: IconButton(
                                  onPressed: () {
                                    if (messageController.text != '') {
                                      SocialCubit.get(context).sendMessage(
                                          text: messageController.text,
                                          reciverId: model.uId.toString(),
                                          dateTime: DateTime.now().toString());
                                    }
                                    messageController.clear();
                                    if (SocialCubit.get(context)
                                            .messsage
                                            .length >
                                        0) {
                                      Timer(
                                          Duration(milliseconds: 500),
                                          () => scrollController.jumpTo(
                                              scrollController
                                                  .position.maxScrollExtent));
                                    }
                                  },
                                  icon: Icon(
                                    IconBroken.Send,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                        ]),
                      ),
                  fallbackBuilder: (context) => Center(
                        child: CircularProgressIndicator(),
                      )));
        },
      );
    });
  }

  Widget buildSenderMesssage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadiusDirectional.only(
                topEnd: const Radius.circular(10.0),
                topStart: const Radius.circular(10.0),
                bottomEnd: const Radius.circular(10.0),
              )),
          child: Text(model.text.toString()),
        ),
      );

  Widget buildMyMesssage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: const BorderRadiusDirectional.only(
                topEnd: const Radius.circular(10.0),
                topStart: const Radius.circular(10.0),
                bottomStart: const Radius.circular(10.0),
              )),
          child: Text(model.text.toString()),
        ),
      );
}
