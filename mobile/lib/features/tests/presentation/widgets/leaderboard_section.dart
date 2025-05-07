import 'package:clean_architecture_template/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

class LeaderboardSection extends StatelessWidget {
  final List<User> leaderBoard;

  const LeaderboardSection({
    super.key,
    required this.leaderBoard,
  });

  @override
  Widget build(BuildContext context) {
    // Limit to top 5 users
    final displayedUsers = leaderBoard.length > 5 
        ? leaderBoard.sublist(0, 5) 
        : leaderBoard;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Таблиця лідерів",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF282838),
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
            children: [
              for (int i = 0; i < displayedUsers.length; i++)
                LeaderboardUserTile(
                  user: displayedUsers[i],
                  position: i + 1,
                  isFirst: i == 0,
                ),
            ],
          ),
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
    return Container(
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