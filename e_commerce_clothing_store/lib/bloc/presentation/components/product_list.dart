import 'package:e_commerce_clothing_store/bloc/data/model/card_model.dart';
import 'package:e_commerce_clothing_store/bloc/presentation/components/card_widget.dart';
import 'package:flutter/material.dart';

class CardList extends StatefulWidget {
  late final List<CardModel> _productList;
  CardList({super.key, required List<CardModel> cardList})
      : _productList = cardList;

  @override
  State<CardList> createState() => _ProductListState(cardList: _productList);
}

class _ProductListState extends State<CardList> {
  late final List<CardModel> cardList;
  void _handleLikeChanged(String productId, bool isLiked) {
    setState(() {
      final index = cardList.indexWhere((item) => item.productId_ == productId);
      if (index != -1) {
        cardList[index].isLiked = !cardList[index].isLiked;
      }
    });
  }

  _ProductListState({required this.cardList});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Expanded(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            crossAxisSpacing: 16, // Spacing between columns
            childAspectRatio: 155 / 185,
            mainAxisSpacing: 16, // Spacing between rows
          ),
          itemCount: cardList.length, // Number of items in the grid
          itemBuilder: (context, index) {
            final cardModel = cardList[index];
            return Container(
              decoration: BoxDecoration(
                  // border: Border.all(
                  //   width: 1,
                  //   color: Colors.black,
                  // ),
                  ),
              //TODO: check if the container is nessesary or not by returning the widget directly
              width: 155,
              height: 178,
              child: CardWidget(
                cardModel: cardModel,
                onLikeChanged: _handleLikeChanged,
              ),
            );
          },
        ),
      ),
    );
  }
}
