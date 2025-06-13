import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: SizeConfig.hp(10),
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
            Container(
              height: SizeConfig.hp(30),
              color: Colors.grey[200],
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
          ],
        );
      },
    );
  }
}
