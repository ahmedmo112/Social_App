
// ignore_for_file: file_names

abstract class SocialRegisterStates {}

class SocialRegisterInitialState extends SocialRegisterStates {}

class SocialRegisterLoadingState extends SocialRegisterStates {}

class SocialRegisterSuccessState extends SocialRegisterStates {
  //  final SocialLoginModel? loginModel;

  // SocialRegisterSuccessState(this.loginModel);
}

class SocialRegisterErrorState extends SocialRegisterStates {
//   final String? error;

//   SocialRegisterErrorState(this.error);
}

class SocialCreateUserSuccessState extends SocialRegisterStates {
   final String uId;

  SocialCreateUserSuccessState(this.uId);

}

class SocialCreateUserErrorState extends SocialRegisterStates {
  final String? error;

  SocialCreateUserErrorState(this.error);

}

class SocialChangePasswordVisibilityState extends SocialRegisterStates {}
