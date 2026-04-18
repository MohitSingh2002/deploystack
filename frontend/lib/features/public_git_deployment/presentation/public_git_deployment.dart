import 'package:deploystack/core/common/widgets/loading.dart';
import 'package:deploystack/core/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/common/widgets/app_button.dart';
import '../../../core/common/widgets/home/home_page_card.dart';
import '../../../core/common/widgets/home/home_page_input_field.dart';
import 'bloc/public_git_deployment/public_git_deployment_bloc.dart';

class PublicGitDeployment extends StatefulWidget {
  const PublicGitDeployment({super.key});

  @override
  State<PublicGitDeployment> createState() => _PublicGitDeploymentState();
}

class _PublicGitDeploymentState extends State<PublicGitDeployment> {
  final TextEditingController _cloneUrl = TextEditingController();

  @override
  void dispose() {
    _cloneUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomePageCard(
      title: "Public Git URL",
      description:
      "Deploy any public repository instantly.",
      child: BlocConsumer<PublicGitDeploymentBloc, PublicGitDeploymentState>(
        listener: (context, state) {
          if (state is PublicGitDeploymentErrorState) {
            showSnackBar(context: context, content: state.message,);
          }

          if (state is PublicGitDeploymentSuccessState) {
            _cloneUrl.clear();
            showSnackBar(context: context, content: 'Deployment created. It will begin after any ongoing deployment completes.', longDuration: true);
          }
        },
        builder: (context, state) {
          if (state is PublicGitDeploymentLoadingState) {
            return Center(
              child: Loading(),
            );
          }

          return Column(
            children: [
              HomePageInputField(
                hint: "https://github.com/user/repo.git",
                controller: _cloneUrl,
              ),
              const SizedBox(height: 10),
              AppButton(
                onPressed: () {
                  if (_cloneUrl.text.trim().isEmpty) {
                    showSnackBar(context: context, content: 'Please enter url to continue');
                  } else {
                    context.read<PublicGitDeploymentBloc>().add(DeployGitProjectEvent(cloneUrl: _cloneUrl.text.trim(),));
                  }
                },
                buttonText: 'Clone & Deploy',
              ),
            ],
          );
        },
      ),
    );
  }
}
