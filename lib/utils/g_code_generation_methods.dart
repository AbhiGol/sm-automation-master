import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import 'constant.dart';
import 'prefrence_service.dart';

/*Future<bool> saveGCode() async {
  try {
    if (kIsWeb) {
      // List<String> text = await generateGCode();

      // final content = base64Encode(text.join('\r\n').codeUnits);
      // final anchor = html.AnchorElement(
      //     href:
      //         "data:application/octet-stream;charset=utf-16le;base64,$content")
      //   ..setAttribute("download", "temp.txt")
      //   ..click();
    } else {
      PreferenceService service = PreferenceService();
      String? initialPath = await service.getString(downloadPath);
      String? name = await service.getString(fileName);
      initialPath = initialPath.isNotEmpty ? initialPath : null;
      name = name.isNotEmpty ? name : "GCodeValue.txt";
      List<String> text = await generateGCode();
      Uint8List bytes = Uint8List.fromList(text.join('\r\n').codeUnits);
      String folderPath = await folderPicker(
          name, initialPath, Platform.isWindows ? null : bytes);
      if (Platform.isWindows) {
        if (folderPath.isNotEmpty) {
          if (initialPath == null || initialPath.isEmpty || name.isEmpty) {
            await service.saveString(fileName, basename(folderPath));
            await service.saveString(
                downloadPath, folderPath.replaceAll(basename(folderPath), ""));
          }
          String ext = extension(folderPath);
          if (ext.isEmpty || !ext.contains("txt")) {
            ext = ".txt";
          }
          var filePath = "${withoutExtension(folderPath)}$ext";
          (await File(filePath).create())
              .writeAsBytes(text.join('\r\n').codeUnits);
          return true;
        }
      } else {
        return true;
      }
    }

    return false;
  } catch (e) {
    return false;
  }
}*/

Future<bool> saveGCode(bool ispath) async {
  try {
    if (kIsWeb) {
      // Web-specific code to save the file, if needed.
    } else {
      PreferenceService service = PreferenceService();
      String? initialPath = await service.getString(downloadPath);
      String? name = await service.getString(fileName);
      
      // Default values if the path or name are not set
      initialPath = initialPath.isNotEmpty ? initialPath : null;
      name = name.isNotEmpty ? name : "GCodeValue.txt";
      
      // Generate GCode content
      List<String> text = await generateGCode();
      Uint8List bytes = Uint8List.fromList(text.join('\r\n').codeUnits);

      if (initialPath != null && ispath == true) {
        // If path and name are available, use them directly to save the file
        String filePath = join(initialPath, name);

        if (Platform.isWindows) {
          var file = File(filePath);
          await file.create(recursive: true);
          await file.writeAsBytes(bytes);
        } else {
          var file = File(filePath);
          await file.create(recursive: true);
          await file.writeAsBytes(bytes);
        }

        return true;
      } else {
        // Fallback to folder picker if initialPath is not set
        String folderPath = await folderPicker(name, initialPath, Platform.isWindows ? null : bytes);
        print(folderPath);
        await service.saveString(fileName, basename(folderPath));
        await service.saveString(downloadPath, folderPath.replaceAll(basename(folderPath), ""));
        if (Platform.isWindows && folderPath.isNotEmpty) {
          if (initialPath == null || initialPath.isEmpty || name.isEmpty) {
            await service.saveString(fileName, basename(folderPath));
            await service.saveString(downloadPath, folderPath.replaceAll(basename(folderPath), ""));
          }
          String ext = extension(folderPath);
          if (ext.isEmpty || !ext.contains("txt")) {
            ext = ".txt";
          }
          var filePath = "${withoutExtension(folderPath)}$ext";
          (await File(filePath).create()).writeAsBytes(text.join('\r\n').codeUnits);
          return true;
        } else {
          return true;
        }
      }
    }
    return false;
  } catch (e) {
    return false;
  }
}


Future<String> folderPicker(
    String? name, String? initialPath, Uint8List? bytes) async {
  String? folderPath = await FilePicker.platform.saveFile(
      dialogTitle: "Select folder",
      lockParentWindow: Platform.isWindows ? true : false,
      initialDirectory: initialPath,
      fileName: name,
      bytes: bytes,
      allowedExtensions: ['txt']);
  return folderPath ?? "";
}

