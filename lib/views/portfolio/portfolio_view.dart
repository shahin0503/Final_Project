import 'package:blogapp/constants/routes.dart';
import 'package:flutter/material.dart';

class PortfolioView extends StatefulWidget {
  const PortfolioView({super.key});

  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed(addPortfolioRoute);
      },
      child: const Icon(Icons.add),
    );
  }
}
