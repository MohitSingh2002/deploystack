import 'package:deploystack/core/theme/app_colors.dart';
import 'package:deploystack/core/utils/show_snackbar.dart';
import 'package:deploystack/features/custom_domain/presentation/widgets/custom_domain_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bloc/custom_domain_bloc/custom_domain_bloc.dart';

class CustomDomainButton extends StatefulWidget {

  final String projectId;
  final String domain, subdomain;

  const CustomDomainButton({
    super.key,
    required this.projectId,
    required this.domain,
    required this.subdomain,
  });

  @override
  State<CustomDomainButton> createState() => _CustomDomainButtonState();
}

class _CustomDomainButtonState extends State<CustomDomainButton> {

  bool _hasConnectedDomain = false;

  bool get _hasDomain => _hasConnectedDomain || widget.domain.isNotEmpty;

  Future<void> _onPressed() async {
    if (_hasDomain) {
      showSnackBar(
        context: context,
        content: 'Domain already configured for this project',
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) =>
          CustomDomainDialog(
            onSave: (domain, subdomain) {
              context.read<CustomDomainBloc>().add(CustomDomainSaveEvent(projectId: widget.projectId, domain: domain, subdomain: subdomain,));
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomDomainBloc, CustomDomainState>(
      listenWhen: (previous, current) {
        if (current is CustomDomainSuccessState) return current.projectId == widget.projectId;
        if (current is CustomDomainFailureState) return current.projectId == widget.projectId;
        return false;
      },
      listener: (context, state) {
        if (state is CustomDomainSuccessState) {
          setState(() => _hasConnectedDomain = true);
          showSnackBar(context: context, content: 'Domain Connected!');
        } else if (state is CustomDomainFailureState) {
          showSnackBar(context: context, content: state.message);
        }
      },
      buildWhen: (previous, current) =>
          current is CustomDomainInitial ||
          (current is CustomDomainSuccessState && current.projectId == widget.projectId) ||
          (current is CustomDomainFailureState && current.projectId == widget.projectId) ||
          (current is CustomDomainLoadingState && current.projectId == widget.projectId),
      builder: (context, state) {
        if (state is CustomDomainLoadingState && state.projectId == widget.projectId) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.white,
            ),
          );
        }

        return IconButton(
          onPressed: _onPressed,
          icon: FaIcon(
            FontAwesomeIcons.globe,
            size: 20.0,
            color: AppColors.white,
          ),
        );
      },
    );
  }
}
