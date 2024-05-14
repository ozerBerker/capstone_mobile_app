// import 'package:flutter/material.dart';

// class Styles {
//   static ThemeData themeData(bool isDarkTheme, BuildContext context) {
//     return ThemeData(
//       scaffoldBackgroundColor:
//           isDarkTheme ? const Color(0xFF00001a) : const Color(0xFFFFFFFF),
//       primaryColor:
//           isDarkTheme ? const Color(0xFFE8FDFD) : const Color(0xFF1a1f3c),
//       colorScheme: ThemeData().colorScheme.copyWith(
//             primary: isDarkTheme ? Colors.lightBlue.shade200 : Colors.black87,
//             // secondary:
//             //     isDarkTheme ? const Color(0xFF1a1f3c) : const Color(0xFFE8FDFD),
//             brightness: isDarkTheme ? Brightness.dark : Brightness.light,
//           ),
//       cardColor:
//           isDarkTheme ? const Color(0xFF0a0d2c) : const Color(0xFFF2FDFD),
//       canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
//       buttonTheme: Theme.of(context).buttonTheme.copyWith(
//           colorScheme: isDarkTheme
//               ? const ColorScheme.dark()
//               : const ColorScheme.light()),
//       textTheme: Theme.of(context).textTheme.apply(
//             bodyColor:
//                 isDarkTheme ? const Color(0xFFE8FDFD) : const Color(0xFF1a1f3c),
//             displayColor:
//                 isDarkTheme ? const Color(0xFFE8FDFD) : const Color(0xFF1a1f3c),
//             decorationColor:
//                 isDarkTheme ? const Color(0xFFE8FDFD) : const Color(0xFF1a1f3c),
//           ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor:
          //0A1931  // white yellow 0xFFFCF8EC
          isDarkTheme ? const Color(0xFF00001a) : const Color(0xFFFFFFFF),
      primaryColor: Colors.blue,
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary:
                isDarkTheme ? const Color(0xFF1a1f3c) : const Color(0xFFE8FDFD),
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
      cardColor:
          isDarkTheme ? const Color(0xFF0a0d2c) : const Color(0xFFF2FDFD),
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
    );
  }
}
