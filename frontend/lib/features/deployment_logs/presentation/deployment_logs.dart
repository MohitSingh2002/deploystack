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
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     if (!_scrollController.hasClients) return;
          //
          //     final maxScroll = _scrollController.position.maxScrollExtent;
          //     final currentScroll = _scrollController.offset;
          //
          //     const threshold = 100.0;
          //
          //     final isNearBottom = (maxScroll - currentScroll) <= threshold;
          //
          //     if (isNearBottom) {
          //       _scrollController.jumpTo(maxScroll);
          //     }
          //   });
          // });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_scrollController.hasClients) return;

            final maxScroll = _scrollController.position.maxScrollExtent;
            final currentScroll = _scrollController.offset;

            const threshold = 100.0;

            final isNearBottom = (maxScroll - currentScroll) <= threshold;

            if (isNearBottom) {
              _scrollController.animateTo(
                maxScroll,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            }
          });

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.data.length,
            itemBuilder: (_, index) {
              final log = state.data[index] ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      children: _buildStyledLog(log,),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return SizedBox();
      },
    );
  }

  List<TextSpan> _buildStyledLog(String log) {
    // Git progress
    if (log.contains('Receiving objects')) {
      return [
        const TextSpan(
          text: '⬇ ',
          style: TextStyle(color: Colors.blue),
        ),
        TextSpan(
          text: log,
          style: const TextStyle(color: Colors.blueAccent),
        ),
      ];
    }

    // Compressing
    if (log.contains('Compressing objects')) {
      return [
        const TextSpan(
          text: '🗜 ',
          style: TextStyle(color: Colors.orange),
        ),
        TextSpan(
          text: log,
          style: const TextStyle(color: Colors.orangeAccent),
        ),
      ];
    }

    // Resolving
    if (log.contains('Resolving deltas')) {
      return [
        const TextSpan(
          text: '⚙ ',
          style: TextStyle(color: Colors.green),
        ),
        TextSpan(
          text: log,
          style: const TextStyle(color: Colors.greenAccent),
        ),
      ];
    }

    // Clone start
    if (log.contains('Cloning into')) {
      return [
        const TextSpan(
          text: '🚀 ',
          style: TextStyle(color: Colors.purple),
        ),
        TextSpan(
          text: log,
          style: const TextStyle(color: Colors.purpleAccent),
        ),
      ];
    }

    // Errors
    if (log.toLowerCase().contains('error') ||
        log.toLowerCase().contains('fatal')) {
      return [
        const TextSpan(
          text: '❌ ',
          style: TextStyle(color: Colors.red),
        ),
        TextSpan(
          text: log,
          style: const TextStyle(color: Colors.redAccent),
        ),
      ];
    }

    // Default
    return [
      TextSpan(
        text: log,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ];
  }

}
