import 'package:flutter/material.dart';

class ChildrenContainer extends StatelessWidget {
  const ChildrenContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          roundContainerExample(Colors.blue),
          roundContainerExample(Colors.red),
          roundContainerExample(Colors.yellowAccent)
        ],
      ),
    );
  }

  Container roundContainerExample(Color color) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.25), // border color
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(2), // border width
        child: Container(
          // or ClipRRect if you need to clip the content
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color, // inner circle color
          ),
          child: Container(), // inner content
        ),
      ),
    );
  }
}
