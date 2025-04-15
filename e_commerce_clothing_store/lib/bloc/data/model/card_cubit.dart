import 'package:flutter_bloc/flutter_bloc.dart';


class CardCubit extends Cubit<CardState> {
  CardCubit({required this.productId, required bool initialLiked})
      : super(CardState(isLiked: initialLiked));

  final String productId;

  void toggleLike() {
    emit(state.copyWith(isLiked: !state.isLiked));
    //TODO: We'll handle updating the main list in the parent widget
  }
  
}

class CardState {
  const CardState({required this.isLiked});

  final bool isLiked;

  CardState copyWith({bool? isLiked}) {
    return CardState(
      isLiked: isLiked ?? this.isLiked,
    );
  }
}