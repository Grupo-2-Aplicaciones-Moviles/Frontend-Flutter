/// Modelos de WeRide — espejo de AuthModels.kt, VehicleModels.kt,
/// BookingModels.kt y PageResponse.kt del front Android.
library;

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

class SignInRequest {
  final String username;
  final String password;
  const SignInRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

class SignUpRequest {
  final String username;
  final String password;
  const SignUpRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

class AuthResponse {
  final int id;
  final String token;
  const AuthResponse({required this.id, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        id: (json['id'] as num).toInt(),
        token: json['token'] as String? ?? '',
      );
}

// ---------------------------------------------------------------------------
// Vehicle
// ---------------------------------------------------------------------------

class Vehicle {
  final String id;
  final String brand;
  final String model;
  final int year;
  final int battery;
  final int maxSpeed;
  final int range;
  final double weight;
  final String color;
  final String licensePlate;
  final String location;
  final String status;
  final String type;
  final String companyId;
  final double pricePerMinute;
  final String? image;
  final List<String>? features;
  final double? rating;
  final double? totalKilometers;

  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.battery,
    required this.maxSpeed,
    required this.range,
    required this.weight,
    required this.color,
    required this.licensePlate,
    required this.location,
    required this.status,
    required this.type,
    required this.companyId,
    required this.pricePerMinute,
    this.image,
    this.features,
    this.rating,
    this.totalKilometers,
  });

  bool get isAvailable => status.toLowerCase() == 'available';
  int get batteryPercent => battery.clamp(0, 100);
  String get displayName => '$brand $model';

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json['id']?.toString() ?? '',
        brand: json['brand'] as String? ?? '',
        model: json['model'] as String? ?? '',
        year: (json['year'] as num?)?.toInt() ?? 0,
        battery: (json['battery'] as num?)?.toInt() ?? 0,
        maxSpeed: (json['maxSpeed'] as num?)?.toInt() ?? 0,
        range: (json['range'] as num?)?.toInt() ?? 0,
        weight: (json['weight'] as num?)?.toDouble() ?? 0,
        color: json['color'] as String? ?? '',
        licensePlate: json['licensePlate'] as String? ?? '',
        location: json['location'] as String? ?? '',
        status: json['status'] as String? ?? '',
        type: json['type'] as String? ?? '',
        companyId: json['companyId']?.toString() ?? '',
        pricePerMinute: (json['pricePerMinute'] as num?)?.toDouble() ?? 0,
        image: json['image'] as String?,
        features: (json['features'] as List?)?.cast<String>(),
        rating: (json['rating'] as num?)?.toDouble(),
        totalKilometers: (json['totalKilometers'] as num?)?.toDouble(),
      );
}

// ---------------------------------------------------------------------------
// Booking
// ---------------------------------------------------------------------------

class RatingResource {
  final int? score;
  final String? comment;
  const RatingResource({this.score, this.comment});

  factory RatingResource.fromJson(Map<String, dynamic> json) =>
      RatingResource(
        score: (json['score'] as num?)?.toInt(),
        comment: json['comment'] as String?,
      );
}

class Booking {
  final int bookingId;
  final int userId;
  final int vehicleId;
  final String? reservedAt;
  final String? startDate;
  final String? endDate;
  final String? actualStartDate;
  final String? actualEndDate;
  final String status;
  final double? totalCost;
  final double? discount;
  final double? finalCost;
  final String? paymentMethod;
  final String? paymentStatus;
  final double? distance;
  final int? duration;
  final RatingResource? rating;

  const Booking({
    required this.bookingId,
    required this.userId,
    required this.vehicleId,
    this.reservedAt,
    this.startDate,
    this.endDate,
    this.actualStartDate,
    this.actualEndDate,
    required this.status,
    this.totalCost,
    this.discount,
    this.finalCost,
    this.paymentMethod,
    this.paymentStatus,
    this.distance,
    this.duration,
    this.rating,
  });

  bool get isActive => status.toLowerCase() == 'active';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        bookingId: (json['bookingId'] as num?)?.toInt() ??
            (json['id'] as num?)?.toInt() ??
            0,
        userId: (json['userId'] as num?)?.toInt() ?? 0,
        vehicleId: (json['vehicleId'] as num?)?.toInt() ?? 0,
        reservedAt: json['reservedAt'] as String?,
        startDate: json['startDate'] as String?,
        endDate: json['endDate'] as String?,
        actualStartDate: json['actualStartDate'] as String?,
        actualEndDate: json['actualEndDate'] as String?,
        status: json['status'] as String? ?? '',
        totalCost: (json['totalCost'] as num?)?.toDouble(),
        discount: (json['discount'] as num?)?.toDouble(),
        finalCost: (json['finalCost'] as num?)?.toDouble(),
        paymentMethod: json['paymentMethod'] as String?,
        paymentStatus: json['paymentStatus'] as String?,
        distance: (json['distance'] as num?)?.toDouble(),
        duration: (json['duration'] as num?)?.toInt(),
        rating: json['rating'] != null
            ? RatingResource.fromJson(json['rating'] as Map<String, dynamic>)
            : null,
      );
}

class CreateBookingRequest {
  final int userId;
  final int vehicleId;
  final String startDate; // ISO datetime
  final String endDate; // ISO datetime
  final String paymentMethod;
  final String paymentStatus;
  final String status;

  const CreateBookingRequest({
    required this.userId,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    this.paymentMethod = 'WALLET',
    this.paymentStatus = 'PENDING',
    this.status = 'DRAFT',
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'vehicleId': vehicleId,
        'startDate': startDate,
        'endDate': endDate,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'status': status,
      };
}

// ---------------------------------------------------------------------------
// Paginación (Spring Data Page)
// ---------------------------------------------------------------------------

class PageResponse<T> {
  final List<T> content;
  final int totalElements;
  final int totalPages;
  final int number;
  final bool last;

  const PageResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.number,
    required this.last,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) =>
      PageResponse(
        content: ((json['content'] as List?) ?? [])
            .map((e) => fromJsonT(e as Map<String, dynamic>))
            .toList(),
        totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
        totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
        number: (json['number'] as num?)?.toInt() ?? 0,
        last: json['last'] as bool? ?? true,
      );
}
