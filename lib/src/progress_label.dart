/*
 * File Created: 2022-06-06 13:43:58
 * Author: ZhangYu (devzhangyu@163.com)
 * -----
 * Last Modified: 2022-06-06 15:33:08
 * Modified By: ZhangYu (devzhangyu@163.com>)
 */

import 'package:flutter/material.dart';

class ProgressLabel extends StatelessWidget {
  const ProgressLabel({
    Key? key,
    required this.progress,
    this.decoration,
  }) : super(key: key);

  final double progress;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    final value = (progress * 100).toInt();
    return Container(
      decoration: decoration,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
      child: Text(
        '$value%',
        style: const TextStyle(
          fontSize: 13,
          height: 13 / 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
