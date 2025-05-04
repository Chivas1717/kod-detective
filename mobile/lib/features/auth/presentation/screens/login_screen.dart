import 'package:clean_architecture_template/core/style/colors.dart';
import 'package:clean_architecture_template/core/style/text_styles.dart';
import 'package:clean_architecture_template/core/widgets/buttons/primary_button.dart';
import 'package:clean_architecture_template/core/widgets/text_fields/outlined_text_field.dart';
import 'package:clean_architecture_template/core/widgets/transitions/transitions.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/login_cubit/login_cubit.dart';
import 'package:clean_architecture_template/features/auth/presentation/widgets/auth_screens_template.dart';
import 'package:clean_architecture_template/features/auth/presentation/widgets/custom_app_bar.dart';
import 'package:clean_architecture_template/features/chats/presentation/screens/home_screen.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture_template/features/auth/presentation/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginCubit loginCubit;
  final _formKey = GlobalKey<FormState>();

  bool showUsernameError = false;
  bool showPasswordError = false;
  String errorMessage = '';

  bool usernameValid = false;
  bool passwordValid = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get activeButton => usernameValid && passwordValid;

  @override
  void initState() {
    loginCubit = sl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
        bloc: loginCubit,
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              FadePageTransition(
                child: const HomeScreen(),
              ),
              (route) => false,
            );
          } else if (state is LoginFailure) {
            setState(() {
              errorMessage = state.errorMessage;
              showUsernameError = true;
              showPasswordError = true;
              _formKey.currentState!.validate();
            });
          }
        },
        builder: (context, state) {
          return AuthScreensTemplate(
            appBar: const CustomAppBar(
              title: 'Авторизація',
            ),
            floatingButton: PrimaryButton(
              active: activeButton,
              title: 'Увійти',
              onTap: () {
                loginCubit.login(usernameController.text, passwordController.text);
              },
            ),
            screenTitle: 'Вхід в акаунт',
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Вітаємо!',
                  style:
                      CTextStyle.titleExtraLarge.copyWith(color: CColors.white),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Text(
                  'Введіть дані для входу нижче',
                  style: CTextStyle.titleMedium.copyWith(color: CColors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    BasicOutlinedTextField(
                      validator: (value) {
                        if (showUsernameError) {
                          return errorMessage;
                        } else {
                          return null;
                        }
                      },
                      controller: usernameController,
                      hint: '',
                      label: 'Логін',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          usernameValid = value.trim().isNotEmpty;
                          showUsernameError = false;
                          if (!showPasswordError) errorMessage = '';
                          _formKey.currentState!.validate();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    BasicOutlinedTextField(
                      validator: (value) {
                        if (showPasswordError) {
                          return errorMessage;
                        } else {
                          return null;
                        }
                      },
                      controller: passwordController,
                      hint: '',
                      label: 'Пароль',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (value) {
                        setState(() {
                          passwordValid = value.trim().length >= 6;
                          showPasswordError = false;
                          if (!showUsernameError) errorMessage = '';
                          _formKey.currentState!.validate();
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              // Add registration redirect text and button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Немає акаунту? ',
                    style: CTextStyle.bodyMedium.copyWith(color: CColors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        FadePageTransition(child: const RegisterScreen()),
                      );
                    },
                    child: Text(
                      'Зареєструватися',
                      style: CTextStyle.bodyMedium.copyWith(
                        color: CColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          );
        });
  }
}
