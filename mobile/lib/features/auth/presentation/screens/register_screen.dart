import 'package:clean_architecture_template/core/style/colors.dart';
import 'package:clean_architecture_template/core/style/text_styles.dart';
import 'package:clean_architecture_template/core/widgets/buttons/primary_button.dart';
import 'package:clean_architecture_template/core/widgets/text_fields/outlined_text_field.dart';
import 'package:clean_architecture_template/core/widgets/transitions/transitions.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/register_cubit/register_cubit.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/user_cubit/user_cubit.dart';
import 'package:clean_architecture_template/features/auth/presentation/screens/login_screen.dart';
import 'package:clean_architecture_template/features/auth/presentation/widgets/auth_screens_template.dart';
import 'package:clean_architecture_template/features/auth/presentation/widgets/custom_app_bar.dart';
import 'package:clean_architecture_template/features/tests/presentation/screens/home_screen.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterCubit registerCubit;
  late final UserCubit userCubit;
  final _formKey = GlobalKey<FormState>();

  bool showUsernameError = false;
  bool showEmailError = false;
  bool showPasswordError = false;
  String errorMessage = '';

  bool usernameValid = false;
  bool emailValid = false;
  bool passwordValid = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get activeButton => usernameValid && emailValid && passwordValid;

  @override
  void initState() {
    registerCubit = sl();
    userCubit = sl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
        bloc: registerCubit,
        listener: (context, state) {
          if (state is RegisterSuccess) {
            userCubit.updateUserAfterLogin(state.user);

            Navigator.of(context).pushReplacement(
              FadePageTransition(child: const HomeScreen()),
            );
          } else if (state is RegisterFailure) {
            setState(() {
              errorMessage = state.errorMessage;
              showUsernameError = true;
              showEmailError = true;
              showPasswordError = true;
              _formKey.currentState!.validate();
            });
          }
        },
        builder: (context, state) {
          return AuthScreensTemplate(
            appBar: const CustomAppBar(
              title: 'Реєстрація',
            ),
            floatingButton: PrimaryButton(
              active: activeButton,
              title: 'Зареєструватися',
              onTap: () {
                registerCubit.register(
                  usernameController.text,
                  passwordController.text,
                  emailController.text,
                );
              },
            ),
            screenTitle: 'Створення акаунту',
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Вітаю, юний детектив!',
                  style: CTextStyle.titleExtraLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Text(
                  'Введіть дані для реєстрації нижче',
                  style: CTextStyle.titleMedium.copyWith(
                    color: const Color(0xFFADB5BD),
                  ),
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
                        if (showEmailError) {
                          return errorMessage;
                        } else {
                          return null;
                        }
                      },
                      controller: emailController,
                      hint: '',
                      label: 'Email',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          // Simple email validation
                          emailValid = value.trim().isNotEmpty && value.contains('@') && value.contains('.');
                          showEmailError = false;
                          if (!showUsernameError && !showPasswordError) errorMessage = '';
                          _formKey.currentState!.validate();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
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
                      label: 'Логін (унікальне ім\'я користувача)',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          usernameValid = value.trim().isNotEmpty;
                          showUsernameError = false;
                          if (!showEmailError && !showPasswordError) errorMessage = '';
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
                          if (!showUsernameError && !showEmailError) errorMessage = '';
                          _formKey.currentState!.validate();
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              // Add account redirect text and button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Вже маєте акаунт? ',
                    style: CTextStyle.bodyMedium.copyWith(color: CColors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        FadePageTransition(child: const LoginScreen()),
                      );
                    },
                    child: Text(
                      'Увійти',
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
