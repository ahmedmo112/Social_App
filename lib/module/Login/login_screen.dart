import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/module/register/register_screen.dart';
import 'package:social_app/shared/componants/components.dart';
import 'package:social_app/shared/constants/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

import 'cubit/cubitLogin.dart';
import 'cubit/statusLogin.dart';

class SocialLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
          listener: (context, state) {
        if (state is SocialLoginErrorState) {
          showToast(text: state.error.toString(), state: ToastStates.ERROR);
        }
        if (state is SocialLoginSuccessState) {
          print('user uId : $uId');
          CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
            
            navigateAndFinish(context, const SocialLayout());
          });
        }
      }, builder: (context, state) {
        return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'login now to communicate with freinds',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your email';
                              }
                            },
                            label: 'Email Address',
                            prefix: Icons.email_outlined),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: SocialLoginCubit.get(context).suffix,
                            suffixPressed: () {
                              SocialLoginCubit.get(context)
                                  .changePassworsVisiility();
                            },
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                // SocialLoginCubit.get(context).userLogin(
                                //   email: emailController.text,
                                //   password: passwordController.text,
                                // );
                              }
                            },
                            isPassword:
                                SocialLoginCubit.get(context).isPassword,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'password is too short';
                              }
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline),
                        const SizedBox(
                          height: 30.0,
                        ),
                        state is! SocialLoginLoadingState
                            ? defaultButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    SocialLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context
                                    );
                                    //   ShopCubit.get(context).getFavorites();
                                    //  ShopCubit.get(context).getUserData();
                                  }
                                },
                                text: 'Login',
                                isUpperCase: true,
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child: Text('register'.toUpperCase()),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
      }),
    );
  }
}
