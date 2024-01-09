part of 'pik_bloc.dart';

@immutable
abstract class PikEvent {}
class FetchPik extends PikEvent{
  final String name;
  FetchPik({required this .name});
}
