import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:text_to_img/BloC/pik_bloc.dart';
import 'package:text_to_img/Repository/Mode_Class/PikModel.dart';
import 'package:http/http.dart' as http;
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

late PikModel data;
TextEditingController controller = TextEditingController();

class _HomeState extends State<Home> {

  Future<void> _downloadAndSaveImage(String url) async {

    String imageUrl = url;

    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Get the app's documents directory to save the image
        final appDir = await getApplicationDocumentsDirectory();
        final file = File("${appDir.path}/image.jpg");

        // Write the image data to the file
        await file.writeAsBytes(response.bodyBytes);

        // Save the image to the gallery
        await ImageGallerySaver.saveFile(file.path);

        // Optional: Display a message or perform additional actions after downloading and saving
        print("Image downloaded and saved successfully to the gallery!");
      } else {
        print("Failed to download image. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error downloading and saving image: $error");
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
              child: Center(
                child: BlocBuilder<PikBloc, PikState>(
                  builder: (context, state) {
                    if (state is PikBlocLoading) {
                      print("loading");
                      return Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue[100],
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is PikBlocError) {
                      return Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red[50],
                        ),
                        child: Center(
                          child: Text(
                            'something else !!',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }
                    if (state is PikBlocLoaded) {
                      data = BlocProvider.of<PikBloc>(context).pikModel;
                      return Column(
                        children: [
                          Container(
                            height: 350,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue[100],
                            ),
                            child: Image.network(
                              data.imageUrl!,
                              fit: BoxFit.fill,
                            ),
                          ), Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: GestureDetector(

                                onTap: ()async{
                                  _downloadAndSaveImage(data.imageUrl!);
                                },


                                child: Container(
                                  height: 50,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green[400],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.download,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        '  Download',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue[100],
                        ),
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.blue[200],
                          size: 200,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Container(
                  height: 70,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    color: Colors.blue[50],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 60,
                        width: 300,
                        child: TextFormField(
                          controller: controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'type your imagination',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: GestureDetector(
                  onTap: () {
                    print(controller.text);
                    BlocProvider.of<PikBloc>(context)
                        .add(FetchPik(name: controller.text));
                  },
                  child: Container(
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wallpaper_rounded,
                          color: Colors.white,
                        ),
                        Text(
                          '  Create Image',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100,),

          ],
        ),
      ),
    );
  }
}
