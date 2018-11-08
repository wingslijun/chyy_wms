import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chyy_app/common/model/User.dart';
import 'package:chyy_app/common/redux/AppState.dart';
import 'package:chyy_app/common/style/AppStyle.dart';
import 'package:chyy_app/common/style/theme.dart';
import 'package:chyy_app/dao/userDao.dart';
import 'package:chyy_app/widget/AppFlexButton.dart';
import 'package:get_version/get_version.dart';
import 'package:chyy_app/utils/NavigatorUtils.dart';

class HomeDrawer extends StatelessWidget {
  showAboutDialog(BuildContext context, String versionName) {
    versionName ??= "Null";
    showDialog(
        context: context,
        builder: (BuildContext context) => AboutDialog(
              applicationName: "xxxxx",
              applicationVersion: "版本: " + versionName,
              applicationIcon: new Image(image: new AssetImage(AppICons.DEFAULT_USER_ICON), width: 50.0, height: 50.0),
              applicationLegalese: "http://github.com/",
            ));
  }

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<AppState>(
        builder: (context, store) {
        User user = store.state.userInfo;
        return new Drawer(
          ///侧边栏按钮Drawer
          child: new Container(
            ///默认背景
            color: Theme.of(context).primaryColor,
            child: new SingleChildScrollView(
              ///item 背景
              child: new Container(
                constraints: new BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: new Material(
                  child: new Column(
                    children: <Widget>[
                      new UserAccountsDrawerHeader(
                        //Material内置控件
                        accountName: new Text(
                          user.name ?? "---",
                          textScaleFactor: 1.0,
                          style: AppConstant.largeTextWhite,
                        ),
                        accountEmail: new Text(''),
                        //用户名
                        currentAccountPicture: new GestureDetector(
                          //用户头像
                          onTap: () {},
                          child: new CircleAvatar(
                            //圆形图标控件
                            backgroundImage: new AssetImage("static/images/admin.png"),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            //用一个BoxDecoration装饰器提供背景图片
                            color: AppTheme.main_color),
                      ),
                      new ListTile(
                          title: new Text(
                            '检查更新',
                            textScaleFactor: 1.0,
                            style: AppConstant.normalText,
                          ),
                          onTap: () {
                            //ReposDao.getNewsVersion(context, true);
                          }),

                      new ListTile(
                          title: new AppFlexButton(
                            text: '退出登录',
                            color: Colors.redAccent,
                            textColor: Color(AppColors.textWhite),
                            onPress: () {
                              UserDao.clearAll(store);
                              NavigatorUtils.goLogin(context);
                            },
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
