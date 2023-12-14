import 'package:flutter/material.dart';
// Nombres: Javiera Cabezas y Nicole Alarcon

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final username = TextEditingController();
  final password = TextEditingController();


  bool isVisible = false;
  bool isLoginTrue = false;

  final formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const ListTile (
                      title: Text('Login',
                          style: TextStyle(fontSize: 35)),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        controller: username,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "username is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          border: InputBorder.none,
                          hintText: "Email",
                        ),
                      ),
                    ),

                    //Password field
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "password is required";
                          }
                          return null;
                        },
                        obscureText: !isVisible,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          border: InputBorder.none,
                          hintText: "Contraseña",
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              //Navigate to sign up
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()));
                            },
                            child: const Text("¿Olvidaste tu contraseña?"))
                      ],
                    ),
                    ListTile(
                      horizontalTitleGap: 2,
                      title: const Text('Recuerda tus datos'),
                      leading: Checkbox(
                        value: isChecked,
                        onChanged: (value){
                          setState(() {
                            isChecked = !isChecked;
                          });
                          },
                      ),
                    ),



                    const SizedBox(height: 10),
                    //Login button
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width * .3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.deepPurple),
                      child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomePage()));
                              }
                            },

                          child: const Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),



                    isLoginTrue
                        ? const Text(
                      "Email o contraseña incorrecta",
                      style: TextStyle(color: Colors.red),
                    )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget{
  const HomePage({super.key});


  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}