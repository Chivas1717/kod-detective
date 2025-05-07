import 'package:clean_architecture_template/features/tests/domain/entities/test.dart';
import 'package:clean_architecture_template/features/tests/presentation/widgets/chat_row.dart';
import 'package:flutter/material.dart';

class TestsList extends StatefulWidget {
  const TestsList({super.key, required this.tests});
  final List<Test> tests;

  @override
  State<TestsList> createState() => _TestsListState();
}

class _TestsListState extends State<TestsList> {
  @override
  Widget build(BuildContext context) {
    print(widget.tests);
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 25),
      children: [
        ...List.generate(
          widget.tests.length,
          (index) => TestRow(
            img: 'img1.jpeg',
            name: widget.tests[index].title!,
            testId: widget.tests[index].id!,
          ),
        ),
        // ChatRow(img: 'img1.jpeg', name: 'Laura', message: 'Hello, how are you'),
        // ChatRow(img: 'img2.jpeg', name: 'Kalya', message: 'Hello, how are you'),
        // ChatRow(img: 'img3.jpeg', name: 'Mary', message: 'Hello, how are you'),
        // ChatRow(img: 'img4.jpg', name: 'Hellen', message: 'Hello, how are you'),
        // ChatRow(img: 'img5.jpeg', name: 'Lren', message: 'Hello, how are you'),
        // ChatRow(img: 'img6.jpeg', name: 'Tom', message: 'Hello, how are you'),
        // ChatRow(img: 'img7.jpeg', name: 'Laura', message: 'Hello, how are you'),
      ],
    );
  }
}
