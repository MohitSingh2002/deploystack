import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/home/home_page_card.dart';
import '../../../../core/common/widgets/home/home_page_input_field.dart';

class HomePagePublicGitComponent extends StatelessWidget {
  const HomePagePublicGitComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePageCard(
      title: "Public Git URL",
      description:
      "Deploy any public repository instantly.",
      child: Column(
        children: [
          HomePageInputField(hint: "https://github.com/user/repo.git"),
          const SizedBox(height: 10),
          AppButton(
            onPressed: () {},
            buttonText: 'Clone & Deploy',
          ),
        ],
      ),
    );
  }
}
