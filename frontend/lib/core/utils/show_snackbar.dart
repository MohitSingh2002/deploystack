import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String content, bool longDuration = false,}) {
  ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(content), duration: Duration(milliseconds: longDuration ? 8000 : 4000,),),
      );
}
