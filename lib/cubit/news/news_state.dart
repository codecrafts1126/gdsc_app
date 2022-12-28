part of 'news_cubit.dart';

@immutable
abstract class NewsState {
  const NewsState();
}

class NewsInitialState extends NewsState {
  const NewsInitialState();
}

class NewsProcessingState extends NewsState {
  const NewsProcessingState();
}

class NewsErrorState extends NewsState {
  final String message;
  const NewsErrorState(this.message);
}
