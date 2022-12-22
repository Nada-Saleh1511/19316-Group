import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

class gasGraph extends StatefulWidget {
  @override
  _gasGraph createState() => _gasGraph();
}

class _gasGraph extends State<gasGraph> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    chartData = getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Nitrous Oxide. Conc VS N balance',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            backgroundColor: Colors.green,
          ),
            body: SfCartesianChart(
                series: <LineSeries<LiveData, dynamic>>[
                  LineSeries<LiveData, dynamic>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: Colors.green,
                    xValueMapper: (LiveData sales, _) => sales.n,
                    yValueMapper: (LiveData sales, _) => sales.y,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
                ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    title: AxisTitle(text: 'N balance')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Nitrous Oxide. Conc')))));
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(25, 1.4*math.exp(0.0047*25)),
      LiveData(75, 1.4*math.exp(0.0047*75)),
      LiveData(125, 1.4*math.exp(0.0047*125)),
    ];
  }
}

class LiveData {
  LiveData(this.n, this.y);
  final dynamic n;
  final double y;
}