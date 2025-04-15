import 'package:e_commerce_clothing_store/bloc/data/model/card_list_state.dart';
import 'package:e_commerce_clothing_store/bloc/data/model/card_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

////! I THINK I DON'T NEED THE BLOC IMPLEMENTATION AT ALL SO MAYBE DELETE IT.


// class CardBloc extends Cubit<ListCardState> {
//   CardBloc(super.initialState);
  
// }

// cubit/card_list_cubit.dart


class CardListCubit extends Cubit<CardListState> {
  // The Cubit HOLDS ONTO an instance of CardRepository
  final CardRepository _cardRepository; // Use final for dependencies

  // It REQUIRES a CardRepository when created
  CardListCubit({required CardRepository cardRepository})
      : _cardRepository = cardRepository, // Store the provided repository
        super(CardListInitial()); // Set initial state

  // Method that uses the repository
  Future<void> fetchCards() async {
    emit(CardListLoading());
    try {
      // It calls fetchCards() on WHATEVER repository instance it was given
      final cards = await _cardRepository.fetchCards(); // <--- USES THE REPOSITORY
      emit(CardListLoaded(cards));
    } catch (e) {
      emit(CardListError(e.toString()));
    }
  }
}



abstract class CardRepository {
  // Any class implementing this MUST provide a fetchCards method
  Future<List<CardModel>> fetchCards();

  // ... other methods like addCard, deleteCard could be defined here ...
}