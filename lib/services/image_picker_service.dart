import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/image_model.dart';
import '../utilities/constants.dart';
import '../utilities/ui_constants.dart';

class ImagePickerService {
  Future<ImageModel> pickImage({
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: imageSource,
        imageQuality: 90,
      );
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        File? compressedFile = await _compressImage(file);
        if (compressedFile != null) {
          int bytes = await compressedFile.length();
          if (bytes <= kMaxFileBytes) {
            return ImageModel(
              file: compressedFile,
              error: null,
            );
          } else {
            return ImageModel(
              file: null,
              error: 'File not found',
            );
          }
        } else {
          return ImageModel(
            file: null,
            error: 'File not found',
          );
        }
      } else {
        return ImageModel(
          file: null,
          error: 'File not found',
        );
      }
    } catch (error) {
      return ImageModel(
        file: null,
        error: 'Cancelled by user',
      );
    }
  }

  Future<List<ImageModel>> pickMultipleImage(
    List<ImageModel> existingFiles,
  ) async {
    List<ImageModel> finalFiles = [];

    /// Adding Existing Files
    if (existingFiles.isNotEmpty) {
      finalFiles.addAll(existingFiles);
    }

    /// Picking images & compressing
    if (finalFiles.length < kMaxFileCount) {
      List<ImageModel> newFiles = [];

      try {
        List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
          imageQuality: 90,
        );

        if (pickedFiles != null && pickedFiles.isNotEmpty) {
          for (var pickedFile in pickedFiles) {
            newFiles.add(
              ImageModel(
                file: File(
                  pickedFile.path,
                ),
              ),
            );
          }
        }

        if (newFiles.isNotEmpty) {
          for (var newFile in newFiles) {
            File? compressedFile = await _compressImage(
              newFile.file!,
            );
            if (compressedFile != null) {
              var decodedImage = await decodeImageFromList(
                compressedFile.readAsBytesSync(),
              );
              if (decodedImage.width >= kMinWidth &&
                  decodedImage.height >= kMinHeight) {
                int bytes = await compressedFile.length();
                if (bytes <= kMaxFileBytes) {
                  finalFiles.add(
                    ImageModel(
                      file: compressedFile,
                    ),
                  );
                }
              }
            }
          }
        }

        return finalFiles;
      } catch (error) {
        return [];
      }
    } else {
      return [];
    }
  }

  Future<ImageModel> cropProfileImage({
    required String imagePath,
  }) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Bigwig',
            toolbarColor: kWhiteColor,
            toolbarWidgetColor: kBlackColor,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      if (croppedFile != null) {
        File file = File(croppedFile.path);
        int bytes = await file.length();
        if (bytes <= kMaxFileBytes) {
          File? compressedFile = await _compressImage(file);
          return ImageModel(
            file: compressedFile,
            error: null,
          );
        } else {
          return ImageModel(
            file: null,
            error: 'File not found',
          );
        }
      } else {
        return ImageModel(
          file: null,
          error: 'File not found',
        );
      }
    } catch (error) {
      return ImageModel(
        file: null,
        error: 'Cancelled by user',
      );
    }
  }

  Future<File?> _compressImage(File file) async {
    try {
      final directory = await getTemporaryDirectory();
      final String targetPath =
          "${directory.absolute.path}/IMG_${DateTime.now().millisecondsSinceEpoch}.jpg";

      File? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        minWidth: kMinWidth,
        minHeight: kMinHeight,
        quality: 80,
      );
      if (result != null) {
        return result;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
