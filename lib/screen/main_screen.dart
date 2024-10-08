import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gal_test/model/hit_model.dart';

import '../model/image_response.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.scKey});

  final GlobalKey<ScaffoldState> scKey;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final apiKey = "14177614-2a2496e706870465ad067ed35";
  List<Hits> hits = [];
  int offset = 1;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_handleControllerNotification);
    super.initState();
  }

  void _handleControllerNotification() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hits.isEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () => getData());
    }
    final size = MediaQuery.of(context).size.width;
    return hits.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : CustomScrollView(
            controller: _controller,
            slivers: [
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (size / 300).toInt(),
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return GridTile(
                    footer: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0.75),
                                Colors.grey,
                                Colors.grey.withOpacity(0.75),
                                Colors.black.withOpacity(0.75),
                              ],
                              stops: const [
                                0.05,
                                0.25,
                                0.9,
                                1.0
                              ]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                Text('likes: ${hits[index].likes}'),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.blue,
                                ),
                                Text(' views: ${hits[index].views}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: Image.network(
                      fit: BoxFit.cover,
                      hits[index].largeImageURL!,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                }, childCount: hits.length),
              ),
            ],
          );
  }

  Future<void> getData() async {
    Dio dio = Dio();
    final url = "https://pixabay.com/api/?key=$apiKey&per_page=50&page=$offset";
    try {
      final key = widget.scKey;
      final controller =
          key.currentState!.showBottomSheet((context) => const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  Text('Loading...'),
                ],
              ));

      final response = await dio.get(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 30),
          ));
      controller.close();
      if (response.statusCode == 200) {
        final data = response.data;
        ImageResponse imageResponse = ImageResponse.fromJson(data);
        hits.addAll(imageResponse.hits);
        setState(() {
          offset++;
        });
      }
      if (response.statusCode! >= 400 && response.statusCode! < 500) {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      final key = widget.scKey;
      key.currentState?.showBottomSheet((context) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  Text('Error', style: TextStyle(color: Colors.red)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    e.toString(),
                  ),
                ],
              ),
            );
          });
    }
  }
}
