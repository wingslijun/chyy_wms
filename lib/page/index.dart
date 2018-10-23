import 'dart:async';
import 'package:chyy_app/common/style/theme.dart';
import 'package:chyy_app/page/homeDrawer.dart';
import 'package:chyy_app/utils/toastUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _IndexState();
  }
}

class _IndexState extends State<Index> {
  DateTime _startTime, _endTime;
  final TextEditingController _controller = new TextEditingController(text: "");

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
  }

  Future<Null> _selectDate(start) {
    // ignore: argument_type_not_assignable
    DatePicker.showDateTimePicker(context, showTitleActions: true,
        onChanged: (date) {
      // print('change $date');
    }, onConfirm: (date) {
      // print('confirm $date');
      setState(() {
        if (start == "start") {
          _startTime = date;
        } else {
          _endTime = date;
        }
      });
      _controller.value = TextEditingValue(text: '$date');
    }, locale: 'zh');
  }
  Future<Null> pressSearch() {}

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 1), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 2), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 3), 25),
      new TimeSeriesSales(new DateTime(2017, 9, 4), 100),
      new TimeSeriesSales(new DateTime(2017, 9, 5), 75),
      new TimeSeriesSales(new DateTime(2017, 9, 6), 88),
      new TimeSeriesSales(new DateTime(2017, 9, 7), 65),
      new TimeSeriesSales(new DateTime(2017, 9, 8), 91),
      new TimeSeriesSales(new DateTime(2017, 9, 9), 100),
      new TimeSeriesSales(new DateTime(2017, 9, 10), 111),
      new TimeSeriesSales(new DateTime(2017, 9, 11), 90),
      new TimeSeriesSales(new DateTime(2017, 9, 12), 50),
      new TimeSeriesSales(new DateTime(2017, 9, 13), 40),
      new TimeSeriesSales(new DateTime(2017, 9, 14), 30),
      new TimeSeriesSales(new DateTime(2017, 9, 15), 40),
      new TimeSeriesSales(new DateTime(2017, 9, 16), 50),
      new TimeSeriesSales(new DateTime(2017, 9, 17), 30),
      new TimeSeriesSales(new DateTime(2017, 9, 18), 35),
      new TimeSeriesSales(new DateTime(2017, 9, 19), 40),
      new TimeSeriesSales(new DateTime(2017, 9, 20), 32),
      new TimeSeriesSales(new DateTime(2017, 9, 21), 31),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  Map<String, num> _measures;
  bool _offset = true;
  DateTime _time;

  Future<Null> _onSelectionChanged(charts.SelectionModel model) {
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
      _offset = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final chs = <Widget>[];
    // If there is a selection, then include the details.
    if (_time != null) {
      var msg  = _time.toString().substring(0,19)+"                                       ";
      chs.add(new Padding(padding: new EdgeInsets.only(top: 5.0),child: new Text(_time.toString().substring(0,19),textScaleFactor: 1.0,
          style:
          new TextStyle(fontSize: 15.0,color: AppTheme.main_color
          )
      )));
      _measures?.forEach((String series, num value) {
        chs.add(new Text('${series}: ${value}',
          textScaleFactor: 1.0,
          style: new TextStyle(fontSize: 15.0,color: AppTheme.main_color),));
        msg = msg +  '  ${series} : ${value}';
      });
     //   ToastUtils.chartMsg(msg);
    }
    return new MaterialApp(
      home: new Scaffold(
        drawer: new HomeDrawer(),
        appBar: new AppBar(
          title: new Text("主页"),
          backgroundColor: AppTheme.main_color,
        ),
        body: new Center(
            child: new ListView(
          children: <Widget>[
            new Row(children: <Widget>[
              new Text("当前批次：20180110"),
            ]),
            new Row(
              children: <Widget>[
                new Text("待拣订单数：500"),
                new Text("待拣产品数：2000"),
                new Text("用户1当日拣货：100"),
              ],
            ),
            new Row(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(left: 3.0, right: 3.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      OutlineButton(
                          textColor: Colors.white,
                          borderSide: new BorderSide(
                              color: Theme.of(context).primaryColor),
                          padding: EdgeInsets.all(1.0),
                          onPressed: () {
                            _selectDate("start");
                          },
                          child: Text(
                            _startTime != null
                                ? _startTime.toString().substring(0, 19)
                                : '开始时间',
                            textScaleFactor: 1.0,
                            style: TextStyle(color: Colors.blue),
                          )),
                      new Text('--'),
                      OutlineButton(
                          borderSide: new BorderSide(
                              color: Theme.of(context).primaryColor),
                          padding: EdgeInsets.all(1.0),
                          onPressed: () {
                            _selectDate("");
                          },
                          child: Text(
                            _endTime != null
                                ? _endTime.toString().substring(0, 19)
                                : '结束时间',
                            textScaleFactor: 1.0,
                            style: TextStyle(color: Colors.blue),
                          )),
                      new GestureDetector(
                          child: new Container(
                          width: ScreenUtil().setWidth(200),
                        //   padding: EdgeInsets.only(left: 20.0),
                        child: new RaisedButton(
                            color: AppTheme.main_color,
                            child: new Text(
                              '查询',
                              textScaleFactor: 1.0,
                              style: new TextStyle(color: Colors.white),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () {}),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          new Stack(
            alignment: new Alignment(0.8, 0.7),
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(
                    top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
                //   color:AppTheme.chart_back,
                child: new Container(
                  height: MediaQuery.of(context).size.height - 420,
                  /*  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.grey, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(13.0)),
                padding: EdgeInsets.all(5.0),*/
                  child: new SizedBox(
                    //  height: 150.0,
                      child:
                      new charts.TimeSeriesChart(
                        _createSampleData(),
                        animate:true,
                        animationDuration: new Duration(milliseconds:600),
                        //      defaultRenderer: new charts.LineRendererConfig(),
                        // Custom renderer configuration for the point series.
                        customSeriesRenderers: [
                          new charts.PointRendererConfig(
                            // ID used to link series to this renderer.
                              customRendererId: 'customPoint')
                        ],
                        selectionModels: [
                          new charts.SelectionModelConfig(
                            type: charts.SelectionModelType.info,
                            listener: _onSelectionChanged,
                          )
                        ],
                        behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
//                                        primaryMeasureAxis: new charts.NumericAxisSpec(
//                                            tickProviderSpec:
//                                            new charts.BasicNumericTickProviderSpec(
//                                               dataIsInWholeNumbers: true,
//                                             // Fixed tick count to highlight the integer only behavior
//                                              // generating ticks [0, 1, 2, 3, 4].
//                                             //  desiredTickCount: 5,
//                                               //zeroBound: false
//                                            ))
                      )
                  ),
                ),
              ),
              new Offstage(
                  offstage: _offset, //这里控制
                  child: new Container(
                      padding: EdgeInsets.all(10.0),
                      child: new Opacity(
                          opacity: 0.8,
                          child: new Material(
                            color: AppTheme.sta_back,
                            borderRadius: BorderRadius.circular(6.0),
                            elevation: 2.0,
                            child:new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: chs,
                            ),
                          )
                      )
                  ))
            ],
          )

          ],
        )),
      ),
    );
  }
}
/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;
  TimeSeriesSales(this.time, this.sales);
}
