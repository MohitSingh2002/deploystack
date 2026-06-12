part of 'custom_domain_bloc.dart';

@immutable
sealed class CustomDomainEvent {}

final class CustomDomainSaveEvent extends CustomDomainEvent {
  final String projectId;
  final String domain;
  final String subdomain;

  CustomDomainSaveEvent({
    required this.projectId,
    required this.domain,
    required this.subdomain,
  });
}
