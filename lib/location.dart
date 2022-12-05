import 'package:backk_location_test/navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationState();
}

class _LocationState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokalizator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                'Wybierz swój region',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black
              ),
            ),
            _LocationDropdownButton(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              onPressed: _onGoToHomePressed,
              child: Text('Kontynuuj'),
            ),
          ],
        ),
      )
    );
  }

  void _onGoToHomePressed() => GoRouter.of(context).go(Navigation.home);
}

class _LocationDropdownButton extends StatefulWidget {
  const _LocationDropdownButton({Key? key}) : super(key: key);

  @override
  _LocationDropdownButtonState createState() => _LocationDropdownButtonState();
}

class _LocationDropdownButtonState extends State<_LocationDropdownButton> {
  String dropdownValue = ' ';

  final items = [
    'Słonińskiego, Wrocław',
    'Słonińskiego1, Wrocław',
    'Słonińskiego2, Wrocław',
    'Słonińskiego3, Wrocław',
    'Słonińskiego4, Wrocław',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.black12,
      ),
      width: 250,
      height: 44,
      child: DropdownButtonFormField(
          isExpanded: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.location_on,
              size: 20,
              color: Colors.black,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          }),
    );
  }
}
