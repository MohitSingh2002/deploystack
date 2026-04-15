import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../deployment_logs/presentation/deployment_logs.dart';
import '../../../git_auth/presentation/git_auth.dart';
import '../../../git_deployment/presentation/git_deployment.dart';
import '../../../home/presentation/components/home_page_docker_component.dart';
import '../../../home/presentation/components/home_page_public_git_component.dart';
import '../dashboard_page_chips.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final List<String> _deploymentItems = [
    'GitHub',
    'Docker Image',
    'Public Git URL'
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Initialize New Deployment",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Select an origin source to provision a new instance.",
              style: TextStyle(color: AppColors.white54),
            ),

            const SizedBox(height: 30),

            DashboardPageChips(
                items: _deploymentItems,
                selectedIndex: _selectedIndex,
                onSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
            ),

            const SizedBox(height: 20,),

            _selectedIndex == 0 ? const GitAuth() : SizedBox(),
            _selectedIndex == 0 ? const GitDeployment() : SizedBox(),

            _selectedIndex == 1 ? const HomePageDockerComponent() : SizedBox(),

            _selectedIndex == 2 ? const HomePagePublicGitComponent() : SizedBox(),

            const SizedBox(height: 20,),

            const Expanded(child: DeploymentLogs()),
          ],
        ),
      ),
    );
  }
}
