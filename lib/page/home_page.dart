import 'package:backk_location_test/app/injection.dart';
import 'package:backk_location_test/navigation/navigation.dart';
import 'package:backk_location_test/page/locator/cubit/locator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/buttons/location_dropdown.dart';
import '../widgets/buttons/rounded_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _LocationState();
}

class _LocationState extends State<HomePage> {
  LocatorCubit _bloc = getIt.get<LocatorCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocatorCubit, LocatorState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LocationDropdownButton(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RoundedButton(
                  onPressed: _bloc.state.location == ''
                      ? _errorSnackBar
                      : _onGoToHomePressed,
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
      },
    );
  }

  void _onGoToHomePressed() => GoRouter.of(context).go(Navigation.location);

  void _errorSnackBar() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.fixed,
          duration: Duration(seconds: 2),
          content: Text('Wybierz lokalizacje'),
        ),
      );
  }
}
