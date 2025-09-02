import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:gphfinance/create%20invoice/create_invoices.dart';
import 'package:gphfinance/book/stream_books.dart';
import 'package:gphfinance/stream_invoices.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  int _currentPageIndex = 0; // For bottom navigation

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      bottomNavigationBar: isMobile ? _buildBottomNavigationBar() : null,
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SideMenu(
          controller: sideMenu,
          style: SideMenuStyle(
            displayMode: SideMenuDisplayMode.auto,
            showHamburger: true,
            hoverColor: Colors.blue[100],
            selectedHoverColor: Colors.blue[100],
            selectedColor: Colors.lightBlue,
            selectedTitleTextStyle: const TextStyle(color: Colors.white),
            selectedIconColor: Colors.white,
            selectedTitleTextStyleExpandable:
                const TextStyle(color: Colors.lightBlue),
          ),
          footer: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'CV Gubuk Pustaka Harmoni',
              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
            ),
          ),
          items: <SideMenuItemType>[
            SideMenuItem(
              title: 'Data Transaksi Buku',
              onTap: (index, _) {
                sideMenu.changePage(index);
              },
              icon: const Icon(Icons.table_view_rounded),
              tooltipContent: "This is a tooltip for Dashboard item",
            ),
            SideMenuItem(
              title: 'Data Buku',
              onTap: (index, _) {
                sideMenu.changePage(index);
              },
              icon: const Icon(Icons.book),
            ),
            SideMenuItem(
              title: 'Create Transaction',
              onTap: (index, _) {
                sideMenu.changePage(index);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const VerticalDivider(
          width: 0,
        ),
        Expanded(
          child: PageView(
            controller: pageController,
            children: [
              InvoicesTableStream(),
              BookTableStream(),
              CreateInvoices(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    // For mobile, we show only the current page based on bottom nav index
    return _getPageForIndex(_currentPageIndex);
  }

  Widget _getPageForIndex(int index) {
    switch (index) {
      case 0:
        return InvoicesTableStream();
      case 1:
        return BookTableStream();
      case 2:
        return CreateInvoices();
      default:
        return InvoicesTableStream();
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentPageIndex,
      onTap: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.table_view_rounded),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Books',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Create',
        ),
      ],
    );
  }
}