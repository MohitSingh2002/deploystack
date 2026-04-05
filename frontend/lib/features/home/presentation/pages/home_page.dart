import 'package:deploystack/core/common/widgets/app_button.dart';
import 'package:deploystack/core/theme/app_colors.dart';
import 'package:deploystack/features/home/presentation/widgets/home_page_card.dart';
import 'package:deploystack/features/home/presentation/widgets/home_page_input_field.dart';
import 'package:deploystack/features/home/presentation/widgets/home_page_side_item.dart';
import 'package:deploystack/features/home/presentation/widgets/home_screen_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<String> _deploymentItems = [
    'GitHub',
    'Docker Image',
    'Public Git URL'
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<AppUserCubit, AppUserState>(
        builder: (context, state) {
          String username = '';
          if (state is AppUser) {
            username = state.username;
          }

          return Row(
            children: [
              Container(
                width: 220,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: AppColors.white70,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "DeployStack",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 30),
                    HomePageSideItem(icon: Icons.dashboard, title: 'Dashboard', active: true,),
                    HomePageSideItem(icon: Icons.folder, title: 'Projects',),
                    HomePageSideItem(icon: Icons.public, title: 'Domains',),
                    HomePageSideItem(icon: Icons.storage, title: 'Domains',),
                    HomePageSideItem(icon: Icons.settings, title: 'Settings',),
                    const Spacer(),
                    ListTile(
                      leading: const Icon(Icons.person, color: AppColors.white70),
                      title: Text(
                        username.isEmpty ? 'Admin' : username,
                        style: const TextStyle(color: AppColors.white),
                      ),
                      subtitle: const Text(
                        'ROOT ACCESS',
                        style: TextStyle(color: AppColors.white38, fontSize: 11),
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Initialize New Deployment",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppButton(
                              onPressed: () {},
                              buttonText: 'Deploy New',
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Select an origin source to provision a new instance.",
                          style: TextStyle(color: AppColors.white54),
                        ),

                        const SizedBox(height: 30),

                        HomeScreenChips(
                          items: _deploymentItems,
                          selectedIndex: _selectedIndex,
                          onSelected: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          }
                        ),

                        const SizedBox(height: 20,),

                        HomePageCard(
                          showIcon: true,
                          icon: FaIcon(FontAwesomeIcons.github, color: Colors.white, size: 75.0,),
                          title: "Connect GitHub",
                          description:
                          "Continuous deployment from repositories.",
                          child: AppButton(
                            onPressed: () {},
                            buttonText: 'Authorize GitHub Access',
                          ),
                        ),

                        HomePageCard(
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
                        ),

                        HomePageCard(
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
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
