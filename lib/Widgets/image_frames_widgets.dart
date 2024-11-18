import 'package:flutter/material.dart';

class ImageFramesWidgets {
  userProfileFrame(
      profileImage, double width, double radius, bool isNetworkImage) {
    return isNetworkImage == true
        ? Container(
            width: width,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.cyan.shade700, // Light aqua border
                width: 3.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileImage != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(profileImage),
                        radius: radius,
                      )
                    : CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/default_profile_image.png'),
                        radius: radius,
                      ),
              ],
            ),
          )
        : Container(
            height: 150.0,
            width: 150.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.cyan.shade700, // Light aqua border for file image
                width: 3.0,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: FileImage(profileImage),
              radius: 40,
            ),
          );
  }
}
