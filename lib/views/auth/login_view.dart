import 'package:blogapp/constants/routes.dart';
import 'package:blogapp/services/auth/auth_exceptions.dart';
import 'package:blogapp/services/auth/auth_service.dart';
import 'package:blogapp/utilities/auth/show_error_dialog.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: 'Enter email here',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.teal,
                              width: 12,
                            ))),
                  ),
                  const Padding(padding: EdgeInsets.all(8)),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: 'Enter password here',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.teal,
                              width: 12,
                            ))),
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            await AuthService.firebase()
                                .login(email: email, password: password);
                            final user = AuthService.firebase().currentUser;

                            if (user?.isEmailVerified ?? false) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                dashboardRoute,
                                (route) => false,
                              );
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                verifyEmailRoute,
                                (route) => false,
                              );
                            }
                          } on InvalidLoginCredentialsAuthException {
                            await showErrorDialog(
                              context,
                              'User not found',
                            );
                          } on GenericAuthException {
                            await showErrorDialog(
                              context,
                              'Authentication error',
                            );
                          }
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(200, 50)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ))),
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New user, click here to'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute,
                              (route) => false,
                            );
                          },
                          child: const Text('register'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
