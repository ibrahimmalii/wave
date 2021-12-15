abstract class ForgetPasswordState {}

class ForgetPasswordInitialState extends ForgetPasswordState {}

class ForgetPasswordLoadingState extends ForgetPasswordState {}

class ForgetPasswordSuccessState extends ForgetPasswordState {}

class ForgetPasswordErrorState extends ForgetPasswordState {
  final String? error;

  ForgetPasswordErrorState(this.error);
}

class ForgetPasswordShowSpinner extends ForgetPasswordState{}
class ForgetPasswordStopSpinner extends ForgetPasswordState{}
