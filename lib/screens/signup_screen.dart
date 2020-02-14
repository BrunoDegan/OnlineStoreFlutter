import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:onlinestore/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void onSuccess() {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Usuário criado com sucesso"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void onFailed() {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao criar usuário"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
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
                key: _formKey,
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
                      decoration: InputDecoration(hintText: "E-mail"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text.isEmpty || !text.contains("@"))
                          return "Email inválido";
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
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
                            if (_formKey.currentState.validate()) {
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
