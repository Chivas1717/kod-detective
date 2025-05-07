import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/user_cubit/user_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/blocs/profile/profile_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/completed_tests_list.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SelfProfileScreen extends StatefulWidget {
  const SelfProfileScreen({super.key});

  @override
  State<SelfProfileScreen> createState() => _SelfProfileScreenState();
}

class _SelfProfileScreenState extends State<SelfProfileScreen> {
  late final UserCubit userCubit;
  late final ProfileCubit profileCubit;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userCubit = sl();
    profileCubit = sl();
    profileCubit.getCurrentUserProfile();
  }
  
  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF252538),
        elevation: 4,
        title: const Text(
          'Мій профіль',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        bloc: userCubit,
        builder: (context, userState) {
          if (userState is UserData) {
            return BlocBuilder<ProfileCubit, ProfileState>(
              bloc: profileCubit,
              builder: (context, profileState) {
                if (profileState is ProfileLoading || profileState is ProfileUpdating) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF7B61FF),
                    ),
                  );
                } else if (profileState is ProfileFailure) {
                  return Center(
                    child: Text(
                      'Помилка: ${profileState.message}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (profileState is ProfileData) {
                  return _buildProfileContent(userState.user, profileState);
                }
                
                return const Center(
                  child: Text(
                    'Завантаження профілю...',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          }
          
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF7B61FF),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(User user, ProfileData profileState) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(user)
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                )
                .slideY(
                  begin: -0.2,
                  end: 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                ),
                
            const SizedBox(height: 24),
            
            // Stats Section
            _buildStatsSection(user, profileState)
                .animate()
                .fadeIn(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                )
                .slideY(
                  delay: const Duration(milliseconds: 200),
                  begin: -0.2,
                  end: 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                ),
                
            const SizedBox(height: 24),
            
            // Completed Tests Section
            const Text(
              "Завершені тести",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                ),
                
            const SizedBox(height: 16),
            
            CompletedTestsList(
              completedTests: profileState.completedTests,
            )
                .animate()
                .fadeIn(
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252538),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[800],
            backgroundImage: const NetworkImage(
              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.username ?? 'Користувач',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF7B61FF),
                        size: 20,
                      ),
                      onPressed: () => _showEditUsernameDialog(user),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditUsernameDialog(User user) {
    _usernameController.text = user.username ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF252538),
        title: const Text(
          'Редагувати ім\'я користувача',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: _usernameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Введіть нове ім\'я користувача',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF7B61FF)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Скасувати',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B61FF),
            ),
            onPressed: () {
              if (_usernameController.text.isNotEmpty) {
                profileCubit.updateUsername(_usernameController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Зберегти', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(User user, ProfileData profileState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252538),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Статистика",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.emoji_events,
                value: '${user.score ?? 0}',
                label: 'Бали',
                color: const Color(0xFFFFD700),
              ),
              _buildStatItem(
                icon: Icons.check_circle,
                value: '${profileState.completedTests.length}',
                label: 'Тести',
                color: const Color(0xFF4CAF50),
              ),
              _buildStatItem(
                icon: Icons.trending_up,
                value: _calculateAverageScore(profileState),
                label: 'Середній бал',
                color: const Color(0xFF7B61FF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFADB5BD),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String _calculateAverageScore(ProfileData profileState) {
    if (profileState.completedTests.isEmpty) {
      return '0';
    }
    
    int totalScore = 0;
    for (var test in profileState.completedTests) {
      totalScore += test.scoreObtained;
    }
    
    double average = totalScore / profileState.completedTests.length;
    return average.toStringAsFixed(1);
  }
} 