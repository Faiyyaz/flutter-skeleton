import 'package:image_picker/image_picker.dart';

import '../models/image_model.dart';
import '../services/image_picker_service.dart';
import '../services/service_locator.dart' as service_locator;

class ImagePickerRepository {
  final ImagePickerService _imagePickerService =
      service_locator.locator<ImagePickerService>();

  Future<dynamic> pickImage({
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    ImageModel imageModel = await _imagePickerService.pickImage(
      imageSource: imageSource,
    );

    if (imageModel.error != null) {
      return imageModel.error;
    } else {
      return imageModel.file;
    }
  }

  Future<dynamic> cropImage({
    required String imagePath,
  }) async {
    ImageModel imageModel = await _imagePickerService.cropProfileImage(
      imagePath: imagePath,
    );

    if (imageModel.error != null) {
      return imageModel.error;
    } else {
      return imageModel.file;
    }
  }
}
