import 'package:flutter/material.dart';
import 'package:snip/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController passwControl = TextEditingController();

  final client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          autovalidateMode: AutovalidateMode.onUnfocus,
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text('Log in', style: Theme.of(context).textTheme.displayLarge),
              SizedBox(
                width: 500,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                  controller: emailControl,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Maybe try to type an email';
                    }
                    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                    final regex = RegExp(pattern);

                    if (value.isEmpty || !regex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 500,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                  controller: passwControl,
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Maybe try to type a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    if (value == '123456') {
                      return 'Please be creative';
                    }
                    return null;
                  },
                ),
              ),
              FilledButton(
                onPressed: () async {
                  final bool isValid =
                      formKey.currentState?.validate() ?? false;
                  if (!isValid) {
                    return;
                  }
                  try {
                    await client.auth.signInWithPassword(
                      password: passwControl.text,
                      email: emailControl.text,
                    );
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => HomePage()));
                  } catch (e) {
                    try {
                      await client.auth.signUp(
                        password: passwControl.text,
                        email: emailControl.text,
                      );
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } catch (e) {
                      //bad ending
                      if (client.auth.currentUser != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Check your password')),
                        );

                        return;
                      }
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
