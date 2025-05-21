// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:food2go_app/controllers/business_setup_controller.dart';
import 'package:food2go_app/controllers/notification_controller.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/view/screens/categories/screens/categories_screen.dart';
import 'package:food2go_app/view/screens/discount/discount_screen.dart';
import 'package:food2go_app/view/screens/onboarding_screens/delivery_or_pickup_screen.dart';
import 'package:food2go_app/view/screens/popular_food/screens/popular_food_screen.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/category_details_screen.dart';
import 'package:food2go_app/view/screens/deals/deals_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/filter_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/search_result_screen.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/closed_wrap_container.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/categories/categories_provider.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import '../../../../controllers/banners/banners_provider.dart';
import '../../../../models/banners/banners_model.dart';
import '../../../../models/categories/categories_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<LoginProvider>(context, listen: false).id;
    Provider.of<AddressProvider>(context, listen: false);
    Provider.of<CategoriesProvider>(context, listen: false)
        .fetchCategories(context);
    Provider.of<ProductProvider>(context, listen: false).fetchProducts(
      context,
      userId: userId,
      addressId: Provider.of<AddressProvider>(context, listen: false)
          .selectedAddressId,
      branchId:
          Provider.of<AddressProvider>(context, listen: false).selectedBranchId,
    );
    Provider.of<ProductProvider>(context, listen: false).loadCart();
    Provider.of<BannerProvider>(context, listen: false).fetchBanners(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetProfileProvider>(context, listen: false)
          .fetchUserProfile(context);
      Provider.of<NotificationController>(context, listen: false)
          .initFCMToken(userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final businessSetupProvider =
        Provider.of<BusinessSetupController>(context, listen: false);
    bool isClosed = businessSetupProvider.businessSetup?.openFlag == false;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildSearchAndFilter(),
                  const SizedBox(height: 16),
                  _buildImageCarousel(),
                  _buildCategoryList(),
                  const SizedBox(height: 10),
                  _buildDealsSection(),
                  const SizedBox(height: 10),
                  _buildPopularFoodHeader(),
                  const SizedBox(height: 16),
                  _buildFoodItemsList(),
                  const SizedBox(height: 16),
                  _buildDiscountHeader(),
                  const SizedBox(height: 16),
                  _buildDiscountList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            if (isClosed) ...[
              GestureDetector(
                onTap: () {},
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Center(
                child: buildClosedWrap(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).choose_your_favorite_food,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () async {
            final addressProvider =
                Provider.of<AddressProvider>(context, listen: false);
            final productProvider =
                Provider.of<ProductProvider>(context, listen: false);
            addressProvider.selectedAddressId = null;
            addressProvider.selectedBranchId = null;
            addressProvider.resetSelectedAddresses();
            await productProvider.clearCart();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DeliveryOrPickupScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share_location,
              color: maincolor,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    final searchController = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  Provider.of<ProductProvider>(context, listen: false)
                      .updateSearchQuery(value);
                },
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const SearchScreen()),
                  );
                },
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: S.of(context).search,
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        CircleAvatar(
          backgroundColor: maincolor,
          child: IconButton(
            icon: SvgPicture.asset('assets/images/filter.svg'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FilterScreen()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return Consumer<BannerProvider>(builder: (context, bannerProvider, child) {
      if (bannerProvider.banners.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          CarouselSlider(
            items: bannerProvider.banners.map((banner) {
              return _buildCarouselImage(banner);
            }).toList(),
            options: CarouselOptions(
              height: 160.0,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 2),
              viewportFraction: bannerProvider.banners.length == 1 ? 1.0 : 0.8,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              bannerProvider.banners.length,
              (index) => _buildIndicator(index),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCarouselImage(AppBanner banner) {
    return GestureDetector(
      onTap: () {
        log('bannerCategory: ${banner.category?.id}');

        if (banner.dealId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DealsScreen(),
            ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetailsScreen(
                  bannerCategory: banner.category,
                ),
              ));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            banner.imageLink,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentIndex == index ? maincolor : Colors.grey,
      ),
    );
  }

  Widget _buildCategoryList() {
    return Consumer<CategoriesProvider>(
      builder: (context, categoriesProvider, child) {
        final allCategory = Category(
          name: S.of(context).all,
          imageLink: 'assets/images/Onboarding3.png',
          id: 0,
          status: 1,
          activity: 1,
          priority: 0,
          subCategories: [],
          addons: [],
        );

        final categories = [allCategory, ...categoriesProvider.categories];

        // Split categories into two groups
        final firstRowCategories = categories.take(4).toList();
        final secondRowCategories = categories.skip(4).toList();

        return Column(
          children: [
            // Non-scrollable row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: firstRowCategories.map((category) {
                  return _buildCategoryItem(
                    category.name,
                    category.imageLink,
                    MediaQuery.of(context).size.width / 4.5, // Adjust width
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 15),
            // Scrollable row
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: secondRowCategories.length,
                itemBuilder: (context, index) {
                  final category = secondRowCategories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildCategoryItem(
                      category.name,
                      category.imageLink,
                      MediaQuery.of(context).size.width / 4.5, // Adjust width
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryItem(String title, String image, double width) {
    return GestureDetector(
      onTap: () {
        if (title == 'All' || title == S.of(context).all) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const CategoriesScreen()),
          );
        } else {
          final selectedCategory =
              Provider.of<CategoriesProvider>(context, listen: false)
                  .categories
                  .firstWhere((category) => category.name == title);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) =>
                  CategoryDetailsScreen(category: selectedCategory),
            ),
          );
        }
      },
      child: Container(
        width: width,
        height: 130,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: maincolor,
              child: ClipOval(
                child: title == 'All' || title == S.of(context).all
                    ? Image.asset(
                        'assets/images/Onboarding3.png',
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      )
                    : Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealsSection() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => const DealsScreen()));
      },
      child: SizedBox(
        height: 100,
        child: Stack(
          children: [
            Positioned(
              bottom: 15,
              right: 10,
              child: Container(
                width: MediaQuery.sizeOf(context).width / 1.1,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: maincolor,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Deals',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -10,
              bottom: 4,
              child: Image.asset('assets/images/sultan.png'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularFoodHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).popular_food,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PopularFoodScreen()),
            );
          },
          child: Text(
            S.of(context).see_all,
            style: const TextStyle(
              color: maincolor,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDiscountHeader() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        final hasDiscountItems = productProvider.discounts.isNotEmpty;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).discount,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasDiscountItems)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DiscountScreen()),
                  );
                },
                child: Text(
                  S.of(context).see_all,
                  style: const TextStyle(
                    color: maincolor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFoodItemsList() {
    return SizedBox(
      height: 210,
      child: Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productProvider.popularProducts.length,
          itemBuilder: (context, index) {
            final product = productProvider.popularProducts[index];
            return FoodCard(
              name: product.name,
              image: product.image,
              description: product.description,
              price: product.price,
              productId: product.id,
              isFav: product.isFav,
              product: product,
            );
          },
        );
      }),
    );
  }

  Widget _buildDiscountList() {
    return SizedBox(
      height: 200,
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          if (productProvider.discounts.isEmpty) {
            return Center(
              child: Text(
                S.of(context).no_discount_items_available,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productProvider.discounts.length,
            itemBuilder: (context, index) {
              final product = productProvider.discounts[index];
              return FoodCard(
                name: product.name,
                image: product.image,
                description: product.description,
                price: product.price,
                isFav: product.isFav,
                product: product,
                productId: product.id,
              );
            },
          );
        },
      ),
    );
  }
}
