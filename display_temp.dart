import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cap_1/temp_graph.dart';
import 'package:cap_1/nitrous_oxide_graph.dart';
import 'package:cap_1/table.dart';

class showTemp extends StatefulWidget {
  const showTemp({Key? key}) : super(key: key);
  @override
  State<showTemp> createState() => _showTempState();
}

class _showTempState extends State<showTemp> {
  final _database = FirebaseDatabase.instance.reference();
  dynamic temp = 0;

  @override
  void initState() {
    _activateListners();
    super.initState();
  }

  void _activateListners() {
    _database.child('sensor/temp').onValue.listen((event) {
      final dynamic value = event.snapshot.value as dynamic;
        setState(() {
          temp = value;
        });
    });
  }

  MaterialColor() {
    if (temp >= 30 && temp <= 70) {
      return Colors.orange;
    } else if (temp > 70) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Temperature reads',
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
            child: Center(
                child: Column(
                    children: [
                  Expanded(
                      child: Container(
                    child: Text(
                      'The temperature is',
                      style: TextStyle(fontSize: 30),
                    ),
                    padding: EdgeInsets.only(top: 150),
                  )),
                  Expanded(child: showData()),
                      Row(children:[Text('Normal Temperature'), SizedBox(width: 10,) ,dataLabel(color:Colors.green)]),
                      SizedBox(height: 10,),
                      Row(children:[Text('dynamicermediate Temperature'),SizedBox(width: 10,), dataLabel(color:Colors.orange)]),
                      SizedBox(height: 10,),
                      Row(children:[Text('Dangerous Temperature'),SizedBox(width: 10,), dataLabel(color:Colors.red)]),
                    ])
            ),
          ),
        ),

        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: Colors.green,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.hot_tub),
                  label: 'Time - Temperature',
                  backgroundColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              tempTime() //here pass the actual values of these variables, for example false if the payment isn't successfull..etc
                          ),
                    );
                  }),
              SpeedDialChild(
                  child: Icon(Icons.air),
                  label: 'Nitrous Oxide - N',
                  backgroundColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              gasGraph() //here pass the actual values of these variables, for example false if the payment isn't successfull..etc
                          ),
                    );
                  }),
              SpeedDialChild(
                  child: Icon(Icons.table_chart),
                  label: 'Table of data',
                  backgroundColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              dataTable() //here pass the actual values of these variables, for example false if the payment isn't successfull..etc
                      ),
                    );
                  }),
            ]));
  }

  Widget showData() {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 170,
              height: 170,
              child: Stack(fit: StackFit.expand, children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(MaterialColor()),
                  strokeWidth: 10,
                  value: temp / 100,
                  backgroundColor: Colors.grey,
                ),
                Center(
                  child: Text(
                    '${temp.toStringAsFixed(2)} C',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                    ),
                  ),
                ),
              ])),
        ],
      ),
    );
  }
  Container dataLabel ({required Color color}) {
          return Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: color,
            ),
            alignment: Alignment.bottomLeft,
          );
  }
}
