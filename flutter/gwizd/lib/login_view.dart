import 'package:flutter/material.dart';
import 'package:gwizd/models/auth_model.dart';
import 'package:gwizd/utility/http_client.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<bool> handleLogin() async {
      // Create a LoginModel using the input data
      final loginModel = LoginModel(
        email: emailController.text,
        password: passwordController.text,
      );

      try {
        final response = await apiClient.postLogin(loginModel);
        print(response.statusCode);
        print(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          // Successful login, navigate to the home screen
          return true;
        } else {
          // Handle login failure, show an error message, or throw an exception
          return false;
        }
      } catch (e) {
        print(e.toString());
        // Handle any exceptions or errors during the API request
        // Show an error message or log the error
      }
      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true, // To hide the password
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  handleLogin().then(
                    (value) => value
                        ? Navigator.pushNamed(context, '/home')
                        : ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Login failed. Please check your credentials.'),
                            ),
                          ),
                  );
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/register'); // Navigate to the register view
                },
                child: const Text('Don\'t have an account? Register here.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
