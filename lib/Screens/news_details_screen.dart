import 'package:DSCSITP/cubit/news/news_cubit.dart';
import 'package:DSCSITP/utils/network_vars.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class NewsDetailsScreen extends StatefulWidget {
  final String category;
  final String author;
  final String description;
  final String time;
  final String title;
  final String url;
  final String imageUrl;
  const NewsDetailsScreen(
      {super.key,
      required this.category,
      required this.author,
      required this.description,
      required this.time,
      required this.title,
      required this.url,
      required this.imageUrl});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  Future<void> openUrl(String url) async {
    try {
      launchUrl(Uri.parse(url));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[300],
          content: const Text("could not open news url")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
          ),
          elevation: 3,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shadowColor: Colors.black,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 15, bottom: 0, left: 9, right: 3),
              child: Container(
                  color: Colors.grey[50],
                  child: newsItem(
                      widget.category,
                      widget.author,
                      widget.description,
                      widget.time,
                      widget.title,
                      widget.url,
                      widget.imageUrl)),
            ),
          ],
        ),
      ),
    );
  }

  Widget newsItem(String category, String author, String description,
      String time, String title, String url, String imageUrl) {
    return Container(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 12, left: 6, right: 6),
        child: Column(
          children: [
            if (imageUrl != "None")
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  Material(
                    elevation: 3,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.circular(18),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  const Icon(Icons.error, color: Colors.red),
                                  const SizedBox(height: 9),
                                  Text(
                                    error.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  )
                                ]),
                              ),
                            ),
                          );
                        },
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          return child;
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (category != "None")
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[500],
                            borderRadius: BorderRadius.circular(18)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            toBeginningOfSentenceCase(category)!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  if (imageUrl != "None")
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ElevatedButton(
                        onPressed: () async {
                          await openUrl(url);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            shadowColor: Colors.black,
                            backgroundColor: Colors.black54,
                            elevation: 3),
                        child: const Text("Visit"),
                      ),
                    )
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 8, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl == "None")
                    ElevatedButton(
                      onPressed: () async {
                        await openUrl(url);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          shadowColor: Colors.black,
                          backgroundColor: Colors.black,
                          elevation: 3),
                      child: const Text("Visit"),
                    ),
                  Expanded(child: Container()),
                ],
              ),
            ),
            const SizedBox(height: 9),
            if (title != "None")
              Padding(
                padding:
                    const EdgeInsets.only(right: 8, left: 8, bottom: 0, top: 0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 21),
                    )
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (author != "None")
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          author,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                Expanded(child: Container()),
                if (time != "None")
                  Padding(
                    padding: const EdgeInsets.only(top: 9, right: 8),
                    child: Text(
                      time,
                      // DateFormat.yMMMMd()
                      //     .format(DateTime.parse(time).toLocal()),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
              ],
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                child: Text(
                  description,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300, height: 1.2),
                ))
          ],
        ),
      ),
    );
  }
}
