import 'package:backk_location_test/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/buttons/location_dropdown.dart';
import '../widgets/buttons/rounded_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _LocationState();
}

class _LocationState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LocationDropdownButton(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: RoundedButton(
              onPressed: _onGoToHomePressed,
              label: 'Kontynuuj',
            ),
          ),
        ]
            .expand(
              (element) => [
                element,
                const SizedBox(
                  height: 15,
                ),
              ],
            )
            .toList(),
      ),
    ));
  }

  void _onGoToHomePressed() => GoRouter.of(context).go(Navigation.location);
}
