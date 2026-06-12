import 'package:bloc/bloc.dart';
import 'package:deploystack/features/custom_domain/domain/usecases/connect_domain_with_project.dart';
import 'package:meta/meta.dart';

part 'custom_domain_event.dart';
part 'custom_domain_state.dart';

class CustomDomainBloc extends Bloc<CustomDomainEvent, CustomDomainState> {

  ConnectDomainWithProject _connectDomainWithProject;

  CustomDomainBloc({required ConnectDomainWithProject connectDomainWithProject})
    : _connectDomainWithProject = connectDomainWithProject,
    super(CustomDomainInitial()) {
      on<CustomDomainEvent>((event, emit) {});
      on<CustomDomainSaveEvent>(_onCustomDomainSaveEvent);
  }

  void _onCustomDomainSaveEvent(CustomDomainSaveEvent event, Emitter emit) async {
    emit(CustomDomainLoadingState(projectId: event.projectId));

    var res = await _connectDomainWithProject.call(ConnectDomainWithProjectParam(projectId: event.projectId, domain: event.domain, subdomain: event.subdomain));

    res.fold(
        (failure) {
          emit(CustomDomainFailureState(projectId: event.projectId, message: failure.message,));
        },
        (success) {
          emit(CustomDomainSuccessState(projectId: event.projectId, domain: event.domain, subdomain: event.subdomain));
        }
    );
  }
}
