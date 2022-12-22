import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'package:cap_1/display_temp.dart';

class tempTime extends StatefulWidget {
  const tempTime({Key? key}) : super(key: key);
  @override
  State<tempTime> createState() => _tempTime();
}

class _tempTime extends State<tempTime> {
  final _database = FirebaseDatabase.instance.reference();
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  dynamic temp = 0;
  @override
  void initState() {
    _activateListners ();
    chartData = getChartData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }
  dynamic _activateListners (){
    _database.child('sensor/temp').onValue.listen((event) {
        temp = event.snapshot.value as dynamic;
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar (
              title: Text('Graph of Temberature and time',
                style: TextStyle(color: Colors.white,
                fontSize: 18),),
              centerTitle: true,
              backgroundColor: Colors.green,
            ),
            body: SfCartesianChart(
                series: <LineSeries<LiveData, dynamic>>[
                  LineSeries<LiveData, dynamic>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: const Color.fromRGBO(0, 155, 0, 1),
                    xValueMapper: (LiveData sales, _) => sales.time,
                    yValueMapper: (LiveData sales, _) => sales.temp,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
                ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Temberature in C')))));
  }

  dynamic time = 0;

  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++,_activateListners()));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(time, temp),
      ];
  }
}
class LiveData {
  LiveData(this.time, this.temp);
  final dynamic time;
  final dynamic temp;
}