Future<List<String>> generateGCode() async {
  var graphSettings = await PreferenceService().fetchCurrentGraphSettings();
  List<Map<String, dynamic>> cooradinates = [];
  int rowCount = 1;
  double xDistanceFromOrigin = -(graphSettings.canvasWidth / 2);
  double yDistanceFromOrigin = -(graphSettings.canvasHeight / 2);
  double spaceHorizonatal =
      (graphSettings.canvasWidth) / (graphSettings.verticalLines - 1);
  double yspaceorigin =
      (graphSettings.canvasHeight) / graphSettings.horizontalLines;
  double spaceVertically =
      (graphSettings.canvasHeight) / graphSettings.horizontalLines;
  if (graphSettings.verticalLines == 1) {
    xDistanceFromOrigin = 0;
  }
  for (var i = 1; i <= graphSettings.verticalLines; i++) {
    if (rowCount <= graphSettings.dotLinesCount) {
      for (var j = 0; j < graphSettings.dotNumberCount; j++) {
        if (graphSettings.zigZagBool) {
          if (graphSettings.snackBool) {
            if (rowCount % 2 == 0) {
              cooradinates.add(
                  {"x": "$xDistanceFromOrigin", "y": "$yDistanceFromOrigin"});
              yDistanceFromOrigin += yspaceorigin;
            } else {
              cooradinates.add(
                  {"x": "$xDistanceFromOrigin", "y": "$yDistanceFromOrigin"});
              yDistanceFromOrigin += yspaceorigin;
            }
          } else {
            if (rowCount % 2 == 0) {
              cooradinates.add(
                  {"x": "$xDistanceFromOrigin", "y": "$yDistanceFromOrigin"});
              yDistanceFromOrigin += spaceVertically;
            } else {
              cooradinates.add(
                  {"x": "$xDistanceFromOrigin", "y": "$yDistanceFromOrigin"});
              yDistanceFromOrigin += spaceVertically;
            }
          }
        } else {
          if (graphSettings.snackBool) {
            if (rowCount % 2 == 0) {
              cooradinates.add(
                  {"x": "$xDistanceFromOrigin", "y": "$yDistanceFromOrigin"});
              yDistanceFromOrigin -= spaceVertically;
            } else {
              cooradinates.add(
                  {"x": "$xDistanceFromOrigin", "y": "$yDistanceFromOrigin"});
              yDistanceFromOrigin += spaceVertically;
            }
          } else {
            cooradinates.add(
                {"x": "$xDistanceFromOrigin", "y": "$yDistanceFromOrigin"});
            yDistanceFromOrigin += spaceVertically;
          }
        }
      }
      if (graphSettings.zigZagBool) {
        if (yDistanceFromOrigin > 0) {
          yDistanceFromOrigin -=
              ((graphSettings.canvasHeight / graphSettings.horizontalLines) /
                  2);
          yspaceorigin = -(yspaceorigin);
        } else {
          yDistanceFromOrigin +=
              ((graphSettings.canvasHeight / graphSettings.horizontalLines) /
                  2);
          yspaceorigin = yspaceorigin.abs();
        }
      }
      rowCount++;
    }
    // if (verticalLines % 2 == 0) {
    //   if ((i + 1) % 2 == 0) {
    //     xDistanceFromOrigin += (spaceHorizonatal / 2);
    //   } else {
    //     xDistanceFromOrigin += (spaceHorizonatal * 2);
    //   }
    // } else {
    xDistanceFromOrigin += spaceHorizonatal;
    // }
  }

  return await enterIntoListMethod(
      cooradinates,
      graphSettings.zref,
      graphSettings.zdepth,
      graphSettings.zlift,
      graphSettings.zspeed,
      graphSettings.fValue,
      graphSettings.dotLinesCount);
}

Future<void> addJobCodeAtStartEnd(
    int index, List<String> tempList, int contentLength, int linesOfDot) async {
  String content = "";
  if (index != (contentLength - 1)) {
    // for odd line complete
    content = await PreferenceService().getString(oddLine);
    if (content.isNotEmpty &&
        index % linesOfDot == (linesOfDot - 1) &&
        index % 2 == 0) {
      tempList.add(content);
    }
    content = await PreferenceService().getString(evenLine);
    if (content.isNotEmpty &&
        index % linesOfDot == (linesOfDot - 1) &&
        index % 2 == 1) {
      tempList.add(content);
    }
  }
}

Future<void> addShapeAtStartEnd(String key, List<String> tempList) async {
  var content = await PreferenceService().getString(key);
  if (content.isNotEmpty) {
    tempList.add(content);
  }
}

Future<List<String>> enterIntoListMethod(
    List<Map<String, dynamic>> xyList,
    double zref,
    double zdepth,
    double zlift,
    double zspeed,
    String fValue,
    int linesOfDot) async {
  List<String> tempList = [];

  await addShapeAtStartEnd(startJob, tempList);

  for (int i = 0; i < xyList.length; i++) {
    // tempList.add(
    //     "G01 Z${((zref + zdepth) - (zdepth + zlift)).toDouble().toStringAsFixed(3)} F$zspeed");
    await addShapeAtStartEnd(startShape, tempList);
    tempList.add(
        "G01 X${double.parse(xyList[i]["x"]!).toStringAsFixed(3)} Y${double.parse(xyList[i]["y"]!).toStringAsFixed(3)} F$fValue");
    tempList.add("G01 Z-${(zref + zdepth).toStringAsFixed(3)} F$zspeed");
    tempList.add("G01 Z-${(zref - zlift).toStringAsFixed(3)} F$zspeed");
    // tempList.add(
    //     "G01 Z${((zref + zdepth) - (zdepth + zlift)).toDouble().toStringAsFixed(3)} F$zspeed");
    await addShapeAtStartEnd(endShape, tempList);
    await addJobCodeAtStartEnd(i, tempList, xyList.length, linesOfDot);
  }
  await addShapeAtStartEnd(endJob, tempList);
  return tempList;
}
