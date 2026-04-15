import 'dart:convert';

import 'package:deploystack/features/project_deployment_logs/domain/entities/project_deployment_log.dart';

class ProjectDeploymentLogModel extends ProjectDeploymentLog {
  ProjectDeploymentLogModel({required super.log, required super.createdAt});

  factory ProjectDeploymentLogModel.fromJson(Map<String, dynamic> map) {
    return ProjectDeploymentLogModel(
      log: utf8.decode(base64Decode(map['log'] ?? '')),
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}
