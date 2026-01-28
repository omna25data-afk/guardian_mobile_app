import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Placeholder screens for each tab
class MainTab extends StatelessWidget {
  const MainTab({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('الرئيسية', style: TextStyle(fontSize: 24)));
  }
}

class RecordsTab extends StatelessWidget {
  const RecordsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('سجلاتي', style: TextStyle(fontSize: 24)));
  }
}

class AddEntryTab extends StatelessWidget {
  const AddEntryTab({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('إضافة قيد', style: TextStyle(fontSize: 24)));
  }
}

class ToolsTab extends StatelessWidget {
  const ToolsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('الأدوات', style: TextStyle(fontSize: 24)));
  }
}

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('المزيد', style: TextStyle(fontSize: 24)));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MainTab(),
    RecordsTab(),
    AddEntryTab(),
    ToolsTab(),
    MoreTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('بوابة الأمين الشرعي'),
        titleTextStyle: GoogleFonts.tajawal(textStyle: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF006400),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'سجلاتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: 'إضافة قيد',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'الأدوات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'المزيد',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF006400),
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.tajawal(),
      ),
    );
  }
}
