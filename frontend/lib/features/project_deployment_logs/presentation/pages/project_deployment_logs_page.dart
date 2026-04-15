import 'package:deploystack/core/common/widgets/loading.dart';
import 'package:deploystack/core/utils/show_snackbar.dart';
import 'package:deploystack/features/project_deployment_logs/presentation/widgets/project_deployment_log_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/project_deployment_logs_bloc/project_deployment_logs_bloc.dart';

class ProjectDeploymentLogsPage extends StatefulWidget {
  String projectId;

  ProjectDeploymentLogsPage({super.key, required this.projectId,});

  @override
  State<ProjectDeploymentLogsPage> createState() => _ProjectDeploymentLogsPageState();
}

class _ProjectDeploymentLogsPageState extends State<ProjectDeploymentLogsPage> {

  @override
  void initState() {
    super.initState();

    context.read<ProjectDeploymentLogsBloc>().add(ProjectDeploymentLogsFetchEvent(projectId: widget.projectId,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProjectDeploymentLogsBloc, ProjectDeploymentLogsState>(
          listener: (context, state) {
            if (state is ProjectDeploymentLogsFailureState) {
              showSnackBar(context: context, content: state.message,);
            }
          },
          builder: (context, state) {
            if (state is ProjectDeploymentLogsLoadingState) {
              return Center(
                child: Loading(),
              );
            }

            if (state is ProjectDeploymentNoLogsSuccessState) {
              return Center(
                child: Text(
                  'No Logs Found.',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            if (state is ProjectDeploymentLogsSuccessState) {
              return ListView.separated(
                padding: EdgeInsets.all(20.0,),
                itemCount: state.projectDeploymentLogList.length,
                itemBuilder: (_, index) {
                  final log = state.projectDeploymentLogList.elementAt(index);

                  return ProjectDeploymentLogCard(log: log,);
                },
                separatorBuilder: (_, _) {
                  return SizedBox();
                },
              );
            }

            return SizedBox();
          },
        ),
      ),
    );
  }
}
