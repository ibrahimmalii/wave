abstract class AppState{}



class AppInitialState extends AppState{}

class AppLoadingState extends AppState{}

class AppSuccessState extends AppState{}

class AppErrorState extends AppState{
  final String? error;

  AppErrorState(this.error);
}


