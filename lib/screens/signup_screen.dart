import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onlinestore/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();

  void onSuccess() {}

  void onFailed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: "Nome completo"),
                      validator: (text) {
                        if (text.isEmpty) return "Nome inválido";
                      },
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text.isEmpty || !text.contains("@"))
                          return "Email inválido";
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Senha",
                      ),
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty || text.length < 6)
                          return "Senha inválida";
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: "Endereço",
                      ),
                      validator: (text) {
                        if (text.isEmpty) return "Endereço inválido";
                      },
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                        height: 44.0,
                        child: RaisedButton(
                          child: Text(
                            "Criar conta",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              Map<String, dynamic> userData = {
                                "name": nameController.text,
                                "email": emailController.text,
                                "address": addressController.text,
                              };

                              model.signUp(
                                  userData: userData,
                                  pass: passwordController.text,
                                  onSuccess: onSuccess,
                                  onFailed: onFailed);
                            }
                          },
                        ))
                  ],
                ),
              );
            }
          },
        ));
  }
}
