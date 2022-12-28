import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_app/cubit/news/news_cubit.dart';

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
    return const Placeholder();
  }
}
