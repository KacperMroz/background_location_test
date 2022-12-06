import 'package:backk_location_test/navigation/navigation.dart';
import 'package:backk_location_test/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/buttons/rounded_button.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lokalizator',
          style: AppTextStyles.toolbarLabel('dark'),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          child: Card(
            elevation: 5,
            color: Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 60,
                  ),
                  const Text(
                    'Aplikacja pobiera lokalizacje użytkownika',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: RoundedButton(
                      onPressed: _onGoToLocationPressed,
                      label: 'Kontynuuj',
                    ),
                  ),
                ]
                    .expand(
                      (element) => [
                        element,
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onGoToLocationPressed() => GoRouter.of(context).go(Navigation.home);
}
