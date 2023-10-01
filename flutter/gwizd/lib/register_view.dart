import 'package:flutter/material.dart';
import 'package:gwizd/models/auth_model.dart';
import 'package:gwizd/utility/http_client.dart';

class RegisterView extends StatelessWidget {
  final apiClient = ApiClient();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<bool> handleRegister() async {
    final registerModel = RegisterModel(
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    try {
      final response = await apiClient.postRegister(registerModel);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Successful login, navigate to the home screen
        return true;
      } else {
        // Handle login failure, show an error message, or throw an exception
        return false;
      }
    } catch (e) {
      // Handle any exceptions or errors during the API request
      // Show an error message or log the error
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'First name',
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Last name',
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true, // To hide the password
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                ),
                obscureText: true, // To hide the password
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  handleRegister().then(
                    (value) => value
                        ? Navigator.pushNamed(context, '/login')
                        : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Register failed. Please check your credentials.'),
                            ),
                          ),
                  );
                },
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the login view
                },
                child: const Text('Already have an account? Login here.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
