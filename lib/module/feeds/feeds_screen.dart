// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:social_app/layout/cubit/socialCubit.dart';
import 'package:social_app/layout/cubit/socialstatus.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon.dart';

class FeedsScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Conditional.single(
            context: context,
            conditionBuilder: (context) =>
                SocialCubit.get(context).posts.isNotEmpty &&
                SocialCubit.get(context).userModel != null,
            widgetBuilder: (context) => RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(Duration(seconds: 2), () {
                      //SocialCubit.get(context).getPosts();
                      SocialCubit.get(context).refreshHome();
                    });
                  },
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Card(
                          elevation: 5.0,
                          margin: EdgeInsets.all(8.0),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Image(
                                image: NetworkImage(
                                    'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg'),
                                fit: BoxFit.cover,
                                height: 170,
                                width: double.infinity,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Communicate with friends',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildPostItem(
                              SocialCubit.get(context).posts[index],
                              context,
                              index,
                              state),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          itemCount: SocialCubit.get(context).posts.length,
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  ),
                ),
            fallbackBuilder: (context) => Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballScaleMultiple,
                      colors: const [defultColor, Colors.cyan],
                      strokeWidth: 2,
                    ),
                  ),
                ));
      },
    );
  }

  Widget buildPostItem(PostModel model, context, int index, state) => Card(
      elevation: 8.0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage('${model.image}'),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${model.name}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(height: 1.4),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: defultColor,
                              size: 16,
                            ),
                          ],
                        ),
                        Text(
                          '${model.dateTime}',
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(height: 1.4),
                        ),
                      ]),
                ),
                SizedBox(
                  width: 15,
                ),
                IconButton(
                  onPressed: () {
                    print('pressed');
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                'Delete?',
                                style: TextStyle(color: Colors.red),
                              ),
                              content: Text('Do you want to delete this post?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      SocialCubit.get(context).deletePost(
                                          postId: SocialCubit.get(context).postID[index]);
                                      Navigator.pop(context);


                                    },
                                    child: Text('Yes')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('No')),
                              ],
                            ));
                  },
                  icon: Icon(
                    Icons.more_horiz,
                    size: 18.0,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
            Text('${model.text}', style: Theme.of(context).textTheme.subtitle1),
            // Padding(
            //   padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            //   child: Container(
            //     width: double.infinity,
            //     child: Wrap(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsetsDirectional.only(end: 6),
            //           child: Container(
            //             height: 25,
            //             child: MaterialButton(
            //               onPressed: () {},
            //               minWidth: 1,
            //               padding: EdgeInsets.zero,
            //               child: Text('#software_development',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .caption!
            //                       .copyWith(color: defultColor)),
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsetsDirectional.only(end: 6),
            //           child: Container(
            //             height: 25,
            //             child: MaterialButton(
            //               onPressed: () {},
            //               minWidth: 1,
            //               padding: EdgeInsets.zero,
            //               child: Text('#Flutter',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .caption!
            //                       .copyWith(color: defultColor)),
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsetsDirectional.only(end: 6),
            //           child: Container(
            //             height: 25,
            //             child: MaterialButton(
            //               onPressed: () {},
            //               minWidth: 1,
            //               padding: EdgeInsets.zero,
            //               child: Text('#software_eng',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .caption!
            //                       .copyWith(color: defultColor)),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            if (model.postImage != '')
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 15),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: NetworkImage('${model.postImage}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            size: 17,
                            color: Colors.red,
                          ),
                          Text('${SocialCubit.get(context).likes[index]} Likes',
                              style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            IconBroken.Chat,
                            size: 17,
                            color: Colors.amber,
                          ),
                          Text(
                              '${SocialCubit.get(context).postCommentsNum[index]} Comments',
                              style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      SocialCubit.get(context).getcomments(
                          postId: SocialCubit.get(context).postID[index]);
                      Timer(
                          Duration(milliseconds: 500),
                          () => showModalBottomSheet(
                              context: context,
                              builder: (context) => buildCommentBottomSheet(
                                  context, index, state)));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: NetworkImage(
                              '${SocialCubit.get(context).userModel!.image}'),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'Write a comment...',
                          style:
                              Theme.of(context).textTheme.caption!.copyWith(),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    SocialCubit.get(context)
                        .likePost(SocialCubit.get(context).postID[index]);
                  },
                  child: Row(
                    children: [
                      Icon(
                        IconBroken.Heart,
                        size: 17,
                        color: Colors.red,
                      ),
                      Text('Like', style: Theme.of(context).textTheme.caption)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ));

  Widget buildCommentBottomSheet(context, index, state) => Container(
      height: 600,
      color: Color(0xFF737373),
      child: Container(
          //height: 500,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: SocialCubit.get(context).comments.length > 0
                        ? ListView.separated(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => buildCommentbody(
                                SocialCubit.get(context).comments[index]),
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 20,
                                ),
                            itemCount: SocialCubit.get(context).comments.length)
                        : Container(
                            width: 200, child: Center(child: Text('Empty')))),
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
                                color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          controller: commentController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'type your comment here ...'),
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
                          SocialCubit.get(context).sendCommentPost(
                              SocialCubit.get(context).postID[index],
                              commentController.text);
                          commentController.clear();
                          // SocialCubit.get(context).getcomments(
                          //     postId: SocialCubit.get(context).postID[index]);
                        },
                        icon: Icon(
                          IconBroken.Chat,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )));

  Widget buildCommentbody(CommentModel model) => Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(model.image.toString()),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: 250,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: defultColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(model.text.toString()),
          )
        ],
      );
}
