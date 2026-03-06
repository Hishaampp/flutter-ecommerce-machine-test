import 'package:flutter/material.dart';
import '../models/banner_model.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerModel> banners;

  const BannerSlider({super.key, required this.banners});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String getBannerUrl(BannerModel banner) {
    if (banner.mobileImage.isNotEmpty) {
      return "${AppConstants.imageBaseUrl}/storage/banner/${banner.mobileImage}";
    }

    if (banner.image.isNotEmpty) {
      return "${AppConstants.imageBaseUrl}/storage/banner/${banner.image}";
    }

    return '';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return _buildBannerItem(banner);
            },
          ),
        ),

        if (widget.banners.length > 1) ...[
          const SizedBox(height: 8),
          _buildDots(),
        ]
      ],
    );
  }

  Widget _buildBannerItem(BannerModel banner) {
    final imageUrl = getBannerUrl(banner);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.lightGrey,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder(banner);
              },
            )
          : _buildPlaceholder(banner),
    );
  }

  Widget _buildPlaceholder(BannerModel banner) {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      alignment: Alignment.center,
      child: Text(
        banner.title.isNotEmpty ? banner.title : "Banner",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.banners.length, (index) {
        final isActive = _currentPage == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive ? AppColors.primary : AppColors.grey,
          ),
        );
      }),
    );
  }
}