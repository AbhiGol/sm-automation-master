import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sm_automation/models/graph_canvas_model.dart';
import 'package:sm_automation/utils/constant.dart';
import 'package:sm_automation/utils/g_code_generation_methods.dart';

import '../utils/prefrence_service.dart';

class CanvasSettings extends StatefulWidget {
  final Function(int) onSaveCallback; // Callback function
  const CanvasSettings({super.key, required this.onSaveCallback});

  @override
  State<CanvasSettings> createState() => _CanvasSettingsState();
}

class _CanvasSettingsState extends State<CanvasSettings> {
  var _canvasHeightController = TextEditingController(),
      _canvasWidthController = TextEditingController(),
      _dotNumberCountController = TextEditingController(),
      _dotLineCountController = TextEditingController(),
      _fValueController = TextEditingController(),
      _zRefController = TextEditingController(),
      _zDepthController = TextEditingController(),
      _zLiftController = TextEditingController(),
      _zSpeedController = TextEditingController();
  late bool graphFillBool = true, zigZagPattern = false, graphLineBool = false;
  final _formKey = GlobalKey<FormState>();
  String _version = '';
  final TextEditingController _filPathController = TextEditingController();

  @override
  void initState() {
    initializeForm();
    super.initState();
    pathinitialize();
    _initPackageInfo();
  }

  void pathinitialize() async{
    _filPathController.text = await PreferenceService().getString(downloadPath);
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  void initializeForm() async {
    var graphCanvasSetting =
        await PreferenceService().fetchCurrentGraphSettings();
    _canvasHeightController =
        TextEditingController(text: graphCanvasSetting.canvasHeight.toString());
    _canvasWidthController =
        TextEditingController(text: graphCanvasSetting.canvasWidth.toString());
    _dotNumberCountController = TextEditingController(
        text: graphCanvasSetting.dotNumberCount.toString());
    _dotLineCountController = TextEditingController(
        text: graphCanvasSetting.dotLinesCount.toString());
    _fValueController = TextEditingController(text: graphCanvasSetting.fValue);
    _zRefController =
        TextEditingController(text: graphCanvasSetting.zref.toString());
    _zDepthController =
        TextEditingController(text: graphCanvasSetting.zdepth.toString());
    _zLiftController =
        TextEditingController(text: graphCanvasSetting.zlift.toString());
    _zSpeedController =
        TextEditingController(text: graphCanvasSetting.zspeed.toString());
    graphFillBool = graphCanvasSetting.fillGraphBool;
    zigZagPattern = graphCanvasSetting.zigZagBool;
    graphLineBool = graphCanvasSetting.graphLineBool;
    setState(() {});
  }

  void setDefaultSettings() async {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default setting loaded successfully!')));
    var graphCanvasSetting =
        await PreferenceService().fetchDefaultGraphSettings();
    _canvasHeightController =
        TextEditingController(text: graphCanvasSetting.canvasHeight.toString());
    _canvasWidthController =
        TextEditingController(text: graphCanvasSetting.canvasWidth.toString());
    _dotNumberCountController = TextEditingController(
        text: graphCanvasSetting.dotNumberCount.toString());
    _dotLineCountController = TextEditingController(
        text: graphCanvasSetting.dotLinesCount.toString());
    _fValueController = TextEditingController(text: graphCanvasSetting.fValue);
    _zRefController =
        TextEditingController(text: graphCanvasSetting.zref.toString());
    _zDepthController =
        TextEditingController(text: graphCanvasSetting.zdepth.toString());
    _zLiftController =
        TextEditingController(text: graphCanvasSetting.zlift.toString());
    _zSpeedController =
        TextEditingController(text: graphCanvasSetting.zspeed.toString());
    graphFillBool = graphCanvasSetting.fillGraphBool;
    zigZagPattern = graphCanvasSetting.zigZagBool;
    graphLineBool = graphCanvasSetting.graphLineBool;
    setState(() {});
  }

  void saveCanvasSettings() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      GraphCanvasModel graphCanvasModel = GraphCanvasModel(
          canvasHeight: double.parse(_canvasHeightController.text),
          canvasWidth: double.parse(_canvasWidthController.text),
          dotLinesCount: int.parse(_dotLineCountController.text),
          dotNumberCount: int.parse(_dotNumberCountController.text),
          verticalLines:
              graphFillBool ? int.parse(_dotLineCountController.text) : 30,
          horizontalLines:
              graphFillBool ? int.parse(_dotNumberCountController.text) : 30,
          zigZagBool: zigZagPattern,
          progress: 1,
          graphLineColor: graphLineBool ? Colors.grey : Colors.transparent,
          highLightLineColor: Colors.transparent,
          snackBool: true,
          zdepth: double.parse(_zDepthController.text),
          zref: double.parse(_zRefController.text),
          zlift: double.parse(_zLiftController.text),
          fValue: _fValueController.text,
          zspeed: double.parse(_zSpeedController.text),
          leftPadding: ((double.parse(_canvasWidthController.text) /
                  double.parse(_dotLineCountController.text)) /
              2),
          bottomPadding: ((double.parse(_canvasHeightController.text) /
                  double.parse(_dotNumberCountController.text)) /
              2),
          graphLineBool: graphLineBool,
          fillGraphBool: graphFillBool);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully!')));
      await PreferenceService().saveString(
          currentGCodeCanvas, jsonEncode(graphCanvasModel.toJson()));
      
      saveGCode(true).then((onvalue)=>widget.onSaveCallback(0));
    }
  }

  Future<void> convertToJson() async{
    var prefs = PreferenceService();

    var configurationSettings = {
      'canvasHeight': _canvasHeightController.text,
      'canvasWidth': _canvasWidthController.text,
      'dotLinesCount': _dotLineCountController.text,
      'dotNumberCount': _dotNumberCountController.text,
      'zigZagBoolPattern': zigZagPattern,
      'showGraphLine': graphLineBool,
      'centerFillGraph': graphFillBool,
      'zdepth': _zDepthController.text,
      'zref': _zRefController.text,
      'zlift': _zLiftController.text,
      'zspeed': _zSpeedController.text,
      'fValue': _fValueController.text,
      'start job gcode': await prefs.getString('start_job'),
      'end job gcode': await prefs.getString('end_job'),
      'odd line job gcode': await prefs.getString('odd_line'),
      'even line job gcode': await prefs.getString('even_line'),
      'start shape job gcode': await prefs.getString('start_shape_job'),
      'end shape job gcode': await prefs.getString('end_shape_job'),
    };

    String json = const JsonEncoder.withIndent('  ').convert(configurationSettings);
    
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  if (selectedDirectory != null) {
    await saveJsonToFile(json, selectedDirectory);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No directory selected')),
    );
  }
  }

  Future<void> saveJsonToFile(String json, String customPath) async {
   try {
    final directory = Directory(customPath);

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final filePath = '${directory.path}/graph_setting_data.json';
    final file = File(filePath);
    await file.writeAsString(json);

    //ScaffoldMessenger.of(context).showSnackBar(
    //  SnackBar(content: Text('Data export successfully: $filePath')),
    //);
  } catch (e) {
    //ScaffoldMessenger.of(context).showSnackBar(
    //  SnackBar(content: Text('Failed to export data: $e')),
    //);
  }
}

