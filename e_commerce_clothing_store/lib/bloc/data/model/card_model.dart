class CardModel {
  late final String _imgUrl, _productName, _urlToDescription, _productId;
  late final double _productPrice;
  late final bool isLiked;

  CardModel(
      {required String imgUrl,
      required String urlToDescription,
      required String productName,
      required String productId,
      required double productPrice,
      required bool isLiked})
      : _imgUrl = imgUrl,
        _productName = productName,
        _urlToDescription = urlToDescription,
        _productPrice = productPrice,
        _productId = productId;

  String get imgUrl_ => _imgUrl;
  String get productName_ => _productName;
  String get urlToDescription_ => _urlToDescription;
  String get productId_ => _productId;
  double get productPrice_ => _productPrice;
  bool get isLiked_ => isLiked;

  Map<String, dynamic> toJson() {
    return {
      'imgUrl': _imgUrl,
      'productName': _productName,
      'urlToDescription': _urlToDescription,
      'productPrice': _productPrice,
      'isLiked': isLiked,
      'productId': _productId
    };
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
        imgUrl: json['imgUrl'],
        productName: json['productName'],
        urlToDescription: json['urlToDescription'],
        productPrice: json['productPrice'],
        isLiked: json['isLiked'],
        productId: json['productId']);
  }
}
