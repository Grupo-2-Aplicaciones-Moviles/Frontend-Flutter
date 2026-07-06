/// Constantes de WeRide — espejo de Constants.kt del front Android.
class AppConstants {
  AppConstants._();

  // API Configuration
  // Emulador Android: 10.0.2.2 | Dispositivo físico: IP local de tu PC
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  static const Duration connectTimeout = Duration(seconds: 30);

  static const String termsAndConditionsUrl =
      'https://www.freeprivacypolicy.com/live/91f9ef49-9bfd-412d-b6b1-5bb97c0f7455';

  // Preferences Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyIsLoggedIn = 'is_logged_in';

  // Vehicle Types
  static const String vehicleScooter = 'scooter';
  static const String vehicleBike = 'bike';
  static const String vehicleMotorcycle = 'motorcycle';

  // Booking Status
  static const String statusDraft = 'draft';
  static const String statusConfirmed = 'confirmed';
  static const String statusActive = 'active';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // Payment Methods
  static const String paymentWallet = 'WALLET';
  static const String paymentCard = 'CARD';
  static const String paymentYape = 'YAPE';
  static const String paymentPlin = 'PLIN';

  // Reservation
  static const int reservationTimeMinutes = 15;

  static String statusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case statusDraft:
        return 'Borrador';
      case statusConfirmed:
        return 'Confirmada';
      case statusActive:
        return 'En curso';
      case statusCompleted:
        return 'Completada';
      case statusCancelled:
        return 'Cancelada';
      default:
        return status;
    }
  }

  static String typeDisplayName(String type) {
    switch (type.toLowerCase()) {
      case vehicleScooter:
        return 'Scooter';
      case vehicleBike:
        return 'Bicicleta';
      case vehicleMotorcycle:
        return 'Motocicleta';
      default:
        return type;
    }
  }
}
