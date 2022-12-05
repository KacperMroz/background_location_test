import 'package:backk_location_test/navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        title: Text('Lokalizator'),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          child: Card(
            elevation: 5,
            color: Colors.grey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 10,),
                  Icon(Icons.location_on, size: 60,),
                  SizedBox(height: 10,),
                  Text(
                    'Aplikacja pobiera lokalizacje użytkownika',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                      onPressed: _onGoToLocationPressed,
                      child: Text('Kontynuuj'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onGoToLocationPressed() => GoRouter.of(context).go(Navigation.location);
}
