import 'package:flutter/material.dart';

import '../../domain/entities/project_deployment_log.dart';

class ProjectDeploymentLogCard extends StatefulWidget {
  final ProjectDeploymentLog log;

  const ProjectDeploymentLogCard({super.key, required this.log});

  @override
  State<ProjectDeploymentLogCard> createState() => _ProjectDeploymentLogCardState();
}

class _ProjectDeploymentLogCardState extends State<ProjectDeploymentLogCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final lines = widget.log.log
        .split('\n')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final previewLines = lines.length >= 2
        ? lines.sublist(lines.length - 2)
        : lines;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Header (clickable)
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Timestamp
                  Text(
                    _formatDate(widget.log.createdAt),
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Preview (2 lines stacked)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: previewLines.map((line) {
                        return Text(
                          line,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  /// Expand / Collapse Icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Expandable Body
          AnimatedCrossFade(
            firstChild: const SizedBox(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: SelectableText(
                widget.log.log,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.4,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${_two(date.month)}-${_two(date.day)} "
        "${_two(date.hour)}:${_two(date.minute)}:${_two(date.second)}";
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}
