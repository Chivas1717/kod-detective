import 'package:clean_architecture_template/core/style/colors.dart';
import 'package:clean_architecture_template/core/widgets/transitions/transitions.dart';
import 'package:clean_architecture_template/features/chats/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatRow extends StatefulWidget {
  final String img, name, message;
  final int chatId;
  const ChatRow({
    super.key,
    required this.img,
    required this.name,
    required this.message,
    required this.chatId,
  });

  @override
  State<ChatRow> createState() => _ChatRowState();
}

class _ChatRowState extends State<ChatRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).push(
          FadePageTransition(
              child: ChatScreen(
            chatId: widget.chatId,
          )),
        );
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: CColors.white,
                    child: CircleAvatar(
                      radius: 29,
                      backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(color: CColors.grey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.message,
                        style: TextStyle(
                            color: widget.message == 'Joined recently...'
                                ? CColors.secondary
                                : CColors.black),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, top: 5),
                child: Column(
                  children: [
                    const Text(
                      '16:35',
                      style: TextStyle(fontSize: 10),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (true)
                      CircleAvatar(
                        radius: 7,
                        backgroundColor: const Color(0xFF27c1a9),
                        child: Text(
                          '3',
                          style: const TextStyle(
                              fontSize: 10, color: CColors.white),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
          const Divider(
            indent: 70,
            height: 20,
          )
        ],
      ),
    );
  }
}
