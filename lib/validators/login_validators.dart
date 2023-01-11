import 'dart:async';

class LoginValidators {

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      if (email.contains("@") && email.contains(".com")){
        sink.add(email);
      } else {
        sink.addError("Insira um e-mail válido!");
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink){
      if(password.length > 4){
        sink.add(password);
      } else {
        sink.addError("Senha inválida! Sua senha deve ter\npelo menos 4 caracteres");
      }
    } 
  );
  
}