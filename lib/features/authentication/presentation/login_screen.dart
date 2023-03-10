import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_admin/core/extensions/string_extension.dart';
import 'package:quiz_admin/features/authentication/presentation/widgets/custom_button.dart';
import 'package:quiz_admin/features/authentication/presentation/widgets/login_or_register_text.dart';
import 'package:quiz_admin/resources/colors_manager.dart';

import '../../../core/shared/components/add_vertical_space.dart';
import '../../../core/shared/components/background_image.dart';
import '../../../core/shared/components/custom_form_field.dart';
import '../../../core/shared/components/password_form_field.dart';
import '../../../core/util/dialog_helper.dart';
import '../../../core/util/navigator_helper.dart';
import '../../../resources/app_margins_paddings.dart';
import '../../../resources/app_strings.dart';
import '../../../core/shared/components/build_app_bar.dart';
import '../../home_screen/presentation/home_screen.dart';
import '../cubits/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthStartLoadingState) {
          DialogHelper.loadingDialog(context);
        }
        //
        else if (state is AuthEndLoadingToHomeScreen) {
          Navigator.of(context).pop();
          NavigatorHelper.pushReplacement(
            context,
            const HomeScreen(),
          );
        }
        //
        else if (state is AuthEndLoadingStateWithError) {
          Navigator.of(context).pop();
          DialogHelper.messageDialog(context, state.msg.tr(context));
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: buildAppBar(
              context: context, centerTitle: true, showAddMinus: false),
          body: Stack(
            // fit: StackFit.expand,
            children: [
              const BackgroundImage(),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          // minHeight: constraints.maxHeight,
                          maxWidth: 350,
                        ),
                        padding: const EdgeInsets.all(AppPadding.p32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppPadding.p16),
                          color: ColorsManager.cardColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const LoginOrRegisterText(AppStrings.login),
                            const AddVerticalSpace(AppPadding.p20),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppPadding.p16,
                                AppPadding.p16,
                                AppPadding.p16,
                                AppPadding.p32,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    CustomFormFiled(
                                      context: context,
                                      textInputType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      label: AppStrings.email,
                                      prefixWidget:
                                          const Icon(Icons.mail_outline),
                                      validate: (value) {
                                        return AuthCubit.getIns(context)
                                            .validateEmail(context, value);
                                      },
                                    ),
                                    const AddVerticalSpace(AppPadding.p20),
                                    PasswordFormFiled(
                                      context: context,
                                      controller: _passwordController,
                                      label: AppStrings.password,
                                      validate: (value) {
                                        return AuthCubit.getIns(context)
                                            .validatePassword(context, value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CustomButton(
                              text: AppStrings.login.tr(context),
                              isExtended: true,
                              onTap: () async {
                                await AuthCubit.getIns(context).login(
                                  _emailController.text,
                                  _passwordController.text,
                                  _formKey,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
