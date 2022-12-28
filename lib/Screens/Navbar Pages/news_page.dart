import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/cubit/news/news_cubit.dart';
import 'package:gdsc_app/utils/network_vars.dart';

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
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsCubit>().refreshNewsData();
      },
      child: Container(
        color: Colors.grey[50],
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: news['articles'].length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
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
    String newsImageUrl = news['articles'][index]['urlToImage'].toString();
    return Container(
      height: 100,
      width: 100,
      color: Colors.transparent,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          newsTitle,
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 9),
        Container(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              newsAuthor == "null" ? newsSource : newsAuthor,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  Text(
                    "Visit",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w800),
                  ),
                  Icon(
                    Icons.link,
                    color: Colors.redAccent,
                  )
                ],
              ),
            )
          ]),
        ),
        SizedBox(height: 9),
        ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(image: NetworkImage(newsImageUrl))),
      ]),
    );
  }
}
