import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:social_app/layout/cubit/socialCubit.dart';
import 'package:social_app/layout/cubit/socialstatus.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/module/chat_details/chat_detail_screen.dart';
import 'package:social_app/shared/componants/components.dart';
import 'package:social_app/shared/styles/colors.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Conditional.single(
            context: context,
            conditionBuilder: (context) =>
                SocialCubit.get(context).users.length > 0,
            widgetBuilder: (context) => ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => chatItemBuilder(
                    context, SocialCubit.get(context).users[index]),
                separatorBuilder: (context, index) => Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                itemCount: SocialCubit.get(context).users.length),
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

  Widget chatItemBuilder(context, UserModel model) => InkWell(
        onTap: () {
          navigateTo(context, ChatDetailsScreen(model));
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(children: [
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
                  Row(children: [
                    Expanded(
                      child: Text(
                        '${model.name}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(height: 1.4),
                      ),
                    )
                  ]),
                ]))
          ]),
        ),
      );
}
