import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../providers/theme_provider.dart';

class LoadingPosts extends StatelessWidget {
  const LoadingPosts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Shimmer.fromColors(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(30)),
            width: 60,
            height: 60,
          ),
          baseColor: themeChange.darkTheme
              ? Colors.grey.withOpacity(0.1)
              : Colors.grey.withOpacity(0.5),
          highlightColor: themeChange.darkTheme
              ? Colors.black.withOpacity(0.1)
              : Colors.grey.withOpacity(1),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Shimmer.fromColors(
                  baseColor: themeChange.darkTheme
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.3),
                  highlightColor: themeChange.darkTheme
                      ? Colors.black.withOpacity(0.1)
                      : Colors.grey.withOpacity(1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    width: 300,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                  )),
              Shimmer.fromColors(
                  baseColor: themeChange.darkTheme
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.3),
                  highlightColor: themeChange.darkTheme
                      ? Colors.black.withOpacity(0.1)
                      : Colors.grey.withOpacity(1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    width: 300,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
