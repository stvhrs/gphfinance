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

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              // showTooltip: false,
              displayMode: SideMenuDisplayMode.auto,
              showHamburger: true,
              hoverColor: Colors.blue[100],
              selectedHoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              selectedTitleTextStyleExpandable:
                  const TextStyle(color: Colors.lightBlue),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(10)),
              // ),
              // backgroundColor: Colors.grey[200]
            ),
            // title: Column(
            //   children: [
            //     ConstrainedBox(
            //         constraints: const BoxConstraints(
            //           maxHeight: 150,
            //           maxWidth: 150,
            //         ),
            //         child: CircleAvatar()),
            //     const Divider(
            //       indent: 8.0,
            //       endIndent: 8.0,
            //     ),
            //   ],
            // ),
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
      ),
    );
  }
}