Future<void> importJsonData() async {
  try {
    // Pick the JSON file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      File file = File(filePath);

      // Read the JSON file
      String content = await file.readAsString();
      Map<String, dynamic> configurationSettings = jsonDecode(content);
      var prefs = PreferenceService();

      // Update the controllers and variables with the imported data
      _canvasHeightController.text = configurationSettings['canvasHeight'] ?? '';
      _canvasWidthController.text = configurationSettings['canvasWidth'] ?? '';
      _dotLineCountController.text = configurationSettings['dotLinesCount'] ?? '';
      _dotNumberCountController.text = configurationSettings['dotNumberCount'] ?? '';
      zigZagPattern = configurationSettings['zigZagBoolPattern'] ?? false;
      graphLineBool = configurationSettings['showGraphLine'] ?? false;
      graphFillBool = configurationSettings['centerFillGraph'] ?? false;
      _zDepthController.text = configurationSettings['zdepth'] ?? '';
      _zRefController.text = configurationSettings['zref'] ?? '';
      _zLiftController.text = configurationSettings['zlift'] ?? '';
      _zSpeedController.text = configurationSettings['zspeed'] ?? '';
      _fValueController.text = configurationSettings['fValue'] ?? '';
      await prefs.saveString('start_job', configurationSettings['start job gcode'] ?? '');
      await prefs.saveString('end_job', configurationSettings['end job gcode'] ?? '');
      await prefs.saveString('odd_line', configurationSettings['odd line job gcode'] ?? '');
      await prefs.saveString('even_line', configurationSettings['even line job gcode'] ?? '');
      await prefs.saveString('start_shape_job', configurationSettings['start shape job gcode'] ?? '');
      await prefs.saveString('end_shape_job', configurationSettings['end shape job gcode'] ?? '');

      //ScaffoldMessenger.of(context).showSnackBar(
      //  const SnackBar(content: Text('Configuration imported successfully')),
      //);
    } else {
      //ScaffoldMessenger.of(context).showSnackBar(
      //  const SnackBar(content: Text('No file selected')),
      //);
    }
  } catch (e) {
    //ScaffoldMessenger.of(context).showSnackBar(
    //  SnackBar(content: Text('Failed to import data: $e')),
    //);
  }
}


  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyL): const SaveIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI): const ImportIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyE): const ExportIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SaveIntent: SaveAction(saveCanvasSettings),
          ImportIntent: ImportAction(importJsonData),
          ExportIntent: ExportAction(convertToJson),
        },
        //child:SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                //padding: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: Text(_version)
              ),
            ),
            Flexible(
              child: Image.asset(
                'assets/image1.jpg',
                  height: 400,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _canvasHeightController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLines: 1,
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Height can\'t be empty',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter canvas height (Y - Axis)',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _canvasWidthController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLines: 1,
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Width can\'t be empty',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter canvas width (X - Axis)',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _dotLineCountController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLines: 1,
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Number of lines can\'t be empty',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter number of lines',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, ),
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _dotNumberCountController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLines: 1,
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Number of dots can\'t be empty',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter number of dots',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, ),
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _fValueController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLines: 1,
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'F value can\'t be empty',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter f value',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _zRefController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLines: 1,
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Z Reference can\'t be empty',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter z reference',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _zSpeedController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLines: 1,
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Z Speed can\'t be empty',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter z-speed',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _zLiftController,
                    inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                    maxLines: 1,
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Z Lift can\'t be empty',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter z-lift',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _zDepthController,
                    inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                    maxLines: 1,
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Z Depth can\'t be empty',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter z-depth',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, ),
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text('Center Fill Graph : '),
                      Checkbox(
                          value: graphFillBool,
                          onChanged: (value) {
                            setState(() {
                              zigZagPattern = value!;
                            });
                          }),
                      const Text('ZigZag Pattern : '),
                      Checkbox(
                          value: zigZagPattern,
                          onChanged: (value) {
                            setState(() {
                              zigZagPattern = value!;
                            });
                          }),
                      const Text('Show Graph Line : '),
                      Checkbox(
                          value: graphLineBool,
                          onChanged: (value) {
                            setState(() {
                              graphLineBool = value!;
                            });
                          }),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.url,
                    readOnly: true,
                    autofocus: true,
                    //controller: _filPathController,
                    //inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                    maxLines: 1,
                    //validator: (value) => value != null && value.isNotEmpty
                     //   ? null
                       // : 'file path can\'t be empty',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //labelText: 'd',
                      hintText: _filPathController.text,
                      //prefixText: _filPathController.text,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold,),
                      isDense: true,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      saveCanvasSettings();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      fixedSize: const Size.fromWidth(200),
                    ),
                    child: const Text('Load'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      try {
                        setDefaultSettings();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save file: $e')));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(20),
                      fixedSize: const Size.fromWidth(200),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      importJsonData().then((onValue)=> saveCanvasSettings());
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      fixedSize: const Size.fromWidth(200),
                    ),
                    child: const Text('Import'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      convertToJson();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(20),
                      fixedSize: const Size.fromWidth(200),
                    ),
                    child: const Text('Export'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    ));//);
  }
}

class SaveIntent extends Intent {
  const SaveIntent();
}

class SaveAction extends Action<SaveIntent> {
  final void Function() onSave;

  SaveAction(this.onSave);

  @override
  void invoke(covariant SaveIntent intent) {
    onSave();
  }
}

class ImportIntent extends Intent {
  const ImportIntent();
}

class ImportAction extends Action<ImportIntent> {
  final void Function() onSave;

  ImportAction(this.onSave);
  
  @override
  void invoke(covariant ImportIntent intent) {
    onSave();
  }
}

class ExportIntent extends Intent {
  const ExportIntent();
}

class ExportAction extends Action<ExportIntent> {
  final void Function() onSave;

  ExportAction(this.onSave);
  
  @override
  void invoke(covariant ExportIntent intent) {
    onSave();
  }
}
