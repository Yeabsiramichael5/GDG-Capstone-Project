import 'package:e_commerce_clothing_store/bloc/data/model/card_model.dart';
import 'package:equatable/equatable.dart';

/*
class ListCardState {
  List<MyCard>? cardList;
  ListCardState({this.cardList});


  

  static List<MyCard> fromCardStateToMyCard(List<CardState> cardListState) {
    return cardListState
        .map((cardState) => MyCard(
              liked: cardState.isLiked_,
              productId: cardState.productId_,
              productName: cardState.productName_,
              productPrice: cardState.productPrice_,
              urlToDescription: cardState.urlToDescription_,
            ))
        .toList();
  }
}
*/

abstract class CardListState extends Equatable {
  const CardListState();
  @override
  List<Object?> get props => [];
}

class CardListInitial extends CardListState {}


class CardListLoading extends CardListState {}


class CardListLoaded extends CardListState {
  final List<CardModel> cards;

  const CardListLoaded(this.cards);

  @override
  List<Object> get props => [cards];
}

class CardListError extends CardListState {
  final String message;

  const CardListError(this.message);

  @override
  List<Object> get props => [message];
}
