import 'package:deploystack/core/theme/app_colors.dart';
import 'package:deploystack/core/utils/show_snackbar.dart';
import 'package:deploystack/core/widgets/app_button.dart';
import 'package:deploystack/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context: context, content: state.message,);
          }

          if (state is AuthSuccess) {
            print('Auth Success');
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Loading();
          }

          return Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.cardPrimaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Set up your platform",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Choose your root username to initialize the system",
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "SYSTEM_ID // ROOT_USERNAME",
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.4),
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: "e.g. admin_prime",
                      hintStyle: TextStyle(
                        color: AppColors.white.withOpacity(0.3),
                      ),
                      prefixText: "@  ",
                      prefixStyle: const TextStyle(color: AppColors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.white24),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.borderColor),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  AppButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthSignUp(name: _nameController.text.trim(),));
                    },
                    buttonText: 'Continue to Dashboard',
                    showIcon: true,
                    icon: Icons.arrow_forward,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
