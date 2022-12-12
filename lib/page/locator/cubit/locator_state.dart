part of 'locator_cubit.dart';

enum LocatorStatus {
  initial,
  loading,
  success,
  failure,
}

class LocatorState extends Equatable {
  const LocatorState({
    this.status = LocatorStatus.initial,
    String? motionActivity,
    String? odometer,
    String? content,
    bool? isInSpecificArea,
    double? latitude,
    double? longitude,
    double? speed,
    String? uuid,
    String? imei,
    String? location,
  })  : motionActivity = motionActivity ?? '- brak',
        content = content ?? '',
        odometer = odometer ?? '0',
        isInSpecificArea = isInSpecificArea ?? false,
        latitude = latitude ?? 0,
        longitude = longitude ?? 0,
        speed = speed ?? 0,
        uuid = uuid ?? '',
        imei = imei ?? '',
        location = location ?? '';

  final LocatorStatus status;
  final String? motionActivity;
  final String? odometer;
  final String? content;
  final bool? isInSpecificArea;
  final double? latitude;
  final double? longitude;
  final double? speed;
  final String? uuid;
  final String? imei;
  final String? location;

  LocatorState copyWith({
    LocatorStatus? status,
    String? motionActivity,
    String? odometer,
    String? content,
    bool? isInSpecificArea,
    double? latitude,
    double? longitude,
    double? speed,
    String? uuid,
    String? imei,
    String? location,
  }) {
    return LocatorState(
      status: status ?? this.status,
      motionActivity: motionActivity ?? this.motionActivity,
      odometer: odometer ?? this.odometer,
      content: content ?? this.content,
      isInSpecificArea: isInSpecificArea ?? this.isInSpecificArea,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      uuid: uuid ?? this.uuid,
      imei: imei ?? this.imei,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [
        status,
        motionActivity,
        odometer,
        content,
        isInSpecificArea,
        latitude,
        longitude,
        speed,
        uuid,
        imei,
        location,
      ];
}
