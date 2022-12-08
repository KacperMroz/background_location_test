import 'package:backk_location_test/page/locator/cubit/locator_cubit.dart';
import 'package:backk_location_test/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'location_content_column.dart';

class BackgroundLocatorView extends StatefulWidget {
  const BackgroundLocatorView({Key? key}) : super(key: key);

  @override
  State<BackgroundLocatorView> createState() => _BackgroundLocatorViewState();
}

class _BackgroundLocatorViewState extends State<BackgroundLocatorView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocatorCubit, LocatorState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: state.status == LocatorStatus.success
                  ? LocationContentColumn(
                      motionActivity: state.motionActivity,
                      odometer: state.odometer,
                      content: state.content,
                      isInSpecificArea: state.isInSpecificArea,
                      latitude: state.latitude,
                      longitude: state.longitude,
                      speed: state.speed,
                      uuid: state.uuid,
                      imei: state.imei,
                    )
                  : const SizedBox(
                      height: 200,
                      child: Center(
                        child: SizedBox(
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
