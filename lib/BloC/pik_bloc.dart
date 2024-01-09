import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:text_to_img/Repository/Api/Pik_Api.dart';

import '../Repository/Mode_Class/PikModel.dart';

part 'pik_event.dart';

part 'pik_state.dart';

class PikBloc extends Bloc<PikEvent, PikState> {
  PikApi pikApi = PikApi();
  late PikModel pikModel;

  PikBloc() : super(PikInitial()) {
    on<FetchPik>((event, emit) async {
      emit(PikBlocLoading());
      try{
        pikModel = await pikApi.getPik(name: event.name);
        emit(PikBlocLoaded());
      }catch(e){
        print(e);
        emit(PikBlocError());
      }
    });
  }
}
