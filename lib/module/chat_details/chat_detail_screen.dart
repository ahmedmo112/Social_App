// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

import 'package:social_app/model/user_model.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel model;
  ChatDetailsScreen(
    this.model,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0.0,
            title: Row(children: [
              CircleAvatar(
                backgroundColor:Colors.grey[300],
                  radius: 20.0,
                  backgroundImage: NetworkImage('${model.image}')),
              SizedBox(
                width: 15.0,
              ),
              Text(model.name.toString(), style: TextStyle(
                fontSize: 16
              ))
            ])
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children : [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadiusDirectional.only(
                          topEnd:const Radius.circular(10.0) ,
                          topStart: const Radius.circular(10.0),
                          bottomEnd: const Radius.circular(10.0),
                   
                        )
                      ),
                      child: Text('Hello world'),
                    ),
                  ),
                   Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      decoration: BoxDecoration(
                        color: defultColor.withOpacity(0.2),
                        borderRadius: const BorderRadiusDirectional.only(
                          topEnd:const Radius.circular(10.0) ,
                          topStart: const Radius.circular(10.0),
                          bottomStart: const Radius.circular(10.0),
                   
                        )
                      ),
                      child: Text('Hello world'),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            
                    border: Border.all(
                      
                      color: Colors.grey.shade300,
                      width: 1
                    ),
                    borderRadius: BorderRadius.circular(15)
                  ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              
                              border: InputBorder.none,
                              hintText: 'type your messsge here ...'
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8, ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: defultColor,
                        child: IconButton(
                          onPressed: (){},
                          
                          icon: Icon(
                            IconBroken.Send, size: 18, color: Colors.white,
                          ),
                          ),
                      )
                    ],
                  )
                ]
              ),
            ),
            
            );
  }
}
