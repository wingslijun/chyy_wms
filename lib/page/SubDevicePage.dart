/*
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:chyy_app/dao/PickingDao.dart';
import 'package:chyy_app/page/ChartFlutterBean.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:chyy_app/utils/NavigatorUtils.dart';
import 'package:chyy_app/utils/toastUtils.dart';
import 'package:chyy_app/widget/SelectionCallbackExample.dart';

class SubDevicePage extends StatefulWidget {
  final String subKey;
  final String name;
  final String deviceId;
  final List datas;
  static final String pName = "SubDevicePage";
  bool animate = false;

  SubDevicePage(this.subKey, this.name, this.deviceId, this.datas);

  @override
  State<StatefulWidget> createState() => new _SubDevicePageState();
}

class _SubDevicePageState extends State<SubDevicePage> {
  List<Widget> widgets = [new Text('--')];
  List<Widget> w1 = [];
  listParam(k, v, _widgets,i,len) {
    _widgets.add(
      new Expanded(
          child: new Container(
              padding: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0),
              child: new Text(
                '$k :',
                textScaleFactor: 1.0,
                style: new TextStyle(fontSize: 14.0),
              ))),
    );
    var regExp = new RegExp(r'[\u4e00-\u9fa5]');
    // print(regExp.hasMatch(v));
    _widgets.add(
      new Expanded(
          flex: (i%2==0&& i==len-1)?3:1,
          child: new Container(
              padding: EdgeInsets.only(
                  top: regExp.hasMatch(v.toString()) ? 1.0 : 3.0,
                  left: 1.0,
                  right: 5.0),
              child: new Text(
                v.toString(),
                textScaleFactor: 1.0,
                style: new TextStyle(fontSize: 14.0),
              ))),
    );
    setState(() {
      w1 = _widgets;
    });
  }
  topWidget() {
    var dataList = widget.datas;

    if (dataList != null && dataList.length > 0) {
      List<Widget> _widgets = [];
      for (var i = 0; i < dataList.length; i++) {
        var dataMap = dataList[i] as Map;
        listParam(dataMap["key"], dataMap["val"], w1,i,dataList.length);
        if ((i + 1) % 2 == 0) {
          Row r = new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: w1,
          );
          _widgets.add(r);
          w1 = [];
        }
        if( dataList.length%2!=0 && i==dataList.length-1){
          Row r = new Row(
            children: w1,
          );
          _widgets.add(r);
        }
      }

      setState(() {
        widgets = _widgets;
      });
    }
  }
  DateTime _startTime, _endTime;
  List chartsData = [];
  List chartsDataSet = [];
  bool isSet = true;

  List<charts.Series<TimeSeriesSales, DateTime>>  createSampleData() {

    final List<TimeSeriesSales> data = [];
    final List<TimeSeriesSales> data2 = [];
    if (chartsData.length != 0) {
      for (var i = 0; i < chartsData.length; i++) {
        var dateTime =
            DateTime.fromMillisecondsSinceEpoch(chartsData[i]["time"]);
        data.add(new TimeSeriesSales(dateTime, chartsData[i]["val"].toDouble()));
      }
    }
    if (chartsDataSet.length != 0) {
      for (var i = 0; i < chartsDataSet.length; i++) {
        var dateTime =
        DateTime.fromMillisecondsSinceEpoch(chartsDataSet[i]["time"]);
        data2.add(new TimeSeriesSales(dateTime, chartsDataSet[i]["val"].toDouble()));
      }
    }
    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: '实际值',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.val,
        data: data,
      ),
      new charts.Series<TimeSeriesSales, DateTime>(
        id: '设定值',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.val,
        data: data2,
      )
    //  ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }

  DateTime _time;
  Map<String, num> _measures;
  bool _offset = true;
  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  var timer =   Timer.periodic(const Duration(seconds: 20), (Void) async{
  });
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
        measures[datumPair.series.displayName] = datumPair.datum.val;
      });
    }
    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
      _offset = false;
    });
//    new Future.delayed(const Duration(seconds:5), () {
//      if(_offset == false){
//        setState(() {
//          _offset = true;
//        });
//      }
//    });
  }
  @override
  void initState() {
    super.initState();
    topWidget();
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
            widget.deviceId, widget.subKey, _startTime, _endTime,false)
        .then((ret) {
      if (ret["result"] == 1) {
        setState(() {
          chartsData = ret["data"]["list"];
        });
      }
    });
    DeviceDao.getChartsDate(
        widget.deviceId, widget.subKey, _startTime, _endTime,true)
        .then((ret) {
      if (ret["result"] == 1) {
        setState(() {
          chartsDataSet = ret["data"]["list"];
        });
      }
    });
  }
  final TextEditingController _controller = new TextEditingController(text: "duo_shine");
  Future<Null> _selectDate(start) {
    DatePicker.showDateTimePicker(context, showTitleActions: true,
        onChanged: (date) {
     // print('change $date');
    }, onConfirm: (date) {
   //   print('confirm $date');
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
  */
