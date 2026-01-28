import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guardian_app/providers/home_screen_provider.dart';
import 'package:guardian_app/widgets/dashboard_stats_grid.dart';
import 'package:guardian_app/widgets/renewal_status_card.dart';
import 'package:guardian_app/screens/record_book_screen.dart';
import 'package:guardian_app/screens/registry_screen.dart';

class HomeScreen extends StatefulWidget {
  // FIX: Use const and super parameters
  const HomeScreen({super.key});

  @override
  // FIX: Made state class public
  HomeScreenState createState() => HomeScreenState();
}

// FIX: Made state class public
class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<HomeScreenProvider>(context, listen: false).fetchDashboardData();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, child) {
        final dashboardData = provider.dashboardData;

        return Scaffold(
          appBar: AppBar(
            title: Text(dashboardData?.meta.welcomeMessage ?? 'لوحة التحكم'),
            centerTitle: true,
            actions: [
              // FIX: Added const
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
            ],
          ),
          body: provider.isLoading && dashboardData == null
              ? const Center(child: CircularProgressIndicator())
              : provider.errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('حدث خطأ أثناء تحميل البيانات.', textAlign: TextAlign.center, style: theme.textTheme.titleLarge?.copyWith(color: Colors.red)),
                            const SizedBox(height: 10),
                            const Text('يرجى التأكد من اتصالك بالانترنت والمحاولة مرة أخرى', textAlign: TextAlign.center),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => provider.fetchDashboardData(), 
                              icon: const Icon(Icons.refresh), 
                              label: const Text("إعادة المحاولة")
                            ),
                          ],
                        ),
                      ),
                    )
                  : NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (dashboardData != null) ...[
                                    Text(dashboardData.meta.dateGregorian, style: theme.textTheme.bodyMedium),
                                    Text(dashboardData.meta.dateHijri, style: theme.textTheme.bodyMedium),
                                    const SizedBox(height: 20),
                                    DashboardStatsGrid(stats: dashboardData.stats),
                                    const SizedBox(height: 20),
                                    Text("حالة التجديد", style: theme.textTheme.titleLarge),
                                    const SizedBox(height: 10),
                                    RenewalStatusCard(status: dashboardData.statusSummary.license, title: 'رخصة الأمين'),
                                    const SizedBox(height: 10),
                                    RenewalStatusCard(status: dashboardData.statusSummary.card, title: 'بطاقة الأمين'),
                                  ]
                                ],
                              ),
                            ),
                          ),
                          // FIX: Added const
                          SliverPersistentHeader(delegate: SliverTabBarDelegate(TabBar(controller: _tabController, labelStyle: theme.textTheme.titleMedium, tabs: const [Tab(text: 'الرئيسية'), Tab(text: 'سجلاتي'), Tab(text: 'القيد')])), pinned: true),
                        ];
                      },
                      body: TabBarView(
                        controller: _tabController,
                        // FIX: Added const
                        children: const [
                          Center(child: Text("الأنشطة الأخيرة (قريباً)")),
                          RecordBookScreen(),
                          RegistryScreen(),
                        ],
                      ),
                    ),
          // FIX: Added const
          floatingActionButton: FloatingActionButton(onPressed: () {}, tooltip: 'إضافة قيد جديد', child: const Icon(Icons.add)),
        );
      },
    );
  }
}

// FIX: Made class public
class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  const SliverTabBarDelegate(this.tabBar);
  final TabBar tabBar;
  @override double get minExtent => tabBar.preferredSize.height;
  @override double get maxExtent => tabBar.preferredSize.height;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => Container(color: Theme.of(context).scaffoldBackgroundColor, child: tabBar,);
  @override bool shouldRebuild(SliverTabBarDelegate oldDelegate) => false;
}
