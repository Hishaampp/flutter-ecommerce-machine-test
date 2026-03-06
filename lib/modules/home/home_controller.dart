import 'package:get/get.dart';
import '../../models/banner_model.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../services/api_service.dart';
import '../auth/auth_controller.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthController _authController = Get.find<AuthController>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedIndex = 0.obs;

  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<ProductModel> newArrivals = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // If user already exists (e.g., from SharedPreferences), fetch immediately
    if (_authController.currentUser.value != null) {
      fetchHome();
    }

    // Listen for login updates
    ever(_authController.currentUser, (user) {
      if (user != null) {
        fetchHome();
      }
    });
  }

  Future<void> fetchHome() async {
    final user = _authController.currentUser.value;

    if (user == null) {
      print("User is null, skipping API call");
      return;
    }

    print("HOME API -> ID: ${user.id}");
    print("HOME API -> TOKEN: ${user.token}");

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.getHome(
        userId: user.id,
        token: user.token,
      );

      if (response['success'] == 1) {
        final banner1List = response['banner1'] as List? ?? [];
        final banner2List = response['banner2'] as List? ?? [];

        banners.value = [
          ...banner1List.map((e) => BannerModel.fromJson(e)),
          ...banner2List.map((e) => BannerModel.fromJson(e)),
        ];

        final categoryList = response['categories'] as List? ?? [];
        categories.value =
            categoryList.map((e) => CategoryModel.fromJson(e)).toList();

        final newArrivalList = response['newarrivals'] as List? ?? [];
        newArrivals.value =
            newArrivalList.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to load home.';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print("HOME API ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onNavTap(int index) {
    selectedIndex.value = index;
    if (index == 1) {
      Get.toNamed('/products');
    }
  }
}