import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_medicine/core/app_data.dart';

class UIUtils {
  static void showLoading(BuildContext context, {bool isDismissible = true}) {
    showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (context) => PopScope(
        canPop: isDismissible,
        child: CupertinoAlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Center(child: CircularProgressIndicator(color:AppColors.blue))],
          ),
        ),
      ),
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static showMessage(BuildContext context ,String message){
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(content: Text(message,style:TextStyle(color:Colors.black ) ,)),
    );
  }

   static void showToastMessage(String message,Color backgroundColor){
       Fluttertoast.showToast(msg: message,
       gravity: ToastGravity.BOTTOM,
         backgroundColor:backgroundColor ,
         textColor:AppColors.white,
         fontSize: 16.0,
       );
   }







}
