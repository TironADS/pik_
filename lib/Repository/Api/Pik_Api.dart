import 'dart:convert';

import 'package:http/http.dart';
import 'package:text_to_img/Repository/Api/api_client.dart';

import '../Mode_Class/PikModel.dart';

class PikApi{
  ApiClient apiClient=ApiClient();

  Future<PikModel>getPik({required String name})async{
    String path='https://animimagine-ai.p.rapidapi.com/generateImage';
    var body={
      "selected_model_id":"anything-v5",
      "selected_model_bsize":"512",
      "prompt":name
    };
print(body);
    Response response = await apiClient.invokeAPI(path, 'POST_', jsonEncode(body));
    return PikModel.fromJson(jsonDecode(response.body));
  }
}