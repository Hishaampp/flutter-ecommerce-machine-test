import 'package:codeedex_flutter_test/modules/products/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_list_tile.dart';
import '../../widgets/error_view.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.find<ProductsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Products', style: AppTextStyles.heading2.copyWith(color: AppColors.white)),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              controller.isGridView.value ? Icons.list : Icons.grid_view,
              color: AppColors.white,
            ),
            onPressed: controller.toggleView,
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.errorMessage.value.isNotEmpty && controller.products.isEmpty) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchProducts,
          );
        }

        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.grey),
                const SizedBox(height: 16),
                Text('No products found', style: AppTextStyles.body.copyWith(color: AppColors.grey)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchProducts,
          color: AppColors.primary,
          child: controller.isGridView.value
              ? _buildGridView(controller)
              : _buildListView(controller),
        );
      }),
    );
  }

  Widget _buildGridView(ProductsController controller) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: controller.products[index]);
      },
    );
  }

  Widget _buildListView(ProductsController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        return ProductListTile(product: controller.products[index]);
      },
    );
  }
}