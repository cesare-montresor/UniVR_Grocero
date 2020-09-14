import 'dart:core';
import 'package:intl/intl.dart';


class DateUtils {
  static int now(){
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  static String formatDate(int timestamp){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp*1000);
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatTime(int timestamp){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp*1000);
    return DateFormat('kk:mm').format(date);
  }


  static String formatAge(int timestamp){
    var sec =  now()-timestamp;
    var min = sec ~/ 60;
    var hour = min ~/ 60;
    var day = hour ~/ 24;
    var week = day ~/ 7;

    if (sec < 60){return '$sec sec';}
    if (min < 60){return '$min min';}
    if (hour < 24){return '$hour hour';}
    if (day < 1){return '$day day';}
    if (week < 1){return '$week week';}
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp*1000);
    return DateFormat('yyyy-MM-dd – kk:mm').format(date);
  }



}