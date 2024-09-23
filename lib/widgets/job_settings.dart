import 'package:flutter/material.dart';
import 'package:sm_automation/utils/prefrence_service.dart';

import '../utils/constant.dart';

class JobSettings extends StatefulWidget {
  const JobSettings({super.key});

  @override
  State<JobSettings> createState() => _JobSettingsState();
}

class _JobSettingsState extends State<JobSettings> {
  final _startJobController = TextEditingController(),
      _endJobController = TextEditingController(),
      _oddLineController = TextEditingController(),
      _evenLineController = TextEditingController(),
      _startShapeController = TextEditingController(),
      _endShapeController = TextEditingController();

  @override
  void initState() {
    initializeForm();
    super.initState();
  }

  initializeForm() async {
    _startJobController.text = await PreferenceService().getString(startJob);
    _endJobController.text = await PreferenceService().getString(endJob);
    _oddLineController.text = await PreferenceService().getString(oddLine);
    _evenLineController.text = await PreferenceService().getString(evenLine);
    _startShapeController.text =
        await PreferenceService().getString(startShape);
    _endShapeController.text = await PreferenceService().getString(endShape);
  }

  saveJobSettings() async {
    await PreferenceService().saveString(startJob, _startJobController.text);
    await PreferenceService().saveString(endJob, _endJobController.text);
    await PreferenceService().saveString(oddLine, _oddLineController.text);
    await PreferenceService().saveString(evenLine, _evenLineController.text);
    await PreferenceService()
        .saveString(startShape, _startShapeController.text);
    await PreferenceService().saveString(endShape, _endShapeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _startJobController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: startJobLable,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _endJobController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: endJobLable,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _oddLineController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: oddLineJobLable,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _evenLineController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: evenLineJobLable,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _startShapeController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: startShapeJobLabel,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    controller: _endShapeController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: endShapeJobLabel,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                fixedSize: const Size.fromWidth(200),
              ),
              onPressed: () {
                saveJobSettings();
              },
              child: const Text('Save'),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
    );
  }
}
