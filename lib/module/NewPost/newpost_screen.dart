import 'package:flutter/material.dart';
import 'package:social_app/shared/componants/components.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        context: context,
        title: 'Add Post'
        
        )
    );
  }
}