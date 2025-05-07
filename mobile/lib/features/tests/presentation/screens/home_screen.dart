import 'package:clean_architecture_template/core/style/colors.dart';
import 'package:clean_architecture_template/core/widgets/transitions/transitions.dart';
import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/user_cubit/user_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/blocs/home/home_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/screens/self_profile_screen.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/leaderboard_section.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/tests_section.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:clean_architecture_template/redirector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/language_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late final UserCubit userCubit;
  late final HomeCubit homeCubit;
  final RefreshIndicatorMode _refreshIndicatorMode = RefreshIndicatorMode.inactive;

  @override
  void initState() {
    userCubit = sl();
    homeCubit = sl();
    homeCubit.getData();
    super.initState();
  }

  Future<void> _refreshData() async {
    homeCubit.getData();
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
                      body: RefreshIndicator(
                        color: const Color(0xFF7B61FF),
                        backgroundColor: const Color(0xFF252538),
                        onRefresh: _refreshData,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
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
                                    delay: const Duration(milliseconds: 100),
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeInOut,
                                  )
                                  .slideX(
                                    delay: const Duration(milliseconds: 100),
                                    begin: -0.2,
                                    end: 0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                  ),

                              const SizedBox(height: 30),

                              // Language Filter
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: LanguageFilter(
                                  languages: homeState.languages,
                                  selectedLanguageId: homeState.selectedLanguageId,
                                  onLanguageSelected: (languageId) {
                                    homeCubit.selectLanguage(languageId);
                                  },
                                  onClearFilter: () {
                                    homeCubit.clearLanguageFilter();
                                  },
                                ),
                              ).animate().fadeIn(
                                    delay: const Duration(milliseconds: 200),
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeInOut,
                                  ),

                              const SizedBox(height: 30),

                              // Tests Section
                              TestsSection(tests: homeState.filteredTests).animate().fadeIn(
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
                      ),
                      drawer: CustomDrawer(
                        user: state.user,
                        userCubit: userCubit,
                      ),
                    );
                  }

                  return Scaffold(
                    backgroundColor: const Color(0xFF1E1E2E),
                    body: Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFF7B61FF),
                      ),
                    ),
                  );
                })
            : Scaffold(
                backgroundColor: const Color(0xFF1E1E2E),
                body: Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFF7B61FF),
                  ),
                ),
              );
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final User user;
  final UserCubit userCubit;

  const CustomDrawer({
    super.key,
    required this.user,
    required this.userCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF252538),
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
                      'Меню',
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
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      user.username ?? '',
                      style: const TextStyle(color: CColors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 35,
                ),
                // Profile button
                _buildDrawerButton(
                  context: context,
                  icon: Icons.person,
                  label: 'Мій профіль',
                  onTap: () {
                    Navigator.of(context).pop(); // Close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelfProfileScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Logout button
                _buildDrawerButton(
                  context: context,
                  icon: Icons.logout,
                  label: 'Вийти',
                  onTap: () {
                    userCubit.logOut();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
