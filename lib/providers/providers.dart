import 'package:flutter/foundation.dart';

import '../data/models/models.dart';
import '../data/services/api_client.dart';
import '../data/services/api_services.dart';

/// Estado de autenticación (equivalente a AuthViewModel + AuthStateManager).
class AuthProvider extends ChangeNotifier {
  final AuthService authService;
  final TokenManager tokenManager;

  AuthProvider({required this.authService, required this.tokenManager});

  bool isLoading = false;
  String? error;
  int? userId;
  String? email;
  bool isLoggedIn = false;

  Future<void> checkSession() async {
    isLoggedIn = await tokenManager.isLoggedIn();
    userId = await tokenManager.getUserId();
    email = await tokenManager.getEmail();
    notifyListeners();
  }

  Future<bool> signIn(String username, String password) async {
    return _authenticate(() =>
        authService.signIn(SignInRequest(username: username, password: password)),
        username);
  }

  Future<bool> signUp(String username, String password) async {
    return _authenticate(() =>
        authService.signUp(SignUpRequest(username: username, password: password)),
        username);
  }

  Future<bool> _authenticate(
      Future<AuthResponse> Function() call, String username) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final res = await call();
      await tokenManager.saveSession(res.id, res.token, username);
      userId = res.id;
      email = username;
      isLoggedIn = true;
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await tokenManager.clear();
    isLoggedIn = false;
    userId = null;
    email = null;
    notifyListeners();
  }
}

/// Estado de vehículos (equivalente a HomeViewModel / GarageViewModel).
class VehicleProvider extends ChangeNotifier {
  final VehicleService vehicleService;
  VehicleProvider({required this.vehicleService});

  bool isLoading = false;
  String? error;
  List<Vehicle> vehicles = [];
  String? typeFilter; // scooter | bike | motorcycle | null (todos)

  List<Vehicle> get filtered => typeFilter == null
      ? vehicles
      : vehicles
          .where((v) => v.type.toLowerCase() == typeFilter)
          .toList();

  Future<void> loadVehicles() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      vehicles = await vehicleService.getAllVehicles();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String? type) {
    typeFilter = type;
    notifyListeners();
  }
}

/// Estado de reservas (equivalente a BookingRepository + ViewModels de trips).
class BookingProvider extends ChangeNotifier {
  final BookingService bookingService;
  BookingProvider({required this.bookingService});

  bool isLoading = false;
  String? error;
  List<Booking> bookings = [];

  Future<void> loadUserBookings(int userId) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final page = await bookingService.getBookingsByUserId(userId);
      bookings = page.content;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Booking?> createBooking(CreateBookingRequest request) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final booking = await bookingService.createBooking(request);
      bookings.insert(0, booking);
      return booking;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelBooking(int bookingId) async {
    try {
      final updated = await bookingService.cancelBooking(bookingId);
      final index = bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index != -1) bookings[index] = updated;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Marca una reserva localmente como 'realizado'.
  /// No depende del backend en este cambio mínimo.
  Future<bool> markBookingAsRealizado(int bookingId) async {
    try {
      final index = bookings.indexWhere((b) => b.bookingId == bookingId);
      if (index == -1) return false;
      final b = bookings[index];
      final updated = Booking(
        bookingId: b.bookingId,
        userId: b.userId,
        vehicleId: b.vehicleId,
        reservedAt: b.reservedAt,
        startDate: b.startDate,
        endDate: b.endDate,
        actualStartDate: b.actualStartDate,
        actualEndDate: b.actualEndDate,
        status: 'realizado',
        totalCost: b.totalCost,
        discount: b.discount,
        finalCost: b.finalCost,
        paymentMethod: b.paymentMethod,
        paymentStatus: b.paymentStatus,
        distance: b.distance,
        duration: b.duration,
        rating: b.rating,
      );
      bookings[index] = updated;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
