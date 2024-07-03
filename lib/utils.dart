import 'package:intl/intl.dart';

class Utils{

  static String timeConverter(int time){
    var dt = DateTime.fromMillisecondsSinceEpoch(time);
    var date = DateFormat('MMM dd, yyy | hh:mm').format(dt);
    return date;
  }

}