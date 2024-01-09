part of 'pik_bloc.dart';

@immutable
abstract class PikState {}

class PikInitial extends PikState {}
class PikBlocLoading extends  PikState {}
class PikBlocLoaded extends PikState{}
class PikBlocError extends PikState{}
