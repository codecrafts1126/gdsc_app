import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DSCSITP/cubit/news/news_cubit.dart';
import 'package:DSCSITP/utils/network_vars.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().refreshNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {
        if (state is NewsErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red[300], content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is NewsProcessingState) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const NewsPageView();
        }
      },
    );
  }
}

class NewsPageView extends StatefulWidget {
  const NewsPageView({super.key});

  @override
  State<NewsPageView> createState() => _NewsPageViewState();
}

class _NewsPageViewState extends State<NewsPageView> {
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
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsCubit>().refreshNewsData();
      },
      child: Container(
        color: Colors.grey[50],
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: news['articles'].length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: singleNewsPage(index));
          },
        ),
      ),
    );
  }

  Widget singleNewsPage(int index) {
    String newsAuthor = news['articles'][index]['author'].toString();
    String newsContent = news['articles'][index]['content'].toString();
    String newsDescription = news['articles'][index]['description'].toString();
    String newsDate = news['articles'][index]['publishedAt'].toString();
    String newsSource = news['articles'][index]['source']['name'].toString();
    String newsTitle = news['articles'][index]['title'].toString();
    String newsUrl = news['articles'][index]['url'].toString();
    String newsImageUrl = (news['articles'][index]['urlToImage'].toString());
    return Container(
      height: 100,
      width: 100,
      color: Colors.transparent,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                newsTitle,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w400, height: 1),
              ),
            ),
            const SizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 210,
                      child: Text(
                        newsAuthor == "null" ? newsSource : newsAuthor,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await openUrl(newsUrl);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              shadowColor: Colors.black,
                              backgroundColor: Colors.black,
                              elevation: 3),
                          child: const Text("Visit"),
                        ),
                        // Text(
                        //   "Visit",
                        //   style: TextStyle(
                        //       fontSize: 15,
                        //       color: Colors.redAccent,
                        //       fontWeight: FontWeight.w800),
                        // ),
                        // Icon(
                        //   Icons.link,
                        //   color: Colors.redAccent,
                        // )
                      ],
                    ),
                  ]),
            ),
            const SizedBox(height: 9),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Scrollbar(
                  child: ListView(
                    // physics: BouncingScrollPhysics(),
                    children: [
                      if (newsImageUrl != "null")
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image(
                            image: NetworkImage(newsImageUrl),
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      const Icon(Icons.error,
                                          color: Colors.red),
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
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
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
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      (newsDescription == "" ||
                              newsDescription == "null" ||
                              newsDescription == null)
                          ? const SizedBox()
                          : Column(
                              children: [
                                const Divider(),
                                Text(
                                  newsDescription,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18),
                                )
                              ],
                            ),
                      (newsContent == "" ||
                              newsContent == "null" ||
                              newsContent == null)
                          ? const SizedBox()
                          : Column(
                              children: [
                                const Divider(),
                                Text(newsContent,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18))
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
