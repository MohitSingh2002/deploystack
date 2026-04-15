import 'package:deploystack/core/common/widgets/loading.dart';
import 'package:deploystack/core/utils/show_snackbar.dart';
import 'package:deploystack/features/projects/presentation/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/projects_bloc/projects_bloc.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {

  @override
  void initState() {
    super.initState();

    context.read<ProjectsBloc>().add(ProjectsFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectsFailureState) {
            showSnackBar(context: context, content: state.message,);
          }
        },
        builder: (context, state) {
          if (state is ProjectsLoadingState) {
            return Loading();
          }

          if (state is ProjectsSuccessState) {
            final projects = state.projectList;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "All Projects",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Manage your deployments across the DeployStack infrastructure.",
                    style: TextStyle(color: AppColors.white54),
                  ),
                  const SizedBox(height: 30),

                  Row(
                    children: const [
                      Expanded(
                        flex: 3,
                        child: Text(
                          "PROJECT & IDENTITY",
                          style: TextStyle(color: AppColors.white38, fontSize: 12),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "ACCESS PORT",
                          style: TextStyle(color: AppColors.white38, fontSize: 12),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "SYSTEM INITIALIZATION",
                          style: TextStyle(color: AppColors.white38, fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.separated(
                      itemCount: projects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final project = projects[index];

                        return ProjectCard(project: project,);
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}
