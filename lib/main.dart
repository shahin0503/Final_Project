import 'package:blogapp/constants/routes.dart';
import 'package:blogapp/services/auth/auth_service.dart';
import 'package:blogapp/views/blog/add_blog_view.dart';
import 'package:blogapp/views/blog/blog_detail_view.dart';
import 'package:blogapp/views/portfolio/my_profile.dart';
import 'package:blogapp/views/dashboard_view.dart';
import 'package:blogapp/views/auth/login_view.dart';
import 'package:blogapp/views/auth/registeration_view.dart';
import 'package:blogapp/views/auth/verify_email_view.dart';
import 'package:blogapp/views/portfolio/portfolio_detail_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch()),
      home: const MyHomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const Registerview(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        dashboardRoute: (context) => const DashboardView(),
        profileRoute: (context) => MyProfile(),
        portfolioDetailRoute: (context) => const PortfolioDetailView(),
        addBlogRoute: (context) => const AddBlogView(),
        blogDetailRoute: (context) => const BlogDetailView(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const DashboardView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
