import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  static SharedPreferences? _sharedPref;
  init() async {
    if(_sharedPref==null){
      _sharedPref = await SharedPreferences.getInstance();
    }
  }
  String ? get baseIp =>_sharedPref!.getString("baseIp")?? "";
  List<String>? get ipList => _sharedPref!.getStringList("ipList")??[];
  //setters 
  setipList(List<String> list){
    _sharedPref!.setStringList("ipList", list);

  }
  setbaseip({required String baseip}){
    _sharedPref!.setString("baseIp", baseip);

  }
 
}
final sharedPrefs = SharedPref();