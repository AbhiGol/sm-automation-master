import 'package:flutter/material.dart';
import 'package:sm_automation/models/graph_canvas_model.dart';

class GraphPainter extends CustomPainter {
  final GraphCanvasModel graphCanvasModel;
  GraphPainter({required this.graphCanvasModel});
  // double canvasHeight, canvasWidth, zref, zdepth, progress, zlift, zspeed;
  // int dotNumberCount, dotLinesCount, verticalLines, horizontalLines;
  // bool zigZagBool, snackBool;
  // Color highLightLineColor, graphLineColor;
  List<Map<String, String>> xyList = [];
  double circleRadius = 3.0;

  //for dot
  final paint2 = Paint()
    ..color = Colors.blueGrey
    ..strokeWidth = 3;
  @override
  void paint(Canvas canvas, Size size) async {
    xyList.clear();
    /*color, width , stroke of line
    for vertical n horizontal line*/
    final paint1 = Paint()
      ..color = graphCanvasModel.graphLineColor
      ..strokeWidth = 1;

    // //for highlight line
    final paint3 = Paint()
      ..color = graphCanvasModel.highLightLineColor
      ..strokeWidth = 4;
    //initial value
    double spaceHorizonatal = (graphCanvasModel.canvasWidth) /
            (graphCanvasModel.verticalLines - 1),
        spaceVertically =
            (graphCanvasModel.canvasHeight) / graphCanvasModel.horizontalLines,
        yspaceorigin =
            (graphCanvasModel.canvasHeight) / graphCanvasModel.horizontalLines,
        xStartingDistance = 0,
        yStartingDistance = 0,
        yPointHeight2 = graphCanvasModel.canvasHeight,
        yDistanceFromOrigin = -(graphCanvasModel.canvasHeight / 2),
        yPointHeight1 = graphCanvasModel.canvasHeight;
    int extraInt = 1;
    if (graphCanvasModel.verticalLines == 1) {
      xStartingDistance = graphCanvasModel.canvasWidth / 2;
    }
    for (int i = 1; i <= graphCanvasModel.verticalLines; i++) {
      //below one line for make vertical lines//
      canvas.drawLine(Offset(xStartingDistance, 0),
          Offset(xStartingDistance, graphCanvasModel.canvasHeight), paint1);
      //below loop for make circles and highlighted black line
      if (extraInt <= graphCanvasModel.dotLinesCount) {
        double yPointHeight3 = graphCanvasModel.canvasHeight;
        double yPointHeight4 = graphCanvasModel.canvasHeight;
        for (int k = 0; k < graphCanvasModel.dotNumberCount; k++) {
          if (graphCanvasModel.zigZagBool) {
            if (graphCanvasModel.snackBool) {
              if (extraInt % 2 == 0) {
                //for draw circle
                drawCircle(canvas, (xStartingDistance),
                    (yPointHeight1 + spaceVertically / 2));
                //for add into list
                //for draw highlight black line
                canvas.drawLine(
                    Offset(xStartingDistance, yPointHeight2),
                    Offset(
                        xStartingDistance,
                        yPointHeight2 -
                            spaceVertically * graphCanvasModel.progress),
                    paint3);
                yPointHeight1 = yPointHeight1 + spaceVertically;
                yDistanceFromOrigin += yspaceorigin;
              } else {
                //for draw circle
                drawCircle(canvas, xStartingDistance, yPointHeight1);
                //for add into list
                //for draw highlight black line
                canvas.drawLine(
                    Offset(xStartingDistance, yPointHeight2),
                    Offset(
                        xStartingDistance,
                        yPointHeight2 -
                            spaceVertically * graphCanvasModel.progress),
                    paint3);
                yPointHeight1 = yPointHeight1 - spaceVertically;
                yDistanceFromOrigin += yspaceorigin;
              }
            } else {
              if (extraInt % 2 == 0) {
                yPointHeight4 = yPointHeight4 - spaceVertically;
                yDistanceFromOrigin += spaceVertically;
                //for draw circle
                drawCircle(canvas, (xStartingDistance),
                    (yPointHeight4 + spaceVertically / 2));
                //for add into list
                //for draw highlight black lin
                canvas.drawLine(
                    Offset(xStartingDistance, yPointHeight4),
                    Offset(
                        xStartingDistance,
                        yPointHeight4 -
                            spaceVertically * graphCanvasModel.progress),
                    paint3);
              } else {
                //for draw circle
                drawCircle(canvas, xStartingDistance, yPointHeight4);
                //for add into list
                //for draw highlight black line
                canvas.drawLine(
                    Offset(xStartingDistance, yPointHeight2),
                    Offset(
                        xStartingDistance,
                        yPointHeight2 -
                            spaceVertically * graphCanvasModel.progress),
                    paint3);
                yPointHeight4 = yPointHeight4 - spaceVertically;
                yDistanceFromOrigin += spaceVertically;
              }
            }
          } else {
            if (graphCanvasModel.snackBool) {
              if (extraInt % 2 == 0) {
                yPointHeight2 = yPointHeight2 + spaceVertically;
                yDistanceFromOrigin -= spaceVertically;
                //for add into list
                //for draw highlight black line
                canvas.drawLine(
                    Offset(xStartingDistance, yPointHeight2),
                    Offset(
                        xStartingDistance,
                        yPointHeight2 -
                            spaceVertically * graphCanvasModel.progress),
                    paint3);
                //for draw circle
                drawCircle(canvas, xStartingDistance, yPointHeight2);
              } else {
                //for add into list
                //for draw highlight black line
                canvas.drawLine(
                    Offset(xStartingDistance, yPointHeight2),
                    Offset(
                        xStartingDistance,
                        yPointHeight2 -
                            spaceVertically * graphCanvasModel.progress),
                    paint3);
                //for draw circle
                drawCircle(canvas, xStartingDistance, yPointHeight2);

                yPointHeight2 = yPointHeight2 - spaceVertically;
                yDistanceFromOrigin += spaceVertically;
              }
            } else {
              //for add into list
              //for draw highlight black line
              canvas.drawLine(
                  Offset(xStartingDistance, yPointHeight3),
                  Offset(
                      xStartingDistance,
                      yPointHeight3 -
                          spaceVertically * graphCanvasModel.progress),
                  paint3);
              //for draw circle
              drawCircle(canvas, xStartingDistance, yPointHeight3);
              yPointHeight3 = yPointHeight3 - spaceVertically;
              yDistanceFromOrigin += spaceVertically;
            }
          }
        }
        if (graphCanvasModel.zigZagBool) {
          if (yDistanceFromOrigin > 0) {
            yDistanceFromOrigin -= ((graphCanvasModel.canvasHeight /
                    graphCanvasModel.horizontalLines) /
                2);
            yspaceorigin = -(yspaceorigin);
          } else {
            yDistanceFromOrigin += ((graphCanvasModel.canvasHeight /
                    graphCanvasModel.horizontalLines) /
                2);
            yspaceorigin = yspaceorigin.abs();
          }
        }
        extraInt++;
      }
      xStartingDistance = xStartingDistance + spaceHorizonatal;
    }
    //for horizontal lines//

    for (int i = 1; i <= graphCanvasModel.horizontalLines; i++) {
      yStartingDistance = yStartingDistance + spaceVertically;

      canvas.drawLine(
          Offset(0, yStartingDistance),
          Offset(graphCanvasModel.canvasWidth - spaceHorizonatal,
              yStartingDistance),
          paint1);
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(covariant GraphPainter oldDelegate) => false;

  void drawCircle(Canvas canvas, double x, double y) {
    canvas.drawCircle(Offset(x, y), circleRadius, paint2);
  }
}
