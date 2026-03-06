import 'package:get/get.dart';
import '../../models/product_model.dart';
import '../../services/api_service.dart';
import '../auth/auth_controller.dart';

class ProductsController extends GetxController {
  final ApiService _apiService = ApiService();
  final AuthController _authController = Get.find<AuthController>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isGridView = true.obs;

  @override
  void onInit() {
    super.onInit();

    if (_authController.currentUser.value != null) {
      fetchProducts();
    }

    ever(_authController.currentUser, (user) {
      if (user != null) {
        fetchProducts();
      }
    });
  }

  Future<void> fetchProducts() async {
  final user = _authController.currentUser.value;

  if (user == null) return;

  isLoading.value = true;
  errorMessage.value = '';

  try {
    final response = await _apiService.getProducts(
      userId: user.id,
      token: user.token,
    );

    final productsMap = response['products'];
    final returnMap = productsMap?['return'];
    final List productList = returnMap?['data'] ?? [];

    products.value =
        productList.map((e) => ProductModel.fromJson(e)).toList();

    if (products.isEmpty) {
      errorMessage.value = 'No products found.';
    }
  } catch (e) {
    errorMessage.value = e.toString();
    print("PRODUCT API ERROR: $e");
  } finally {
    isLoading.value = false;
  }
}

  void toggleView() {
    isGridView.value = !isGridView.value;
  }
}