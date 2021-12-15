import 'package:Shinewash/screens/custom_drawer/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
class CustomDrawerCubit extends Cubit<CustomDrawerState>{
  CustomDrawerCubit( ) : super(CustomDrawerInitialState());

  static CustomDrawerCubit get(context)=>BlocProvider.of(context);



}