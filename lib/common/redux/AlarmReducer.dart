import 'package:chyy_app/common/model/Alarm.dart';
import 'package:redux/redux.dart';


final AlarmReducer = combineReducers<List<Alarm>>([
  TypedReducer<List<Alarm>, RefreshAlarmAction>(_refresh),
]);

List<Alarm> _refresh(List<Alarm> list, action) {
  list.clear();
  if (action.list == null) {
    return list;
  } else {
    list.addAll(action.list);
    return list;
  }
}

class RefreshAlarmAction {
  final List<Alarm> list;

  RefreshAlarmAction(this.list);
}