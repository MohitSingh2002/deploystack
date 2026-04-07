import 'package:deploystack/core/common/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/common/widgets/app_button.dart';
import '../../../core/common/widgets/home/home_page_card.dart';
import '../../../core/github_auth_checker/presentation/bloc/git_authenticated/git_authenticated_bloc.dart';

class GitAuth extends StatelessWidget {
  const GitAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GitAuthenticatedBloc, GitAuthenticatedState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is GitAuthenticatedLoadingState) {
          return Loading();
        }

        if ((state is IsGitAuthenticatedState) && state.isAuthenticated) {
          return SizedBox();
        }

        return HomePageCard(
          showIcon: true,
          icon: FaIcon(
            FontAwesomeIcons.github, color: Colors.white, size: 75.0,),
          title: "Connect GitHub",
          description:
          "Continuous deployment from repositories.",
          child: AppButton(
            onPressed: () {},
            buttonText: 'Authorize GitHub Access',
          ),
        );
      },
    );
  }
}
