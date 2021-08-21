// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:social_app/layout/cubit/socialCubit.dart';
import 'package:social_app/layout/cubit/socialstatus.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Conditional.single(
            context: context,
            conditionBuilder: (context) =>
               SocialCubit.get(context).posts.length > 0 &&
                 SocialCubit.get(context).userModel != null,
            widgetBuilder: (context) => SingleChildScrollView(
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
                              height: 150,
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
                            SocialCubit.get(context).posts[index], context,index),
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

  Widget buildPostItem(PostModel model, context ,int index) => Card(
      elevation: 6.0,
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
                  backgroundImage: NetworkImage(
                      '${model.image}'),
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
                  onPressed: () {},
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
                          Text('0 Comments',
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
                    onTap: () {},
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
}
