part of 'custom_domain_bloc.dart';

@immutable
sealed class CustomDomainState {}

final class CustomDomainInitial extends CustomDomainState {}

final class CustomDomainLoadingState extends CustomDomainState {
  final String projectId;

  CustomDomainLoadingState({
    required this.projectId,
  });
}

final class CustomDomainSuccessState extends CustomDomainState {
  final String projectId;
  final String domain;
  final String subdomain;

  CustomDomainSuccessState({
    required this.projectId,
    required this.domain,
    required this.subdomain,
  });
}

final class CustomDomainFailureState extends CustomDomainState {
  final String projectId;
  final String message;

  CustomDomainFailureState({
    required this.projectId,
    required this.message,
  });
}
