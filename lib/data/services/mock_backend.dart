import '../models/models.dart';

/// Backend simulado en memoria para el MODO DEMO (sin servidor).
/// Mantiene el estado durante la sesión: las reservas creadas
/// aparecen en el historial y se pueden cancelar.
class MockBackend {
  MockBackend._();
  static final MockBackend instance = MockBackend._();

  int _nextBookingId = 1000;
  final List<Booking> _bookings = [];

  static final List<Vehicle> _vehicles = [
    const Vehicle(
      id: '1',
      brand: 'Xiaomi',
      model: 'Mi Pro 2',
      year: 2024,
      battery: 92,
      maxSpeed: 25,
      range: 45,
      weight: 14.2,
      color: 'Negro',
      licensePlate: 'SCT-101',
      location: 'Parque Kennedy, Miraflores',
      status: 'available',
      type: 'scooter',
      companyId: '1',
      pricePerMinute: 0.50,
      features: ['Luces LED', 'Frenos de disco', 'App integrada'],
      rating: 4.7,
      totalKilometers: 1243.5,
    ),
    const Vehicle(
      id: '2',
      brand: 'Segway',
      model: 'Ninebot Max',
      year: 2025,
      battery: 78,
      maxSpeed: 30,
      range: 65,
      weight: 18.7,
      color: 'Gris',
      licensePlate: 'SCT-102',
      location: 'Larcomar, Miraflores',
      status: 'available',
      type: 'scooter',
      companyId: '1',
      pricePerMinute: 0.60,
      features: ['Autonomía extendida', 'Suspensión delantera'],
      rating: 4.9,
      totalKilometers: 987.6,
    ),
    const Vehicle(
      id: '3',
      brand: 'Trek',
      model: 'FX 3 Disc',
      year: 2024,
      battery: 100,
      maxSpeed: 32,
      range: 80,
      weight: 11.5,
      color: 'Azul',
      licensePlate: 'BIC-201',
      location: 'Parque El Olivar, San Isidro',
      status: 'available',
      type: 'bike',
      companyId: '2',
      pricePerMinute: 0.40,
      features: ['Cambios Shimano', 'Canasta frontal'],
      rating: 4.5,
      totalKilometers: 2105.0,
    ),
    const Vehicle(
      id: '4',
      brand: 'Giant',
      model: 'Escape 3 E+',
      year: 2025,
      battery: 55,
      maxSpeed: 28,
      range: 50,
      weight: 19.3,
      color: 'Verde',
      licensePlate: 'BIC-202',
      location: 'Plaza San Miguel',
      status: 'available',
      type: 'bike',
      companyId: '2',
      pricePerMinute: 0.45,
      rating: 4.3,
      totalKilometers: 654.2,
    ),
    const Vehicle(
      id: '5',
      brand: 'NIU',
      model: 'NQi GT',
      year: 2025,
      battery: 88,
      maxSpeed: 70,
      range: 100,
      weight: 96.0,
      color: 'Blanco',
      licensePlate: 'MOT-301',
      location: 'Av. Javier Prado, San Borja',
      status: 'available',
      type: 'motorcycle',
      companyId: '3',
      pricePerMinute: 1.20,
      features: ['Casco incluido', 'Baúl trasero', 'GPS'],
      rating: 4.8,
      totalKilometers: 3480.9,
    ),
    const Vehicle(
      id: '6',
      brand: 'Xiaomi',
      model: 'M365',
      year: 2023,
      battery: 15,
      maxSpeed: 25,
      range: 30,
      weight: 12.5,
      color: 'Negro',
      licensePlate: 'SCT-103',
      location: 'Estación Metropolitano, Barranco',
      status: 'in_use',
      type: 'scooter',
      companyId: '1',
      pricePerMinute: 0.50,
      rating: 4.1,
      totalKilometers: 1876.3,
    ),
  ];

  static const _latency = Duration(milliseconds: 500);

  Future<AuthResponse> signIn(String username, String password) async {
    await Future.delayed(_latency);
    return const AuthResponse(id: 1, token: 'mock-jwt-token-demo');
  }

  Future<AuthResponse> signUp(String username, String password) async {
    await Future.delayed(_latency);
    return const AuthResponse(id: 1, token: 'mock-jwt-token-demo');
  }

  Future<List<Vehicle>> getVehicles() async {
    await Future.delayed(_latency);
    return List.unmodifiable(_vehicles);
  }

  Future<Vehicle> getVehicleById(String id) async {
    await Future.delayed(_latency);
    return _vehicles.firstWhere((v) => v.id == id,
        orElse: () => _vehicles.first);
  }

  Future<Booking> createBooking(CreateBookingRequest request) async {
    await Future.delayed(_latency);
    final booking = Booking(
      bookingId: _nextBookingId++,
      userId: request.userId,
      vehicleId: request.vehicleId,
      startDate: request.startDate,
      endDate: request.endDate,
      status: request.status.toLowerCase(),
      paymentMethod: request.paymentMethod,
      paymentStatus: request.paymentStatus,
      totalCost: _estimateCost(request),
      finalCost: _estimateCost(request),
    );
    _bookings.insert(0, booking);
    return booking;
  }

  double _estimateCost(CreateBookingRequest request) {
    final start = DateTime.tryParse(request.startDate);
    final end = DateTime.tryParse(request.endDate);
    final minutes = (start != null && end != null)
        ? end.difference(start).inMinutes
        : 30;
    final vehicle = _vehicles.firstWhere(
        (v) => v.id == request.vehicleId.toString(),
        orElse: () => _vehicles.first);
    return vehicle.pricePerMinute * minutes;
  }

  Future<PageResponse<Booking>> getBookingsByUser(int userId) async {
    await Future.delayed(_latency);
    final list = _bookings.where((b) => b.userId == userId).toList();
    return PageResponse(
      content: list,
      totalElements: list.length,
      totalPages: 1,
      number: 0,
      last: true,
    );
  }

  Future<Booking> cancelBooking(int bookingId) async {
    await Future.delayed(_latency);
    final index = _bookings.indexWhere((b) => b.bookingId == bookingId);
    if (index == -1) {
      throw Exception('Reserva no encontrada');
    }
    final b = _bookings[index];
    final cancelled = Booking(
      bookingId: b.bookingId,
      userId: b.userId,
      vehicleId: b.vehicleId,
      startDate: b.startDate,
      endDate: b.endDate,
      status: 'cancelled',
      paymentMethod: b.paymentMethod,
      paymentStatus: b.paymentStatus,
      totalCost: b.totalCost,
      finalCost: b.finalCost,
    );
    _bookings[index] = cancelled;
    return cancelled;
  }
}
