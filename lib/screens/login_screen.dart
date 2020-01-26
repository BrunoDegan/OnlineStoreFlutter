import 'package:flutter/material.dart';
import 'package:onlinestore/models/user_model.dart';
import 'package:onlinestore/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignupScreen()));
              },
            ),
          ],
        ),
        body:
        ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(hintText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@"))
                        return "Email inválido";
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Senha",
                    ),
                    obscureText: true,
                    controller: passwordController,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha inválida";
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text(
                          "Entrar",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme
                            .of(context)
                            .primaryColor,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            model.signIn(
                                email: emailController.text,
                                password: passwordController.text,
                                onSuccess: onSuccess,
                                onFailed: onFailed);
                          }
                        },
                      ))
                ],
              ),
            );
          }
        }));
  }

  void onSuccess() {
    Navigator.of(context).pop();
  }

  void onFailed() {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Falha ao entrar "),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
    ));
  }
}
