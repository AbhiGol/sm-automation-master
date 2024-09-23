// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sm_automation/models/graph_canvas_model.dart';
import 'package:sm_automation/widgets/graph_painter.dart';

import '../utils/prefrence_service.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  Future<GraphCanvasModel> fetchGraphSetting() async {
    return await PreferenceService().fetchCurrentGraphSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: FutureBuilder(
          future: fetchGraphSetting(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == null) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == null) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            return Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(snapshot.data!.leftPadding, 15, 15,
                        snapshot.data!.bottomPadding),
                    child: CustomPaint(
                      size: Size(
                          snapshot.data!.canvasWidth, snapshot.data!.canvasHeight),
                      painter: GraphPainter(graphCanvasModel: snapshot.data!),
                    ),
                    // child: SizedBox(
                    //   height: graphCanvasModel.canvasHeight,
                    //   width: graphCanvasModel.canvasWidth,
                    //   child: CustomPaint(
                    //     painter: GraphPainter(graphCanvasModel: graphCanvasModel),
                    //   ),
                    // ),
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}
