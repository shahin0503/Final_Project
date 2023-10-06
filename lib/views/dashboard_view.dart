import 'package:blogapp/constants/routes.dart';
import 'package:blogapp/services/auth/auth_service.dart';
import 'package:blogapp/utilities/auth/show_log_out_dialog.dart';
import 'package:blogapp/views/blog/blog_view.dart';
import 'package:blogapp/views/contact/contact_view.dart';
import 'package:blogapp/views/portfolio/portfolio_view.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final PageController pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  final List<String> _appBarTitles = ['Portfolio', 'Blogs', 'Contact Us'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        actions: [
          IconButton(
              onPressed: () async {
                final shouldLogout = await showLogOutDialog(context);

                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.details_outlined),
                label: 'Portfolio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.view_compact_outlined),
                label: 'Blogs',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_page_outlined),
                label: 'Contact',
              )
            ],
          ),
        ),
      ),
      body: _buildPage(_selectedIndex),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _buildPage(int index) {
    switch (index) {
      case 0:
        return const PortfolioView();

      case 1:
        return const BlogView();
      case 2:
        return ContactView();
      default:
        const Text('Invalid');
    }
  }
}
