import 'package:flutter/cupertino.dart';

class UpdateUploadedImage extends ChangeNotifier {
  String _imageUrl = '';
  String get getImageUrl => _imageUrl;
  updateImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }
}
