import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:clean_architecture_template/features/auth/presentation/blocs/user_cubit/user_cubit.dart';
import 'package:clean_architecture_template/features/tests/presentation/screens/other_user_profile_screen.dart';
import 'package:clean_architecture_template/features/tests/presentation/screens/self_profile_screen.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:flutter/material.dart';

class LeaderboardSection extends StatelessWidget {
  final List<User> leaderBoard;

  const LeaderboardSection({
    super.key,
    required this.leaderBoard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Лідери",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          itemCount: leaderBoard.length > 5 ? 5 : leaderBoard.length,
          itemBuilder: (context, index) {
            final user = leaderBoard[index];
            return LeaderboardUserTile(
              user: user,
              position: index + 1,
              isFirst: index == 0,
            );
          },
        ),
      ],
    );
  }
}

class LeaderboardUserTile extends StatelessWidget {
  final User user;
  final int position;
  final bool isFirst;

  const LeaderboardUserTile({
    super.key,
    required this.user,
    required this.position,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current user from UserCubit to check if this is the current user
    final userCubit = sl<UserCubit>();
    final currentUser = userCubit.state is UserData ? (userCubit.state as UserData).user : null;
    final isSelfUser = currentUser?.id == user.id;

    return GestureDetector(
      onTap: () {
        // Navigate to appropriate profile screen based on whether this is the current user
        if (user.id != null) {
          if (isSelfUser) {
            // Navigate to self profile
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SelfProfileScreen(),
              ),
            );
          } else {
            // Navigate to other user profile
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherUserProfileScreen(userId: user.id!),
              ),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isFirst ? const Color(0xFF3D3A4F) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isFirst 
              ? Border.all(color: const Color(0xFFFFD700), width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _getPositionColor(position),
                shape: BoxShape.circle,
              ),
              child: Text(
                position.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[800],
              backgroundImage: const NetworkImage(
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                user.username ?? 'Unknown User',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isFirst ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
            if (isFirst)
              const Icon(
                Icons.emoji_events,
                color: Color(0xFFFFD700),
                size: 24,
              ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF7B61FF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${user.score ?? 0} pts",
                style: const TextStyle(
                  color: Color(0xFF7B61FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFF7B61FF); // Purple for others
    }
  }
}
