import 'package:backk_location_test/page/locator/cubit/locator_cubit.dart';
import 'package:backk_location_test/page/locator/views/background_locator_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/navigation.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/background_view.dart';
import '../../../widgets/custom_app_bar.dart';

class BackgroundLocatorPage extends StatelessWidget {
  const BackgroundLocatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocatorCubit()..initialize(),
      child: MaterialApp(
        home: Scaffold(
          body: GradientBackgroundView(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            child: Scaffold(
                backgroundColor: AppColors.transparent,
                appBar: CustomAppBar(
                  label: 'Lokalizator',
                  brightness: 'dark',
                  onBackPressed: () => GoRouter.of(context).go(Navigation.home),
                  isMenuNeeded: false,
                ),
                body: const BackgroundLocatorView()),
          ),
        ),
      ),
    );
  }
}
