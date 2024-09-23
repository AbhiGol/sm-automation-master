import 'dart:ui';

import 'package:sm_automation/utils/hex_color.dart';

class GraphCanvasModel {
  final double canvasHeight;
  final double canvasWidth;
  final int dotLinesCount;
  final int dotNumberCount;
  final int verticalLines;
  final int horizontalLines;
  final bool zigZagBool;
  final double progress;
  final Color graphLineColor;
  final Color highLightLineColor;
  final bool snackBool;
  final double zdepth;
  final double zref;
  final double zlift;
  final String fValue;
  final double zspeed;
  final double leftPadding;
  final double bottomPadding;
  final bool graphLineBool;
  final bool fillGraphBool;

  const GraphCanvasModel({
    required this.canvasHeight,
    required this.canvasWidth,
    required this.dotLinesCount,
    required this.dotNumberCount,
    required this.verticalLines,
    required this.horizontalLines,
    required this.zigZagBool,
    required this.progress,
    required this.graphLineColor,
    required this.highLightLineColor,
    required this.snackBool,
    required this.zdepth,
    required this.zref,
    required this.zlift,
    required this.fValue,
    required this.zspeed,
    required this.leftPadding,
    required this.bottomPadding,
    required this.graphLineBool,
    required this.fillGraphBool,
  });

  factory GraphCanvasModel.fromJson(Map<String, dynamic> json) =>
      GraphCanvasModel(
        canvasHeight: double.tryParse(json['canvasHeight'].toString()) ?? 0,
        canvasWidth: double.tryParse(json['canvasWidth'].toString()) ?? 0,
        dotLinesCount: json['dotLinesCount'],
        dotNumberCount: json['dotNumberCount'],
        verticalLines: json['verticalLines'],
        horizontalLines: json['horizontalLines'],
        zigZagBool: json['zigZagBool'],
        progress: double.tryParse(json['progress'].toString()) ?? 0,
        graphLineColor: HexColor.fromHex(json['graphLineColor']),
        highLightLineColor: HexColor.fromHex(json['highLightLineColor']),
        snackBool: json['snackBool'],
        zdepth: double.tryParse(json['zdepth'].toString()) ?? 0,
        zref: double.tryParse(json['zref'].toString()) ?? 0,
        zlift: double.tryParse(json['zlift'].toString()) ?? 0,
        fValue: json['fValue'],
        zspeed: double.tryParse(json['zspeed'].toString()) ?? 0,
        leftPadding: double.tryParse(json['leftPadding'].toString()) ?? 0,
        bottomPadding: double.tryParse(json['bottomPadding'].toString()) ?? 0,
        graphLineBool: json['graphLineBool'],
        fillGraphBool: json['fillGraphBool'],
      );

  Map<String, dynamic> toJson() => {
        'canvasHeight': canvasHeight,
        'canvasWidth': canvasWidth,
        'dotLinesCount': dotLinesCount,
        'dotNumberCount': dotNumberCount,
        'verticalLines': verticalLines,
        'horizontalLines': horizontalLines,
        'zigZagBool': zigZagBool,
        'progress': progress,
        'graphLineColor': graphLineColor.toHex(),
        'highLightLineColor': highLightLineColor.toHex(),
        'snackBool': snackBool,
        'zdepth': zdepth,
        'zref': zref,
        'zlift': zlift,
        'fValue': fValue,
        'zspeed': zspeed,
        'leftPadding': leftPadding,
        'bottomPadding': bottomPadding,
        'graphLineBool': graphLineBool,
        'fillGraphBool': fillGraphBool,
      };
}
