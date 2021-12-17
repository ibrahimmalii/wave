abstract class AppState{}



class AppInitialState extends AppState{}

class AppLoadingState extends AppState{}

class AppSuccessState extends AppState{}

class AppErrorState extends AppState{
  final String? error;

  AppErrorState(this.error);
}

class AllServiceInitialState extends AppState{}

class AllServiceLoadingState extends AppState{}

class AllServiceSuccessState extends AppState{}

class AllServiceErrorState extends AppState{
  final String? error;

  AllServiceErrorState(this.error);
}

class ServiceInitialState extends AppState{}

class ServiceLoadingState extends AppState{}

class ServiceSuccessState extends AppState{}

class ServiceErrorState extends AppState{
  final String? error;

  ServiceErrorState(this.error);
}


