import 'package:Shinewash/models/user_model.dart';

abstract class LoginState{}

class LoginInitialState extends LoginState{}
class LoginLoadingState extends LoginState{}
class LoginSuccessState extends LoginState{

  final UserModel user;

  LoginSuccessState(this.user);

}
class LoginErrorState extends LoginState{
  final String error;
  LoginErrorState(this.error);
}
class LoginShowSpinner extends LoginState{}
class LoginStopSpinner extends LoginState{}
