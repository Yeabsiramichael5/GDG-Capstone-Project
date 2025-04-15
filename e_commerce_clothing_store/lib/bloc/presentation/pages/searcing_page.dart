import 'package:e_commerce_clothing_store/bloc/data/model/card_model.dart';
import 'package:e_commerce_clothing_store/bloc/logic/server.dart';
import 'package:e_commerce_clothing_store/bloc/presentation/components/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SearcingPage extends StatefulWidget {
  const SearcingPage({Key? key}) : super(key: key);

  @override
  _SearcingPageState createState() => _SearcingPageState();
}

class _SearcingPageState extends State<SearcingPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _resultText = ' ';
  List<CardModel>? cardList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            style: TextStyle(
              color: Colors.black, // Ensure visibility of typed words
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(1000),
              ),
              filled: true,
              fillColor: Color(0XFFf8f7f7),
              hintText: "Search Here",
              hintStyle: TextStyle(
                  color: Color(0XFF9b9999), fontWeight: FontWeight.w400),
              prefixIcon: Icon(Icons.search,
                  color: const Color(0xFF9E9E9E)), // Visible prefix icon
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: Colors.black,
                      ),
                      iconSize: 20.0,
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _resultText = ' ';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (text) {
              setState(() {
                _resultText = text.isNotEmpty ? text : ' ';
              }); // Refreshes the UI when text changes
            },
            onSubmitted: (searchTag) {
              setState(() {
                if (searchTag.isNotEmpty) {
                  Server.fetchData(searchTag).then((onValue){cardList = onValue;});
                } else {
                  cardList = null;
                }
              });
            },
          ),
        ),
      ),
      body: GestureDetector(
        // it' just to unfocus the keyboard from the textfield
        onTap: () => _focusNode.unfocus(),
        onHorizontalDragStart: (details) => _focusNode.unfocus(),
        onVerticalDragStart: (details) => _focusNode.unfocus(),
        //
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Result for ',
                          style: TextStyle(
                            color: Color(0xFF817f7f),
                          ),
                        ),
                        TextSpan(
                          text: '"$_resultText"',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '6 Result Found',
                    style: TextStyle(
                      color: Color(0xFF6055D8),
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              //! This is were the list of searched
              child: cardList != null
                  ? CardList(cardList: cardList!)
                  : Center(
                      child: Text(
                        'No Item Found',
                        style: TextStyle(
                          color:
                              Colors.black, // Ensure visibility of typed words
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
