import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pharmacy/data/data_source/main_api.dart';
import 'package:pharmacy/data/repository.dart';
import 'package:pharmacy/presentation/pages/page_basket.dart';
import 'package:pharmacy/presentation/pages/page_home.dart';
import 'package:pharmacy/resources/controller_basket.dart';
import 'package:pharmacy/resources/controller_home.dart';
import 'package:pharmacy/resources/controller_order_requests.dart';
import 'package:pharmacy/resources/my_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        translations: MyTranslations(),
        locale: prefs.getString("l") == "2" ? const Locale('tk', 'TM') : const Locale('ru', 'RU'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          cardTheme: CardTheme(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade400,
              disabledBackgroundColor: Colors.blue.shade400,
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
            ),
          ),
        ),
        home: const MyBottomNav(),
        initialBinding: BindingsBuilder(() {
          Get.put(RepositoryImpl(MainApi(prefs: prefs)));
          Get.put(HomeController());
          Get.put(BasketController());
          Get.put(OrderRequestsController());
        }));
  }
}

class MyBottomNav extends StatelessWidget {
  const MyBottomNav({super.key});

  List<Widget> _buildScreens() {
    return [const HomePage(), const BasketPage()];
  }

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
              (controller.basketState.value?.total ?? 0).toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            isLabelVisible: (controller.basketState.value?.total ?? 0) > 0,
            child: const Icon(Icons.shopping_basket),
          );
        }),
        title: ("basket".tr),
        activeColorPrimary: Colors.blue.shade400,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final PersistentTabController controller = PersistentTabController(initialIndex: 0);
    return PersistentTabView(
      onWillPop: (final context) async {
        if (controller.index == 0) SystemNavigator.pop();
        return false;
      },
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style9,
      animationSettings: const NavBarAnimationSettings(screenTransitionAnimation: ScreenTransitionAnimationSettings(animateTabTransition: true, screenTransitionAnimationType: ScreenTransitionAnimationType.slide)),
    );
  }
}
