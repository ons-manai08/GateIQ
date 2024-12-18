import 'package:flutter/widgets.dart';

class Responsive {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  // Adjust scaling based on screen width and height
  static double getScaleFactor(BuildContext context) {
    double scaleFactor = 1.0;

    // Scale factor for very small screens (like phones with width < 400px)
    if (getWidth(context) < 400) {
      scaleFactor = 0.8; // Small scale for small devices
    } else if (getWidth(context) < 600) {
      scaleFactor = 0.9; // Slightly smaller scale for medium-sized screens
    } else if (getWidth(context) < 800) {
      scaleFactor = 1.0; // Default scale for medium devices
    } else {
      scaleFactor = 1.1; // Larger scale for bigger screens
    }

    return scaleFactor;
  }

  // Helper method to get adaptive font size based on screen size and scale factor
  static double getFontSize(BuildContext context, double baseSize) {
    return baseSize * getScaleFactor(context);
  }

  // Helper method to get adaptive padding or margin size
  static double getPadding(BuildContext context, double basePadding) {
    return basePadding * getScaleFactor(context);
  }
}
