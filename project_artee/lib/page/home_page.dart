import 'package:flutter/material.dart';
import 'package:project_artee/page/cancel_order_page.dart';
import 'package:project_artee/page/confirm_payment_page.dart';
import 'package:project_artee/page/detail_order_page.dart';
import 'package:project_artee/page/generate_qr_page.dart';
import 'package:project_artee/page/login_page.dart';
import 'package:project_artee/page/logout_page.dart';
import 'package:project_artee/page/menu_table_page.dart';
import 'package:project_artee/page/serve_order_page.dart';
import 'package:project_artee/page/staff_page.dart';
import 'menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<String> _tabTitles = [
    "หน้าหลัก",
    "เมนู",
    "QR Code",
    "โปรไฟล์",
    "ออเดอร์",
    "เสิร์ฟ",
    "ยกเลิก",
    "ชำระเงิน",
    "Logout",
  ];

  final List<IconData> _tabIcons = [
    Icons.home,
    Icons.fastfood,
    Icons.qr_code,
    Icons.person,
    Icons.fastfood,
    Icons.restaurant,
    Icons.cancel,
    Icons.payment,
    Icons.logout,
  ];

  final List<Widget> _pages = const [
    MenuTablePage(),
    MenuPage(),
    GenerateQrPage(),
    StaffPage(),
    DetailOrderPage(),
    ServeOrderPage(),
    CancelOrderPage(),
    PaymentPage(),
    LogoutPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    const Color primaryGreen = Color(0xFF4CAF50);
    const Color secondaryOrange = Color(0xFFFF9800);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.orange[50]?.withOpacity(0.9),
        elevation: 2,
        title: const AnimatedTitle(),
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryGreen),
        bottom:
            isDesktop
                ? null
                : TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: secondaryOrange,
                  labelColor: secondaryOrange,
                  unselectedLabelColor: primaryGreen.withOpacity(0.7),
                  tabs: List.generate(
                    _tabTitles.length,
                    (index) => Tab(
                      text: _tabTitles[index],
                      icon: Icon(_tabIcons[index]),
                    ),
                  ),
                ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFFFF3E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child:
              isDesktop
                  ? Row(
                    children: [
                      SizedBox(
                        width: 72,
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height,
                            ),
                            child: NavigationRail(
                              backgroundColor: Colors.white.withOpacity(0.95),
                              selectedIndex: _tabController.index,
                              onDestinationSelected: (index) {
                                setState(() {
                                  _tabController.index = index;
                                });
                              },
                              labelType: NavigationRailLabelType.all,
                              selectedIconTheme: const IconThemeData(
                                color: secondaryOrange,
                              ),
                              selectedLabelTextStyle: const TextStyle(
                                color: secondaryOrange,
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedIconTheme: const IconThemeData(
                                color: primaryGreen,
                              ),
                              destinations: List.generate(
                                _tabTitles.length,
                                (index) => NavigationRailDestination(
                                  icon: Icon(_tabIcons[index]),
                                  label: Text(_tabTitles[index]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(thickness: 1, width: 1),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TabBarView(
                            controller: _tabController,
                            children: _pages,
                          ),
                        ),
                      ),
                    ],
                  )
                  : Padding(
                    padding: const EdgeInsets.all(12),
                    child: TabBarView(
                      controller: _tabController,
                      children: _pages,
                    ),
                  ),
        ),
      ),
    );
  }
}

// ✅ Animated Shimmer + Scale + Fade
class AnimatedTitle extends StatefulWidget {
  const AnimatedTitle({super.key});

  @override
  State<AnimatedTitle> createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    // Scale + Fade
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Shimmer Loop
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FadeTransition(
        opacity: _fade,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: const [
                    Color(0xFF4CAF50),
                    Color(0xFFFF9800),
                    Color(0xFF4CAF50),
                  ],
                  stops: [
                    (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                    _shimmerController.value,
                    (_shimmerController.value + 0.3).clamp(0.0, 1.0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const Text(
                "Atree Restaurant",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  letterSpacing: 1.2,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
