import 'dart:io';

import '../repository/image_picker_repository.dart';
import 'package:flutter/material.dart';

class ImagePickerProvider extends ChangeNotifier {
  final ImagePickerRepository _imagePickerRepository = ImagePickerRepository();

  File? _pickedImage;
  File? get pickedImage => _pickedImage;

  String? _pickedError;
  String? get pickedError => _pickedError;

  void pickImage() async {
    _pickedError = null;
    notifyListeners();
    dynamic data = await _imagePickerRepository.pickImage();
    if (data is String) {
      _pickedError = data;
      notifyListeners();
    } else {
      _pickedImage = data;
      notifyListeners();
    }
  }

  void cropImage(String imagePath) async {
    _pickedError = null;
    notifyListeners();
    dynamic data = await _imagePickerRepository.cropImage(
      imagePath: imagePath,
    );
    if (data is String) {
      _pickedError = data;
      notifyListeners();
    } else {
      _pickedImage = data;
      notifyListeners();
    }
  }

  void pickProfileImage() async {
    _pickedError = null;
    notifyListeners();
    dynamic data = await _imagePickerRepository.pickImage();
    if (data is String) {
      _pickedError = data;
      notifyListeners();
    } else {
      dynamic cropData = await _imagePickerRepository.cropImage(
        imagePath: data.path,
      );
      if (cropData is String) {
        _pickedError = data;
        notifyListeners();
      } else {
        _pickedImage = cropData;
        notifyListeners();
      }
    }
  }

  void onDispose() {
    _pickedError = null;
    _pickedImage = null;
    notifyListeners();
  }
}
