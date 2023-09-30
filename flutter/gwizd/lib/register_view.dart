import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
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
                obscureText: true, // To hide the password
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Last name',
                ),
                obscureText: true, // To hide the password
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your registration logic here
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
