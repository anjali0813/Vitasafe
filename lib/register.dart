import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Register Screen'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(0, 173, 173, 234),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
                      TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ),
                      SizedBox(height: 12,),
                      TextFormField(
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ),
            SizedBox(height: 12,),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'DOB',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20,),
                      TextFormField(
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ),
                      SizedBox(height: 12,),
        
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ),
                      SizedBox(height: 12,),
        
                      TextFormField(
              decoration: InputDecoration(
                labelText: 'Contact_No.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){}, child: Text('REGISTER'))
          ]
          ),
      )
    );
  }
}