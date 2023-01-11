import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/login_bloc.dart';
import 'package:gerente_loja/screens/home_screen.dart';
import 'package:gerente_loja/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => SizedBox(
                    height: 32,
                    child: AlertDialog(
                      title: Text(
                        "Erro",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      content:
                          Text("Você não possui os privilégios necessários!"),
                      backgroundColor: Color(0xffBD081C),
                      titleTextStyle: TextStyle(color: Colors.white),
                      contentTextStyle: TextStyle(color: Colors.white),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: StreamBuilder<LoginState>(
            stream: _loginBloc.outState,
            initialData: LoginState.LOADING,
            builder: (context, snapshot) {
              switch (snapshot.data) {
                case LoginState.LOADING:
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor)));
                case LoginState.FAIL:
                case LoginState.IDLE:
                case LoginState.SUCCESS:
                  return Stack(alignment: Alignment.center, children: [
                    Container(),
                    SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(
                              Icons.store,
                              color: Theme.of(context).primaryColor,
                              size: 115,
                            ),
                            InputField(
                              stream: _loginBloc.outEmail,
                              icon: Icons.person_outline,
                              obscure: false,
                              hint: 'Usuário',
                              onChanged: _loginBloc.changeEmail,
                            ),
                            const SizedBox(height: 8),
                            InputField(
                              stream: _loginBloc.outPassword,
                              icon: Icons.lock_outlined,
                              obscure: true,
                              hint: 'Senha',
                              onChanged: _loginBloc.changePassword,
                            ),
                            const SizedBox(height: 12),
                            StreamBuilder<bool>(
                                stream: _loginBloc.outSubmitValid,
                                builder: (context, snapshot) {
                                  return SizedBox(
                                    height: 35,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          disabledBackgroundColor:
                                              Colors.pinkAccent.withAlpha(150),
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                      onPressed: snapshot.hasData
                                          ? _loginBloc.submit
                                          : null,
                                      child: const Text("Entrar"),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  ]);
              }

              return Stack(alignment: Alignment.center, children: [
                Container(),
                SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.store,
                          color: Theme.of(context).primaryColor,
                          size: 115,
                        ),
                        InputField(
                          stream: _loginBloc.outEmail,
                          icon: Icons.person_outline,
                          obscure: false,
                          hint: 'Usuário',
                          onChanged: _loginBloc.changeEmail,
                        ),
                        const SizedBox(height: 8),
                        InputField(
                          stream: _loginBloc.outPassword,
                          icon: Icons.lock_outlined,
                          obscure: true,
                          hint: 'Senha',
                          onChanged: _loginBloc.changePassword,
                        ),
                        const SizedBox(height: 12),
                        StreamBuilder<bool>(
                            stream: _loginBloc.outSubmitValid,
                            builder: (context, snapshot) {
                              return SizedBox(
                                height: 35,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      disabledBackgroundColor:
                                          Colors.pinkAccent.withAlpha(150),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                  onPressed: snapshot.hasData
                                      ? _loginBloc.submit
                                      : null,
                                  child: const Text("Entrar"),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ),
              ]);
            }));
  }
}
