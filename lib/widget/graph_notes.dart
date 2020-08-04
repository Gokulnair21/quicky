import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:note_app/model/graph_data_model.dart';
import 'dart:math' show pi;

class GraphOfNotes extends StatelessWidget{

  final List<GraphData> values;

  GraphOfNotes({this.values});



  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context).scaffoldBackgroundColor;

    // TODO: implement build
    List<charts.Series<GraphData,String>> series = [
      charts.Series(
          id: 'Notes',
          data: values,
          domainFn: (GraphData series, _) => series.type,
          measureFn: (GraphData series, _) => series.noOfDocuments,
          colorFn: (GraphData series, _) => series.color,
          labelAccessorFn: (GraphData row, _) => '${row.noOfDocuments}',
         )
    ];
    return charts.PieChart(
      series,
      animate: false,
      animationDuration: Duration(milliseconds: 1000),
        defaultRenderer: CustomArcRendererConfig(
          noDataColor: charts.ColorUtil.fromDartColor(theme),
          stroke: charts.ColorUtil.fromDartColor(theme),
          arcWidth: 40,
          strokeWidthPx: 2.0
        )
    );

  }

}

class CustomArcRendererConfig<D> extends charts.ArcRendererConfig<D> {


  final charts.Color stroke;
  final charts.Color noDataColor;

  CustomArcRendererConfig({
    customRendererId,
    arcRendererDecorators = const [],
    arcLength = 2 * pi,
    arcRatio,
    arcWidth,
    startAngle = -pi / 2,
    layoutPaintOrder = LayoutViewPaintOrder.arc,
    minHoleWidthForCenterContent = 30,
    strokeWidthPx = 2.0,
    symbolRenderer,
    this.noDataColor,
    this.stroke,
  }) : super(
    customRendererId: customRendererId,
    arcRendererDecorators: [charts.ArcLabelDecorator()],
    arcRatio: arcRatio,
    arcWidth: arcWidth,
    startAngle:startAngle,
    arcLength:arcLength,
    layoutPaintOrder: layoutPaintOrder,
    minHoleWidthForCenterContent: minHoleWidthForCenterContent,
    strokeWidthPx: strokeWidthPx,
    symbolRenderer: symbolRenderer,
  );
}