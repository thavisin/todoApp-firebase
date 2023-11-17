import 'const/const.dart';

class Navbarhome extends StatefulWidget {
  const Navbarhome({super.key});

  @override
  State<Navbarhome> createState() => _NavbarhomeState();
}

class _NavbarhomeState extends State<Navbarhome> {
  PageController _pageController = new PageController();
  List<Widget> _screens = [Homepage(), Addgoal()];

  int _selectedIndex = 0;
  void _onPagedChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: orenge1,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.note), label: ''),
          ]),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPagedChanged,
      ),
    );
  }
}
