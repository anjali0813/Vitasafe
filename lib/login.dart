import 'package:flutter/material.dart';
import 'package:vitasafe/login_api.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 175, 156, 148),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: username,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: (){
                loginuser(username: username.text, password: password.text,context: context);
              }, child: Text('LOGIN')),
              TextButton(onPressed: (){}, child: Text('Don\'t have an account ! REGISTER'))
            ],
          ),
        ),
      ),
    );
  }
}
