import 'package:deploystack/features/deployment_logs/presentation/bloc/deployment_logs/deployment_logs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeploymentLogs extends StatefulWidget {
  const DeploymentLogs({super.key});

  @override
  State<DeploymentLogs> createState() => _DeploymentLogsState();
}

class _DeploymentLogsState extends State<DeploymentLogs> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<DeploymentLogsBloc>().add(DeploymentLogsJoinDeploymentEvent());
    context.read<DeploymentLogsBloc>().add(DeploymentLogsConnectSocketEvent());
  }

  @override
  void dispose() {
    context.read<DeploymentLogsBloc>().add(DeploymentLogsDisconnectDeploymentEvent());
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeploymentLogsBloc, DeploymentLogsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DeploymentLogsNoDeploymentState) {
          return Center(
            child: Text(
              'Deployment Logs', style: TextStyle(color: Colors.white,),),
          );
        }

        if (state is DeploymentLogsDataState) {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   _scrollController.jumpTo(
          //     _scrollController.position.maxScrollExtent,
          //   );
          // });

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.data.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  state.data[index],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              );
            },
          );
        }

        return SizedBox();
      },
    );
  }
}
