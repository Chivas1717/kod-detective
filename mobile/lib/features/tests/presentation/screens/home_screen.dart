import 'package:clean_architecture_template/core/style/colors.dart';
import 'package:clean_architecture_template/core/widgets/transitions/transitions.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/user_cubit/user_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/blocs/home/home_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/leaderboard_section.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/tests_section.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:clean_architecture_template/redirector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late final UserCubit userCubit;
  late final HomeCubit homeCubit;

  @override
  void initState() {
    userCubit = sl();
    homeCubit = sl();
    homeCubit.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      bloc: userCubit,
      listener: (context, state) {},
      builder: (context, state) {
        return state is UserData
            ? BlocBuilder<HomeCubit, HomeState>(
                bloc: homeCubit,
                builder: (context, homeState) {
                  if (homeState is HomeData) {
                    return Scaffold(
                      key: _globalKey,
                      backgroundColor: const Color(0xFF1E1E2E),
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          onPressed: () {
                            _globalKey.currentState!.openDrawer();
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      body: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "Код-детектив",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                )
                                .slideX(
                                  begin: -0.2,
                                  end: 0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOut,
                                ),
                            const SizedBox(height: 8),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "Розв'язуйте завдання і піднімайтеся по рейтингу",
                                style: TextStyle(
                                  color: Color(0xFFADB5BD),
                                  fontSize: 16,
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(
                                  delay: const Duration(milliseconds: 200),
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                )
                                .slideX(
                                  delay: const Duration(milliseconds: 200),
                                  begin: -0.2,
                                  end: 0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOut,
                                ),
                            const SizedBox(height: 30),

                            // Tests Section
                            TestsSection(tests: homeState.tests).animate().fadeIn(
                                  delay: const Duration(milliseconds: 600),
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                ),

                            const SizedBox(height: 30),

                            // Leaderboard Section
                            LeaderboardSection(leaderBoard: homeState.leaderBoard).animate().fadeIn(
                                  delay: const Duration(milliseconds: 400),
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                ),

                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                      drawer: CustomDrawer(
                        user: state.user,
                        userCubit: userCubit,
                      ),
                    );
                  }

                  return const Scaffold(
                    backgroundColor: Color(0xFF1E1E2E),
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7B61FF),
                      ),
                    ),
                  );
                })
            : const Scaffold(
                backgroundColor: Color(0xFF1E1E2E),
                body: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF7B61FF),
                  ),
                ),
              );
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.user, required this.userCubit});
  final User user;
  final UserCubit userCubit;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 275,
      elevation: 30,
      backgroundColor: const Color(0xF3393838),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(40),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Color(0x3D000000),
              spreadRadius: 30,
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: CColors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 56,
                      ),
                      const Text(
                        'Settings',
                        style: TextStyle(color: CColors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[800],
                        backgroundImage: const NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        user.username ?? '',
                        style: TextStyle(color: CColors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  const DrawerItem(
                    title: 'Account',
                    icon: Icons.key,
                  ),
                  const DrawerItem(title: 'Chats', icon: Icons.chat_bubble),
                  const DrawerItem(title: 'Notifications', icon: Icons.notifications),
                  const DrawerItem(title: 'Data and Storage', icon: Icons.storage),
                  const DrawerItem(title: 'Help', icon: Icons.help),
                  const Divider(
                    height: 35,
                    color: CColors.green,
                  ),
                  const DrawerItem(title: 'Invite a friend', icon: Icons.people_outline),
                ],
              ),
              DrawerItem(
                title: 'Log out',
                icon: Icons.logout,
                onTap: () {
                  print('here');
                  userCubit.logOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    FadePageTransition(
                      child: const RedirectPage(),
                    ),
                    (route) => false,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;
  const DrawerItem({super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            Icon(
              icon,
              color: CColors.white,
              size: 20,
            ),
            const SizedBox(
              width: 40,
            ),
            Text(
              title,
              style: const TextStyle(color: CColors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
