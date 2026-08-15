import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTextStyle {
  AppTextStyle._();

  /// 頁面標題
  static const TextStyle pageTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  /// 欄位標題
  static const TextStyle label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  /// 單字
  static const TextStyle word = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColor.text,
  );

  /// 中文意思
  static const TextStyle meaning = TextStyle(
    fontSize: 16,
    color: AppColor.text,
  );

  /// 次要資訊
  static const TextStyle info = TextStyle(
    fontSize: 14,
    color: AppColor.secondaryText,
  );

  /// 按鈕
  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}