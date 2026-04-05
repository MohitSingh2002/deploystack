import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/common/widgets/app_button.dart';
import '../widgets/home_page_card.dart';

class HomePageGithubComponent extends StatelessWidget {
  const HomePageGithubComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePageCard(
      showIcon: true,
      icon: FaIcon(FontAwesomeIcons.github, color: Colors.white, size: 75.0,),
      title: "Connect GitHub",
      description:
      "Continuous deployment from repositories.",
      child: AppButton(
        onPressed: () {},
        buttonText: 'Authorize GitHub Access',
      ),
    );
  }
}
