import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/generated/l10n.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class PopularFoodScreen extends StatefulWidget {
  const PopularFoodScreen({super.key});

  @override
  State<PopularFoodScreen> createState() => _PopularFoodScreenState();
}

class _PopularFoodScreenState extends State<PopularFoodScreen> {
  @override
  void initState() {
    super.initState();
    final userId = Provider.of<LoginProvider>(context, listen: false).id;
    Provider.of<ProductProvider>(context, listen: false).fetchProducts(context,id: userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, S.of(context).popular_food),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, _) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 230,
              ),
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
          },
        ),
      ),
    );
  }
}
