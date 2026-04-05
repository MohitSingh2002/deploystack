import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_button.dart';
import '../widgets/home_page_card.dart';
import '../widgets/home_page_input_field.dart';

class HomePageDockerComponent extends StatelessWidget {
  const HomePageDockerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePageCard(
      title: "Docker Image",
      description:
      "Deploy containers from Docker Hub.",
      child: Column(
        children: [
          HomePageInputField(hint: "node:latest"),
          const SizedBox(height: 10),
          AppButton(
            onPressed: () {},
            buttonText: 'Pull & Deploy',
          ),
        ],
      ),
    );
  }
}
