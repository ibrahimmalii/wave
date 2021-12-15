abstract class CustomDrawerState {}

class CustomDrawerInitialState extends CustomDrawerState {}

class CustomDrawerLoadingState extends CustomDrawerState {}

class CustomDrawerSuccessState extends CustomDrawerState {}

class CustomDrawerErrorState extends CustomDrawerState {
  final String? error;

  CustomDrawerErrorState(this.error);
}
