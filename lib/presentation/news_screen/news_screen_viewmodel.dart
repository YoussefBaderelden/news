import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_c13/core/api_state.dart';
import 'package:news_app_c13/data/models/source_dm.dart';
import 'package:news_app_c13/data/repositories/news_repository/news_repository.dart';

class NewsScreenViewModel extends Cubit<NewsViewModelState> {
  NewsRepository newsRepository = NewsRepository();

  NewsScreenViewModel() : super(NewsViewModelState.initial());

  Future<void> getSources(categoryId) async {
    try {
      emit(NewsViewModelState(LoadingState()));
      List<SourceDM> sources = await newsRepository.getSources(categoryId);
      emit(NewsViewModelState(SuccessState(sources)));
    } catch (e) {
      emit(NewsViewModelState(ErrorState(e.toString())));
    }
  }
}

class NewsViewModelState {
  late ApiState sourceApi;

  NewsViewModelState(this.sourceApi);

  NewsViewModelState.initial() {
    sourceApi = LoadingState();
  }
}
