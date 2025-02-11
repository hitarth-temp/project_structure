import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../localization/app_strings.dart';
import '../../themes/app_colors.dart';
import '../../themes/text_styles.dart';
import '../../utils/app_logger.dart';
import '../../utils/app_methods.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/loading_dialog.dart';

enum ImageType { gallery, camera }

class ImagePickSheet extends StatelessWidget {
  final Function(ImageType imageType)? onSelectOption;

  const ImagePickSheet({super.key, this.onSelectOption});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              AppStrings.selectUploadOption.tr,
              style: TextStyles.displayXsMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  highlightColor: AppColors.transparent,
                  splashColor: AppColors.transparent,
                  onTap: () {
                    onSelectOption!(ImageType.camera);
                  },
                  child: _imageTypeContainer(
                    context,
                    title: AppStrings.takeAPhoto.tr,
                    icon: Icons.camera_alt_rounded,
                  ),
                ),
                // const Divider(
                //   thickness: 0.5,
                // ),
                const SizedBox(width: 24),
                InkWell(
                  highlightColor: AppColors.transparent,
                  splashColor: AppColors.transparent,
                  onTap: () {
                    onSelectOption!(ImageType.gallery);
                  },
                  child: _imageTypeContainer(
                    context,
                    title: AppStrings.chooseFromGallery.tr,
                    icon: Icons.photo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageTypeContainer(
    BuildContext context, {
    required String title,
    required IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: AppColors.white,
        ),
        height: 105,
        width: 105,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Icon(
            icon,
            size: 32,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  static Future<void> showImagePickBottomSheet({
    required BuildContext context,
    bool isDismissible = true,
    Function(XFile selectedImg)? onSelectImage,
  }) async {
    showModalBottomSheet(
      backgroundColor: AppColors.transparent,
      context: context,
      useSafeArea: true,
      isDismissible: isDismissible,
      builder: (context) {
        return ImagePickSheet(
          onSelectOption: (imageType) async {
            Get.back(closeOverlays: true);

            bool isEnable = await AppMethods.askPermission(
              permission: await _getPermission(imageType),
              whichPermission: imageType.name.tr,
            );

            if (isEnable) {
              Get.context!.showLoading();
              final XFile? imageFile = await ImagePicker().pickImage(
                source: imageType == ImageType.gallery
                    ? ImageSource.gallery
                    : ImageSource.camera,
                imageQuality: 65,
              );
              Get.context!.hideLoading();
              if (imageFile != null) {
                if (imageFile.path.toLowerCase().endsWith("jpg") ||
                    imageFile.path.toLowerCase().endsWith("png") ||
                    imageFile.path.toLowerCase().endsWith("jpeg") ||
                    imageFile.path.toLowerCase().endsWith("heic")) {
                  bool isValidImage = await AppMethods.imageSize(imageFile);

                  if (isValidImage) {
                    onSelectImage!(imageFile);
                  } else {
                    DialogUtils.showSnackBar(
                      AppStrings.maximumImageSizeError.tr,
                      snackbarType: SnackbarType.failure,
                    );
                  }
                } else {
                  DialogUtils.showSnackBar(
                    AppStrings.uploadImageError.tr,
                    snackbarType: SnackbarType.failure,
                  );
                }

                logger.i("IMAGE PICKED: ${imageFile.path}");
              }
            }
          },
        );
      },
    );
  }

  /// gallery permission
  static Future<Permission?> _getPermission(ImageType imageType) async {
    switch (imageType) {
      case ImageType.gallery:
        if (Platform.isAndroid && await AppMethods.getAndroidVersion() < 33) {
          return Permission.storage;
        } else {
          return Permission.photos;
        }
      case ImageType.camera:
        return Permission.camera;
    }
  }
}
