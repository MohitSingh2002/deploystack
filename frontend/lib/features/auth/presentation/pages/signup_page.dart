import 'package:deploystack/core/utils/show_snackbar.dart';
import 'package:deploystack/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context: context, content: state.message);
            }
            if (state is AuthSuccess) {
              print('success');
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Loading();
            }

            return Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('here');
                    context.read<AuthBloc>().add(AuthSignUp(name: _nameController.text.trim(),));
                  },
                  child: Text(
                    'Continue -->',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
