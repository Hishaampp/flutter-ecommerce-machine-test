import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/category_item.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/error_view.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text('Shop', style: AppTextStyles.heading2.copyWith(color: AppColors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchHome,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchHome,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                if (controller.banners.isNotEmpty)
                  BannerSlider(banners: controller.banners),
                const SizedBox(height: 16),
                if (controller.categories.isNotEmpty) ...[
                  SectionHeader(
                    title: 'Categories',
                    onSeeAll: () => Get.toNamed('/products'),
                  ),
                  _buildCategories(controller),
                  const SizedBox(height: 16),
                ],
                if (controller.newArrivals.isNotEmpty) ...[
                  SectionHeader(
                    title: 'New Arrivals',
                    onSeeAll: () => Get.toNamed('/products'),
                  ),
                  _buildNewArrivals(controller),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.onNavTap,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      )),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: AppTextStyles.bodySmall,
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategories(HomeController controller) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          return CategoryItem(
            category: controller.categories[index],
            onTap: () => Get.toNamed('/products'),
          );
        },
      ),
    );
  }

  Widget _buildNewArrivals(HomeController controller) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.newArrivals.length,
        itemBuilder: (context, index) {
          return ProductCard(product: controller.newArrivals[index]);
        },
      ),
    );
  }
}