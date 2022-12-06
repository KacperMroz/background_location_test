import 'package:backk_location_test/page/locator/cubit/locator_cubit.dart';
import 'package:backk_location_test/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  ? _LocationContentColumn(
                      motionActivity: state.motionActivity,
                      odometer: state.odometer,
                      content: state.content,
                      isInSpecificArea: state.isInSpecificArea,
                      latitude: state.latitude,
                      longitude: state.longitude,
                      speed: state.speed,
                      uuid: state.uuid,
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

class _LocationContentColumn extends StatelessWidget {
  const _LocationContentColumn({
    required this.motionActivity,
    required this.odometer,
    required this.content,
    required this.isInSpecificArea,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.uuid,
    Key? key,
  }) : super(key: key);

  final String? motionActivity;
  final String? odometer;
  final String? content;
  final bool? isInSpecificArea;
  final double? latitude;
  final double? longitude;
  final double? speed;
  final String? uuid;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Jesteś w wyznaczonym miejscu: ${isInSpecificArea == true ? 'Tak' : 'Nie'}'),
        Text('Współrzędne: $latitude $longitude'),
        Text('Ostatnia prędkość: $speed'),
        Text('Id: $uuid'),
        Text('Aktywność ruchowa:$motionActivity '),
        Text('Przebyty dystans: $odometer km'),
      ]
          .expand(
            (element) => [
              element,
              const SizedBox(
                height: 13,
              ),
            ],
          )
          .toList(),
    );
  }
}
