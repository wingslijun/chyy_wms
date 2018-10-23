/*
import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';

void main() => runApp(new FChartsExampleApp());

class ChartExample {
  ChartExample(
      this.name,
      this.widget,
      this.description,
      );

  final String name;
  final Widget widget;
  final String description;
}
 const myData = [
  ["1969-07-20", "✔"],
  ["1969-07-21", "❓"],
  ["C", "✖"],
  ["D", "❓"],
  ["E", "✖"],
  ["1969-07-22", "✖"],
  ["G", "✔"],
];
final charts = [
  new ChartExample(
    'Simple Line Chart',
 new LineChart(
lines: [
new Line<List, String, String>(
data: myData,
xFn: (datum) => datum[0],
yFn: (datum) => datum[1],
),
],
chartPadding: new EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 30.0),
),
    'Strings on the X-Axis and their index in the list on the Y-Axis.',
  ),
  */
/*new ChartExample(
    'City Coolness & Size Line Chart',
    new CityLineChart(),
    'Cities on the X-Axis with coolness & size on the Y-Axis with painted lines.',
  ),
  new ChartExample(
    'Random Sparkline Chart',
    new SparklineChart(),
    'Just a list of doubles was provided to the constructor.',
  ),
  new ChartExample(
    'Simple Bar Chart',
    new SimpleBarChart(),
    'Bar charts are not quite ready yet.',
  ),*//*

];

class FChartsExampleApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<FChartsExampleApp> {
  var _chartIndex = 0;

  @override
  Widget build(BuildContext context) {
    final chart = charts[_chartIndex % charts.length];

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Example: ${chart.name}'),
        ),
        body: new Container(
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: new Column(
            children: [
              new Padding(
                padding: new EdgeInsets.all(30.0),
                child: new Text(
                  chart.description,
                  textAlign: TextAlign.center,
                ),
              ),
              new Padding(
                  padding: new EdgeInsets.all(20.0),
                  child: new Container(height: 400,
                    child: chart.widget,
                  )),
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            setState(() => _chartIndex++);
          },
          child: new Icon(Icons.refresh),
        ),
      ),
    );
  }
}*/
