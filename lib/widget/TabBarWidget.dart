import 'package:flutter/material.dart';
import 'package:chyy_app/common/style/theme.dart';

///支持顶部和顶部的TabBar控件
///配合AutomaticKeepAliveClientMixin可以keep住
class TabBarWidget extends StatefulWidget {
  ///底部模式type
  static const int BOTTOM_TAB = 1;

  ///顶部模式type
  static const int TOP_TAB = 2;

  final int type;

  final List<Widget> tabItems;

  final List<Widget> tabViews;

  final Color backgroundColor;

  final Color indicatorColor;

  final Widget title;

  final Widget drawer;

  final Widget floatingActionButton;

  final TarWidgetControl tarWidgetControl;

  final PageController topPageControl;

  final ValueChanged<int> onPageChanged;

  TabBarWidget({
    Key key,
    this.type,
    this.tabItems,
    this.tabViews,
    this.backgroundColor,
    this.indicatorColor,
    this.title,
    this.drawer,
    this.floatingActionButton,
    this.tarWidgetControl,
    this.topPageControl,
    this.onPageChanged,
  }) : super(key: key);

  @override
  _TabBarState createState() =>
      new _TabBarState(
        type,
        tabItems,
        tabViews,
        backgroundColor,
        indicatorColor,
        title,
        drawer,
        floatingActionButton,
        tarWidgetControl,
        topPageControl,
        onPageChanged,
      );
}

// ignore: mixin_inherits_from_not_object
class _TabBarState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  final int _type;

  final List<Widget> _tabItems;

  final List<Widget> _tabViews;

  final Color _backgroundColor;

  final Color _indicatorColor;

  final Widget _title;

  final Widget _drawer;

  final Widget _floatingActionButton;

  final TarWidgetControl _tarWidgetControl;

  final PageController _pageController;

  final ValueChanged<int> _onPageChanged;

  _TabBarState(this._type, this._tabItems, this._tabViews,
      this._backgroundColor, this._indicatorColor, this._title, this._drawer,
      this._floatingActionButton, this._tarWidgetControl, this._pageController,
      this._onPageChanged)
      : super();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _tabItems.length);
  }

  ///整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this._type == TabBarWidget.TOP_TAB) {
      ///顶部tab bar
      return new Scaffold(
        floatingActionButton: _floatingActionButton,
        persistentFooterButtons: _tarWidgetControl == null
            ? []
            : _tarWidgetControl.footerButton,
        appBar: new AppBar(
          backgroundColor: AppTheme.main_color,
          title: _title,
          bottom: new TabBar(
            controller: _tabController,
            tabs: _tabItems,
            indicatorColor: _indicatorColor,
          ),
        ),
        body: new PageView(
          controller: _pageController,
          children: _tabViews,
          onPageChanged: (index) {
            _tabController.animateTo(index);
            if (_onPageChanged != null) {
              _onPageChanged(index);
            }
          },
        ),
      );
    }

    ///底部tab bar
    return new Scaffold(
      drawer: _drawer,
//      appBar: new AppBar(
//        backgroundColor: AppTheme.main_color,
//        title: _title,
//      ),
      body: new TabBarView(
        // TabBarView呈现内容，因此放到Scaffold的body中
        controller: _tabController, //配置控制器
        children: _tabViews
      ),
      bottomNavigationBar: new Material(
        // 为了适配主题风格，包一层Material实现风格套用
        color: AppTheme.main_color, // 底部导航栏主题颜色
        child: Container(
          height: 40.0,
          child: new TabBar(
            // TabBar导航标签，底部导航放到Scaffold的bottomNavigationBar中
            // 配置控制器
            controller: _tabController,
            tabs: _tabItems,
            // tab标签的下划线颜色
            indicatorColor: _indicatorColor,
          ),
        ),
      ));
  }
}

class TarWidgetControl {
  List<Widget> footerButton = [];
}
