import '../models/models.dart';
import 'api_client.dart';

/// Espejo de AuthApiService.kt
class AuthService {
  final ApiClient client;
  AuthService(this.client);

  Future<AuthResponse> signIn(SignInRequest request) async {
    final json = await client.post('/authentication/sign-in',
        body: request.toJson());
    return AuthResponse.fromJson(json as Map<String, dynamic>);
  }

  Future<AuthResponse> signUp(SignUpRequest request) async {
    final json = await client.post('/authentication/sign-up',
        body: request.toJson());
    return AuthResponse.fromJson(json as Map<String, dynamic>);
  }
}

/// Espejo de VehicleApiService.kt
class VehicleService {
  final ApiClient client;
  VehicleService(this.client);

  Future<List<Vehicle>> getAllVehicles() async {
    final json = await client.get('/vehicles');
    return ((json as List?) ?? [])
        .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Vehicle> getVehicleById(String id) async {
    final json = await client.get('/vehicles/$id');
    return Vehicle.fromJson(json as Map<String, dynamic>);
  }
}

/// Espejo de BookingApiService.kt
class BookingService {
  final ApiClient client;
  BookingService(this.client);

  Future<Booking> createBooking(CreateBookingRequest request) async {
    final json = await client.post('/bookings', body: request.toJson());
    return Booking.fromJson(json as Map<String, dynamic>);
  }

  Future<Booking> getBookingById(int id) async {
    final json = await client.get('/bookings/$id');
    return Booking.fromJson(json as Map<String, dynamic>);
  }

  Future<PageResponse<Booking>> getBookingsByUserId(int userId,
      {int page = 0, int size = 20}) async {
    final json = await client.get('/bookings/user/$userId',
        query: {'page': '$page', 'size': '$size'});
    return PageResponse.fromJson(
        json as Map<String, dynamic>, Booking.fromJson);
  }

  Future<PageResponse<Booking>> getPendingBookingsByUser(int userId,
      {int page = 0, int size = 20}) async {
    final json = await client.get('/bookings/user/$userId/pending',
        query: {'page': '$page', 'size': '$size'});
    return PageResponse.fromJson(
        json as Map<String, dynamic>, Booking.fromJson);
  }

  Future<PageResponse<Booking>> getCompletedBookingsByUser(int userId,
      {int page = 0, int size = 20}) async {
    final json = await client.get('/bookings/user/$userId/completed',
        query: {'page': '$page', 'size': '$size'});
    return PageResponse.fromJson(
        json as Map<String, dynamic>, Booking.fromJson);
  }

  Future<Booking> cancelBooking(int bookingId, {String? reason}) async {
    final json = await client.post('/bookings/$bookingId/cancel',
        body: {'reason': reason ?? 'Cancelado por el usuario'});
    return Booking.fromJson(json as Map<String, dynamic>);
  }

  Future<Booking> updateBookingStatus(int bookingId, String status) async {
    final json = await client
        .patch('/bookings/$bookingId/status', query: {'status': status});
    return Booking.fromJson(json as Map<String, dynamic>);
  }
}
