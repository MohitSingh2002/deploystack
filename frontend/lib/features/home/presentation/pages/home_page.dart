import 'package:deploystack/core/theme/app_colors.dart';
import 'package:deploystack/core/utils/app_routes.dart';
import 'package:deploystack/features/home/presentation/widgets/home_page_side_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';

class HomePage extends StatefulWidget {
  Widget child;

  HomePage({super.key, required this.child,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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

                    HomePageSideItem(
                      route: AppRoutes.dashboard,
                      icon: Icons.dashboard,
                      title: 'Dashboard',
                      active: AppRoutes.getCurrentRoute(context: context) == AppRoutes.dashboard,
                    ),
                    HomePageSideItem(
                      route: AppRoutes.projects,
                      icon: Icons.folder,
                      title: 'Projects',
                      active: AppRoutes.getCurrentRoute(context: context) == AppRoutes.projects,
                    ),
                    HomePageSideItem(
                      icon: Icons.public,
                      title: 'Domains',
                      route: AppRoutes.dashboard,
                    ),
                    HomePageSideItem(
                      icon: Icons.storage,
                      title: 'Domains',
                      route: AppRoutes.dashboard,
                    ),
                    HomePageSideItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      route: AppRoutes.dashboard,
                    ),

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
                child: widget.child,
              )
            ],
          );
        },
      ),
    );
  }
}
