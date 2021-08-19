abstract class SocialStates {}

class SocialInitnalState extends SocialStates {}

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  final String error;

  SocialGetUserErrorState(this.error);

}


class ChangeBottomNavState extends SocialStates{}

class NewPostState extends SocialStates{}
