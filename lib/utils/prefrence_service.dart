import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/graph_canvas_model.dart';
import 'constant.dart';

class PreferenceService {
  static final PreferenceService _singleton = PreferenceService._internal();

  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  factory PreferenceService() {
    return _singleton;
  }

  PreferenceService._internal();

  Future<String> getString(String key) async {
    return (await _preferences).getString(key) ?? "";
  }

  Future<void> saveString(String key, String value) async {
    (await _preferences).setString(key, value);
  }

  Future<GraphCanvasModel> fetchDefaultGraphSettings() async {
    var graphCanvasString = await PreferenceService().getString(gCodeCanvas);
    if (graphCanvasString.isEmpty) {
      await PreferenceService().saveString(gCodeCanvas, defaultGraphSettings);
      return GraphCanvasModel.fromJson(jsonDecode(defaultGraphSettings));
    }
    return GraphCanvasModel.fromJson(jsonDecode(graphCanvasString));
  }

  Future<GraphCanvasModel> fetchCurrentGraphSettings() async {
    var graphCanvasString =
        await PreferenceService().getString(currentGCodeCanvas);
    if (graphCanvasString.isEmpty) {
      await PreferenceService()
          .saveString(currentGCodeCanvas, defaultGraphSettings);
      return GraphCanvasModel.fromJson(jsonDecode(defaultGraphSettings));
    }
    return GraphCanvasModel.fromJson(jsonDecode(graphCanvasString));
  }
}
