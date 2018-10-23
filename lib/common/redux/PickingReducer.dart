import 'package:chyy_app/common/model/Picking.dart';
import 'package:redux/redux.dart';


final PickingReducer = combineReducers<List<Picking>>([
  TypedReducer<List<Picking>, RefreshPickingAction>(_refresh),
]);

List<Picking> _refresh(List<Picking> list, action) {
  list.clear();
  if (action.list == null) {
    return list;
  } else {
    list.addAll(action.list);
    return list;
  }
}

class RefreshPickingAction {
  final List<Picking> list;
  RefreshPickingAction(this.list);
}
