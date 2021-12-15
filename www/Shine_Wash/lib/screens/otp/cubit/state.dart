abstract class OTPState {}

class OTPInitialState extends OTPState {}

class OTPLoadingState extends OTPState {}

class OTPSuccessState extends OTPState {}

class OTPErrorState extends OTPState {
  final String? error;

  OTPErrorState(this.error);
}

class OTPShowSpinner extends OTPState{}
class OTPStopSpinner extends OTPState{}
