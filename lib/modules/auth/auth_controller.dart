import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(AppConstants.keyUserId);
    final token = prefs.getString(AppConstants.keyToken);
    if (id != null && token != null) {
      currentUser.value = UserModel(id: id, token: token);
      Get.offAllNamed('/home');
    }
  }

  Future<void> login({
    required String emailPhone,
    required String password,
  }) async {
    if (emailPhone.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please enter email and password.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.login(
        emailPhone: emailPhone,
        password: password,
      );

      if (response['success'] == 1 || response['status'] == true) {
        final user = UserModel.fromJson(response['customerdata']);
        currentUser.value = user;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.keyUserId, user.id);
        await prefs.setString(AppConstants.keyToken, user.token);

        Get.offAllNamed('/home');
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Invalid credentials.';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUser.value = null;
    Get.offAllNamed('/login');
  }
}