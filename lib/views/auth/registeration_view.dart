import 'package:blogapp/constants/routes.dart';
import 'package:blogapp/services/auth/auth_exceptions.dart';
import 'package:blogapp/services/auth/auth_service.dart';
import 'package:blogapp/utilities/auth/show_error_dialog.dart';
import 'package:flutter/material.dart';

class Registerview extends StatefulWidget {
  const Registerview({super.key});

  @override
  State<Registerview> createState() => _RegisterviewState();
}

class _RegisterviewState extends State<Registerview> {
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
        title: const Text('Register'),
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
                        )),
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
                        )),
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  )),
                  ElevatedButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        await AuthService.firebase()
                            .createUser(email: email, password: password);

                        await AuthService.firebase().sendEmailVerification();
                        Navigator.of(context).pushNamed(verifyEmailRoute);
                      } on WeakPasswordAuthException {
                        await showErrorDialog(
                          context,
                          'Weak Password!',
                        );
                      } on EmailAlreadyInUseAuthException {
                        await showErrorDialog(
                          context,
                          'Email is already in Use',
                        );
                      } on InvalidEmailAuthException {
                        await showErrorDialog(
                          context,
                          'This is an Invalid email',
                        );
                      }
                      // on GenericAuthException {
                      //   await showErrorDialog(
                      //     context,
                      //     'Failed to register',
                      //   );
                      // }
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    },
                    child:
                        const Text('Already registered, click here to login'),
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
