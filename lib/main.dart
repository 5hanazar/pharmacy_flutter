import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/data/repository.dart';
import 'package:pharmacy/presentation/pages/page_basket.dart';
import 'package:pharmacy/presentation/pages/page_home.dart';
import 'package:pharmacy/presentation/pages/page_order_requests.dart';
import 'package:pharmacy/resources/controller_basket.dart';
import 'package:pharmacy/resources/controller_home.dart';
import 'package:pharmacy/resources/controller_order_requests.dart';
import 'package:pharmacy/resources/my_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: MyTranslations(),
        locale: prefs.getInt("l") == 2 ? const Locale('tm', 'TM') : const Locale('ru', 'RU'),
        theme: ThemeData(
          fontFamily: 'FontUI',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          cardTheme: CardTheme(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.blue, width: 0.5),
              )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              disabledBackgroundColor: Colors.blue.shade50,
              foregroundColor: Colors.blue.shade700,
              disabledForegroundColor: Colors.blue.shade700,
            ).copyWith(
              elevation: WidgetStateProperty.all(0.0),
            ),
          ),
        ),
        home: MyBottomNav(),
        initialBinding: BindingsBuilder(() {
          Get.put(RepositoryImpl(prefs, MainApi(prefs: prefs)));
          Get.put(HomeController());
          Get.put(BasketController());
          Get.put(OrderRequestsController());
        }));
  }
}

class MyBottomNav extends StatelessWidget {
  MyBottomNav({super.key});

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_filled),
        title: ("home".tr),
        activeColorPrimary: Colors.blue.shade400,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: GetBuilder<BasketController>(builder: (controller) {
          return Badge(
            label: Text(
              (controller.basketState.value?.amount ?? 0).toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            isLabelVisible: (controller.basketState.value?.total ?? 0) > 0,
            child: const Icon(Icons.shopping_basket),
          );
        }),
        title: ("basket".tr),
        activeColorPrimary: Colors.blue.shade400,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: GetBuilder<OrderRequestsController>(builder: (controller) {
          return Badge(
            label: Text(
              (controller.orderRequestsState.value?.count ?? 0).toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            isLabelVisible: (controller.orderRequestsState.value?.count ?? 0) > 0,
            child: const Icon(Icons.receipt),
          );
        }),
        title: ("orders".tr),
        activeColorPrimary: Colors.blue.shade400,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      onWillPop: (final context) async {
        if (_controller.index == 0) SystemNavigator.pop();
        return false;
      },
      context,
      controller: _controller,
      screens: [const HomePage(), BasketPage(navigateTab: (page) {
        _controller.jumpToTab(2);
      }), const OrderRequestsPage()],
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style9,
      animationSettings: const NavBarAnimationSettings(screenTransitionAnimation: ScreenTransitionAnimationSettings(animateTabTransition: true, screenTransitionAnimationType: ScreenTransitionAnimationType.slide)),
    );
  }
}

String errorFormat(String error) {
  if (error.contains("connection")) {
    return "error_connection".tr;
  } else {
    return "error_unknown".tr;
  }
}