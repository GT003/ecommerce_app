import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Color.fromARGB(255, 75, 75, 75),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 75, 75, 75),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      home: HomePage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  final bool isDarkMode;
  const HomePage({
    super.key,
    this.isDarkMode = false,
    required this.onThemeChanged,
  });

  @override
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(); // 👈 обязательно
  int _currentIndex = 0;
  Timer? _timer;

  final List<String> imgList = [
    'assets/images/blur-shopping-mall.jpg',
    'assets/images/abstract-blur-shopping-mall.jpg',
    'assets/images/chris-reyem-oJoeGnj8OMM-unsplash.jpg',
    'assets/images/Screenshot-2024-11-25-124157.jpg',
  ];
  @override
  void initState() {
    super.initState();
    _startAutoPlayTimer();
    // Запускаем таймер автоплея
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (!_pageController.hasClients) return;

      int currentPage = _pageController.page?.round() ?? 0;
      int nextPage = (currentPage + 1) % imgList.length;

      print('Автоплей: текущая страница $currentPage, следующая $nextPage');

      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _startAutoPlayTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_pageController.hasClients) return;

      int nextPage = (_pageController.page?.round() ?? 0) + 1;
      if (nextPage >= imgList.length) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var path in imgList) {
      precacheImage(AssetImage(path), context); // ✅ теперь context доступен
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          _timer?.cancel();
        } else {
          _startAutoPlayTimer();
        }
      },
      appBar: AppBar(
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'FashApp',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
            color: Colors.white,
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('GT'),
              accountEmail: Text('annamurikannamurikow@gmail.com'),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Home'),
                leading: Icon(
                  Icons.home,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('My account'),
                leading: Icon(Icons.person, color: Colors.red),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('My orders'),
                leading: Icon(
                  Icons.shopping_basket,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Categories'),
                leading: Icon(Icons.dashboard, color: Colors.red),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Favourites'),
                leading: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('About'),
                leading: Icon(
                  Icons.help,
                  color: Colors.green,
                ),
              ),
            ),

            // Переключатель темы:
            const Divider(),
            ListTile(
              title: const Text('Темная тема'),
              trailing: Switch(
                value: widget.isDarkMode,
                onChanged: (value) {
                  widget.onThemeChanged(value);
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Слайдер баннеров
            SizedBox(
              height:
                  MediaQuery.of(context).size.width * 0.5, // вместо height: 200
              child: PageView.builder(
                controller: _pageController,
                itemCount: imgList.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  // Сброс и запуск автоплея при ручном свайпе
                  _timer?.cancel();
                  _startAutoPlayTimer();
                },
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imgList[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        gaplessPlayback: true,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SmoothPageIndicator(
              controller: _pageController,
              count: imgList.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.red,
                dotColor: Colors.grey,
              ),
              onDotClicked: (index) {
                _pageController.animateToPage(
                  index,
                  duration:
                      const Duration(milliseconds: 400), // плавный переход
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
