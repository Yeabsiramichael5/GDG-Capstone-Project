import 'package:e_commerce_clothing_store/bloc/data/model/card_cubit.dart';
import 'package:e_commerce_clothing_store/bloc/data/model/card_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class MyCard extends StatefulWidget {
//   final String? _productName, _imgUrl, _urlToDescription, _productId;
//   bool _liked;
//   final double? _productPrice;

//   MyCard(
//       {super.key,
//       String? productName,
//       String? productId,
//       String? imgUrl,
//       String? urlToDescription,
//       required bool liked,
//       double? productPrice})
//       : _imgUrl = imgUrl,
//         _liked = liked,
//         _productId = productId,
//         _productName = productName,
//         _urlToDescription = urlToDescription,
//         _productPrice = productPrice;

//   String? get imgUrl_ => _imgUrl;
//   String? get productName_ => _productName;
//   String? get urlToDescription_ => _urlToDescription;
//   String? get productId_ => _productId;
//   double? get productPrice_ => _productPrice;
//   bool get isLiked_ => _liked;

//   @override
//   State<MyCard> createState() => _MyCardState();
// }

class CardWidget extends StatelessWidget {
  const CardWidget(
      {super.key, required this.cardModel, required this.onLikeChanged});
  final CardModel cardModel;
  final Function(String productId, bool isLiked) onLikeChanged;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardCubit(
        productId: cardModel.productId_,
        initialLiked: cardModel.isLiked_,
      ),
      child: Container(
        width: 155,
        height: 178,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0XFFF8F7F7),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 155,
              height: 134,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                        cardModel.imgUrl_,
                        fit: BoxFit
                            .cover, // Ensures the image fills the container
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                                color:
                                    const Color.fromARGB(255, 179, 174, 159)),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text('Error Loading Image'),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: BlocBuilder<CardCubit, CardState>(
                      buildWhen: (previous, current) =>
                          previous.isLiked != current.isLiked,
                      builder: (context, state) {
                        return IconButton(
                          style: IconButton.styleFrom(
                            padding: EdgeInsets
                                .zero, // Remove default button padding
                            minimumSize: Size(25, 25), // o minimum button size
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap, // Sh
                          ),
                          onPressed: () {
                            //todo: implement the liked button here
                            context.read<CardCubit>().toggleLike();

                            onLikeChanged(cardModel.productId_, !state.isLiked);
                          },
                          icon: Icon(
                            CupertinoIcons.heart_fill,
                            size: 24,
                            color: cardModel.isLiked_ ? Colors.red : null,
                          ),
                          padding: EdgeInsets.zero,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        cardModel.productName_,
                      ),
                      Text(
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xFF6055D8),
                          ),
                          '\$${cardModel.productPrice_}')
                    ],
                  ),
                  IconButton(
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(25, 25),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Sh
                      ),
                      onPressed: () {
                        //TODO: implement the cart adding here
                      },
                      icon: Icon(
                        CupertinoIcons.add_circled_solid,
                        color: Color(0XFF6055D8),
                        size: 20,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