/*var _sliderDomainValue;
  String _sliderDragState;
  Point<int> _sliderPosition;

  // Handles callbacks when the user drags the slider.
  _onSliderChange(Point<int> point, dynamic domain,
   charts.SliderListenerDragState dragState) {
    // Request a build.
    void rebuild(_) {
      setState(() {
        _sliderDomainValue = domain ;
        _sliderDragState = dragState.toString();
        _sliderPosition = point;
      });
    }

    SchedulerBinding.instance.addPostFrameCallback(rebuild);
  }*//*

  @override
  Widget build(BuildContext context) {
*/
/*    if(_offset == false){
      timer = Timer.periodic(const Duration(seconds: 10), (Void) async{
        print(_offset);
        setState(() {
          _offset = true;
        });
      });
    }*//*

    ScreenUtil.instance = ScreenUtil(width: 720, height: 1280)..init(context);
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
    //  ToastUtils.chartMsg(msg);
    }
  */
/*  // If there is a slider change event, then include the details.
    if (_sliderDomainValue != null) {
      chs.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text('Slider domain value: ${_sliderDomainValue}')));
    }
    if (_sliderPosition != null) {
      chs.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(
              'Slider position: ${_sliderPosition.x}, ${_sliderPosition.y}')));
    }
    if (_sliderDragState != null) {
      chs.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text('Slider drag state: ${_sliderDragState}')));
    }
*//*

    return new Scaffold(
        backgroundColor: AppTheme.background_color,
        appBar: new AppBar(
          title: new Text(widget.name), backgroundColor:  AppTheme.main_color,
        ),
        body: new ListView(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(
                  top: 20.0, left: 5.0, right: 5.0, bottom: 5.0),
              color: AppTheme.background_color,
              child: new Material(
                borderRadius: BorderRadius.circular(13.0),
                shadowColor: Colors.grey.shade200,
                elevation: 5.0,
                child:new Container(
                  // height: 220.0,
                    decoration: new BoxDecoration(
                        color:AppTheme.sta_back,
                        border: Border.all(
                            color: Colors.grey, style: BorderStyle.solid),
                     */
/*   boxShadow: <BoxShadow>[
                          new BoxShadow (
                            color: Colors.grey,
                            offset: new Offset(0.0, 2.0),
                            blurRadius: 4.0,
                          ),
                          new BoxShadow (
                            color: Colors.grey,
                            offset: new Offset(0.0, 4.0),
                            blurRadius: 20.0,
                          )],*//*

                    borderRadius: BorderRadius.circular(13.0)),
                    padding: EdgeInsets.all(5.0),
                    child: new Container(
                      alignment: Alignment.center,
                      child: new Column(children: <Widget>[
                        new Text(
                          widget.name + " 参数和状态",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0,
                            color: AppTheme.main_color
                          ),
                        ),
                        new Container(
                          alignment: Alignment.bottomCenter,
                          color:AppTheme.sta_back,
                          padding: EdgeInsets.only(left:10.0,top: 3.0),
                          child: new Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 5.0, // 水平方向上两个子组件的间距
                            runSpacing: 8.0,
                          //  crossAxisAlignment:WrapCrossAlignment.end,
                            children: widgets,
                          ),
                        ),
                      ]),
                    )),
              ) ,
              ) ,

            new Stack(
              alignment: new Alignment(0.8, 0.7),
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(
                      top: 20.0, left: 5.0, right: 5.0, bottom: 5.0),
                  color: AppTheme.background_color,
                  child:new Material(
                      borderRadius: BorderRadius.circular(13.0),
                      shadowColor: Colors.grey.shade200,
                      elevation: 5.0,
                      child: new Container(
                        decoration: new BoxDecoration(
                            color:AppTheme.sta_back,
                            border: Border.all(
                                color: Colors.grey, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(13.0)),
                        padding: EdgeInsets.all(5.0),
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 10.0,bottom: 3.0),
                              child: new Text(
                                (widget.subKey == 'feed' || widget.subKey == 'tow' ||
                                    widget.subKey == 'host') ? "电流变化曲线" : "温度变化曲线",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: AppTheme.main_color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                ),
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.only(
                                  left: 3.0, right: 3.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  OutlineButton(
                                      textColor: Colors.white,
                                      borderSide: new BorderSide(
                                          color: Theme
                                              .of(context)
                                              .primaryColor),
                                      padding: EdgeInsets.all(1.0),
                                      onPressed: () {
                                        _selectDate("start");
                                      },
                                      child: Text(
                                        _startTime != null ? _startTime.toString()
                                            .substring(0, 19) : '开始时间',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                  new Text('--'),
                                  OutlineButton(
                                      borderSide: new BorderSide(
                                          color: Theme
                                              .of(context)
                                              .primaryColor),
                                      padding: EdgeInsets.all(1.0),
                                      onPressed: () {
                                        _selectDate("");
                                      },
                                      child: Text(
                                        _endTime != null ? _endTime.toString()
                                            .substring(0, 19) : '结束时间',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                  new GestureDetector(
                                      child: new Container(
                                          width:ScreenUtil().setWidth(110),
                                        //   padding: EdgeInsets.only(left: 20.0),
                                          child: new RaisedButton(
                                            color:AppTheme.main_color,
                                            child: new Text(
                                              '查询',
                                              textScaleFactor: 1.0,
                                              style: new TextStyle(
                                                  color:Colors.white),
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onPressed: () {
                                              DeviceDao.getChartsDatas(widget.deviceId,
                                                  widget.subKey, _startTime, _endTime)
                                                  .then((ret) {
                                                if (ret[0]["result"] == 1 &&
                                                    ret[1]["result"] == 1) {
                                                  var d = ret[0]["data"]["list"] as List;
                                                  var d2 = ret[1]["data"]["list"] as List;
                                                  if (d.length == 0 || d2.length == 0) {
                                                    ToastUtils.normalMsg("没有数据");
                                                  }
                                                  setState(() {
                                                    chartsData = ret[0]["data"]["list"];
                                                    chartsDataSet =
                                                    ret[1]["data"]["list"];
                                                  });
                                                } else {
                                                  ToastUtils.normalMsg(
                                                      ret[0]["message"]);
                                                  */
/* showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  content: new Text("请求异常")));*//*

                                                }
                                              });
                                            },
                                          )))
                                ],
                              ),
                              */
/*    new Row(
                    children: <Widget>[
                      new GestureDetector(
                          child: new Container(
                              padding: EdgeInsets.only(left: 20.0),
                              child: new OutlineButton(
                                borderSide: new BorderSide(
                                    color: Theme.of(context).primaryColor),
                                child: new Text(
                                  '查询',
                                  style: new TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                onPressed: () {

                                  DeviceDao.getChartsDatas(widget.deviceId,
                                          widget.subKey, _startTime, _endTime)
                                      .then((ret) {

                                    if (ret[0]["result"] == 1&& ret[1]["result"] == 1) {
                                      var d = ret[0]["data"]["list"] as List;
                                      var d2 = ret[1]["data"]["list"] as List;
                                      if (d.length == 0 || d2.length ==0) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                    content: new Text("没有数据")));
                                      }
                                      setState(() {
                                        chartsData = ret[0]["data"]["list"];
                                        chartsDataSet =  ret[1]["data"]["list"];
                                      });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                  content: new Text("请求异常")));
                                    }
                                  });
                                },
                              )))
                    ],
                  ),*//*

                            ),
                           */
/*   new Container(
                                padding: EdgeInsets.all(10.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: chs,
                                )
                            ),*//*

                            new Container(
                              padding: EdgeInsets.only(
                                  top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
                              //   color:AppTheme.chart_back,
                              child: new Container(
                                height: MediaQuery.of(context).size.height - 420,
                                */
/*  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.grey, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(13.0)),
                padding: EdgeInsets.all(5.0),*//*

                                child: new SizedBox(
                                  //  height: 150.0,
                                    child:
                                    new charts.TimeSeriesChart(
                                      createSampleData(),
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
                            */
/*    new GestureDetector(

                      child: new Container(
                         alignment: Alignment.bottomRight,
                          child:  new Text("单位：℃"),
                             ) ,
                   *//*
*/
/*   onTap: () {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) =>
                            new SelectionCallbackExample.withSampleData()));
                      }*//*
*/
/*
                    )*//*

                          ],
                        ),
                      )),
                ),
                new Offstage(
                    offstage: _offset, //这里控制
                    child: new Container(
                    padding: EdgeInsets.all(10.0),
                child: new Opacity(
                opacity: 0.8,
                      child: new Material(
                      //  color: AppTheme.main_color,
                      */
/*   decoration: new BoxDecoration(
                          border: Border.all(
                              color: Colors.grey, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(13.0),
                        ),*//*

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
            ),

          ],
        ));
  }
}
*/
