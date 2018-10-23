/*
/// Timeseries chart with example of updating external state based on selection.
///
/// A SelectionModelConfig can be provided for each of the different
/// [SelectionModel] (currently info and action).
///
/// [SelectionModelType.info] is the default selection chart exploration type
/// initiated by some tap event. This is a different model from
/// [SelectionModelType.action] which is typically used to select some value as
/// an input to some other UI component. This allows dual state of exploring
/// and selecting data via different touch events.
///
/// See [SelectNearest] behavior on setting the different ways of triggering
/// [SelectionModel] updates from hover & click events.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:chyy_app/dao/PickingDao.dart';

class SelectionCallbackExample extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SelectionCallbackExample(this.seriesList, {this.animate});

  /// Creates a [charts.TimeSeriesChart] with sample data and no transition.
  factory SelectionCallbackExample.withSampleData() {
    return new SelectionCallbackExample(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales2, DateTime>> _createSampleData() {
    final List<TimeSeriesSales2> data = [];
//    final List<TimeSeriesSales2> data2 = [];
//    if (chartsData.length != 0) {
//      for (var i = 0; i < chartsData.length; i++) {
//        var dateTime =
//        DateTime.fromMillisecondsSinceEpoch(chartsData[i]["time"]);
//        data.add(new TimeSeriesSales2(dateTime, chartsData[i]["val"].toDouble()));
//      }
//    }
//    if (chartsDataSet.length != 0) {
//      for (var i = 0; i < chartsDataSet.length; i++) {
//        var dateTime =
//        DateTime.fromMillisecondsSinceEpoch(chartsDataSet[i]["time"]);
//        data2.add(new TimeSeriesSales2(dateTime, chartsDataSet[i]["val"].toDouble()));
//      }
//    }
//    return [
//      new charts.Series<TimeSeriesSales2, DateTime>(
//        id: '实际值',
//        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//        domainFn: (TimeSeriesSales2 sales, _) => sales.time,
//        measureFn: (TimeSeriesSales2 sales, _) => sales.sales,
//        data: data,
//      ),
//      new charts.Series<TimeSeriesSales2, DateTime>(
//        id: '设定值',
//        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
//        domainFn: (TimeSeriesSales2 sales, _) => sales.time,
//        measureFn: (TimeSeriesSales2 sales, _) => sales.sales,
//        data: data2,
//      )
//    ];
//    final us_data = [
//      new TimeSeriesSales2(new DateTime(2017, 9, 19), 5.0),
//      new TimeSeriesSales2(new DateTime(2017, 9, 26), 25.0),
//      new TimeSeriesSales2(new DateTime(2017, 10, 3), 78.0),
//      new TimeSeriesSales2(new DateTime(2017, 10, 10), 54.0),
//    ];
//
//    final uk_data = [
//      new TimeSeriesSales2(new DateTime(2017, 9, 19), 15.0),
//      new TimeSeriesSales2(new DateTime(2017, 9, 26), 33.0),
//      new TimeSeriesSales2(new DateTime(2017, 10, 3), 68.0),
//      new TimeSeriesSales2(new DateTime(2017, 10, 10), 48.0),
//    ];
//
//    return [
//      new charts.Series<TimeSeriesSales2, DateTime>(
//        id: 'US Sales',
//        domainFn: (TimeSeriesSales2 sales, _) => sales.time,
//        measureFn: (TimeSeriesSales2 sales, _) => sales.sales,
//        data: us_data,
//      ),
//      new charts.Series<TimeSeriesSales2, DateTime>(
//        id: 'UK Sales',
//        domainFn: (TimeSeriesSales2 sales, _) => sales.time,
//        measureFn: (TimeSeriesSales2 sales, _) => sales.sales,
//        data: uk_data,
//      )
//    ];
  }
}

class _SelectionCallbackState extends State<SelectionCallbackExample> {
  DateTime _time;
  Map<String, num> _measures;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.sales;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }
  DateTime _startTime, _endTime;
  List chartsData = [];
  List chartsDataSet = [];
  bool isSet = true;

  List<charts.Series<TimeSeriesSales2, DateTime>> createSampleData0(){
  final us_data = [
  new TimeSeriesSales2(new DateTime(2017, 9, 19), 5.0),
  new TimeSeriesSales2(new DateTime(2017, 9, 26), 25.0),
  new TimeSeriesSales2(new DateTime(2017, 10, 3), 78.0),
  new TimeSeriesSales2(new DateTime(2017, 10, 10), 54.0),
  ];

  final uk_data = [
  new TimeSeriesSales2(new DateTime(2017, 9, 19), 15.0),
  new TimeSeriesSales2(new DateTime(2017, 9, 26), 33.0),
  new TimeSeriesSales2(new DateTime(2017, 10, 3), 68.0),
  new TimeSeriesSales2(new DateTime(2017, 10, 10), 48.0),
  ];

  return [
  new charts.Series<TimeSeriesSales2, DateTime>(
  id: 'US Sales',
  domainFn: (TimeSeriesSales2 sales, _) => sales.time,
  measureFn: (TimeSeriesSales2 sales, _) => sales.sales,
  data: us_data,
  ),
  new charts.Series<TimeSeriesSales2, DateTime>(
  id: 'UK Sales',
  domainFn: (TimeSeriesSales2 sales, _) => sales.time,
  measureFn: (TimeSeriesSales2 sales, _) => sales.sales,
  data: uk_data,
  )
  ];
  }

  List<charts.Series<TimeSeriesSales2, DateTime>> createSampleData() {

    final List<TimeSeriesSales2> data = [];
    final List<TimeSeriesSales2> data2 = [];
    if (chartsData.length != 0) {
      for (var i = 0; i < chartsData.length; i++) {
        var dateTime =
        DateTime.fromMillisecondsSinceEpoch(chartsData[i]["time"]);
        data.add(new TimeSeriesSales2(dateTime, chartsData[i]["val"].toDouble()));
      }
    }
    if (chartsDataSet.length != 0) {
      for (var i = 0; i < chartsDataSet.length; i++) {
        var dateTime =
        DateTime.fromMillisecondsSinceEpoch(chartsDataSet[i]["time"]);
        data2.add(new TimeSeriesSales2(dateTime, chartsDataSet[i]["val"].toDouble()));
      }
    }
    return [
      new charts.Series<TimeSeriesSales2, DateTime>(
        id: '实际值',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales2 sales, _) => sales.time,
        measureFn: (TimeSeriesSales2 sales, _) => sales.sales,
        data: data,
      ),
      new charts.Series<TimeSeriesSales2, DateTime>(
        id: '设定值',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales2 sales, _) => sales.time,
        measureFn: (TimeSeriesSales2 sales, _) => sales.sales,
        data: data2,
      )
    ];
      //..setAttribute(charts.rendererIdKey, 'customPoint'),





*/
/*
    final us_data = [
      new TimeSeriesSales2(new DateTime(2017, 9, 19), 5.0),
      new TimeSeriesSales2(new DateTime(2017, 9, 26), 25.0),
      new TimeSeriesSales2(new DateTime(2017, 10, 3), 78.0),
      new TimeSeriesSales2(new DateTime(2017, 10, 10), 54.0),
    ];

    final uk_data = [
      new TimeSeriesSales2(new DateTime(2017, 9, 19), 15.0),
      new TimeSeriesSales2(new DateTime(2017, 9, 26), 33.0),
      new TimeSeriesSales2(new DateTime(2017, 10, 3), 68.0),
      new TimeSeriesSales2(new DateTime(2017, 10, 10), 48.0),
    ];

    return [
      new charts.Series<TimeSeriesSales2, DateTime>(
        id: 'US Sales',
        domainFn: (TimeSeriesSales2 sales, _) => sales.time,
        measureFn: (TimeSeriesSales2 sales, _) => sales.val,
        data: us_data,
      ),
      new charts.Series<TimeSeriesSales2, DateTime>(
        id: 'UK Sales',
        domainFn: (TimeSeriesSales2 sales, _) => sales.time,
        measureFn: (TimeSeriesSales2 sales, _) => sales.val,
        data: uk_data,
      )
    ];*//*

  }
  @override
  void initState() {
    super.initState();
    _startTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour - 2,
        DateTime.now().minute,
        DateTime.now().second);
    _endTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second);
    chartsData.add({"time": _startTime.millisecondsSinceEpoch, "val": 0});
    chartsDataSet.add({"time": _startTime.millisecondsSinceEpoch, "val": 0});
    DeviceDao.getChartsDate(
        "2", "temp9", _startTime, _endTime,false)
        .then((ret) {
      if (ret["result"] == 1) {
        setState(() {
          chartsData = ret["data"]["list"];
        });
      }
    });
    DeviceDao.getChartsDate(
       "2", "temp9", _startTime, _endTime,true)
        .then((ret) {
      if (ret["result"] == 1) {
        setState(() {
          chartsDataSet = ret["data"]["list"];
        });
      }
//      widget.seriesList=createSampleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      new SizedBox(
          height: 150.0,
          child: new charts.TimeSeriesChart(
            createSampleData0(),
            animate: widget.animate,
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                listener: _onSelectionChanged,
              )
            ],
          )),
    ];

    // If there is a selection, then include the details.
    if (_time != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(_time.toString())));
    }
    _measures?.forEach((String series, num value) {
      children.add(new Text('${series}: ${value}'));
    });

    return new Column(children: children);
  }
}

/// Sample time series data type.
class TimeSeriesSales2 {
  final DateTime time;
  final double sales;

  TimeSeriesSales2(this.time, this.sales);
}*/
