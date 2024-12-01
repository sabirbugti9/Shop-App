import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Styles/colors.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/reusable_components/reusable_components.dart';
import '../shared/controllers/shared_bloc/cubit.dart';
import '../shared/controllers/shared_bloc/states.dart';

 /*--------------------   products screen--------------------------*/
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, ShopStates state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status) {
            showToast(message: state.model.message, state: ToastStates.ERROR);
          }
        }
        if (state is InternetConnectedErrorState ||
            state is ShopErrorHomeDataState ||
            state is ShopErrorCategoriesDataState ||
            state is ShopErrorGetFavoritesState ||
            state is ShopErrorGetUserDataState) {
          ShopCubit.get(context).checkInternet();
        }
      },
      builder: (BuildContext context, ShopStates state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) {
            return builderWidget(
              model: ShopCubit.get(context).homeModel,
              cModel: ShopCubit.get(context).categoriesModel,
              context: context,
            );
          },
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget builderWidget(
      {required HomeModel? model,
      required CategoriesModel? cModel,
      required BuildContext context}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          /*--------------------  Carousel Slider --------------------------*/
          CarouselSlider(
            items: model?.data.banners
                .map(
                  (e) => CachedNetworkImage(
                    imageUrl: '${e.image}',
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[300]),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 200.0,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(
                seconds: 3,
              ),
              autoPlayAnimationDuration: const Duration(
                seconds: 1,
              ),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0, // the image takes the full width
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),

          /*--------------------  Categories List --------------------------*/
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 100.0,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return buildCategoryItem(cModel.data.data[index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10.0,
                    ),
                    itemCount: cModel!.data.data.length,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          /*--------------------  Grid View --------------------------*/
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio: 1 / 1.75,
              //width / height
              children: List.generate(
                  model!.data.products.length,
                  (index) =>
                      buildGridProduct(model.data.products[index], context)),
            ),
          ),
        ],
      ),
    );
  }

  // Grid product design
  Widget buildGridProduct(ProductModel model, BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              CachedNetworkImage(
                imageUrl: model.image,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: double.infinity,
                height: 210.0,
              ),
              if (model.discount != 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  color: Colors.yellow,
                  child: Text(
                    '${model.discount}% DISCOUNT',
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      model.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        height: 1.3,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice.round()}',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context)
                              .changeFavorites(productId: model.id);
                        },
                        tooltip: 'Add to favourites',
                        icon: CircleAvatar(
                          backgroundColor:
                              ShopCubit.get(context).favourites[model.id]!
                                  ? Colors.blue
                                  : Colors.grey,
                          radius: 15.0,
                          child: const Icon(
                            Icons.favorite_border,
                            size: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
 // Category item design
  Widget buildCategoryItem(DataModel model) {
    String name = StringUtils.capitalize(model.name);
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        CachedNetworkImage(
          imageUrl: model.image,
          placeholder: (context, url) => Container(color: Colors.grey[300]),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
        ),
        Container(
            width: 100.0,
            color: Colors.black.withOpacity(0.5),
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.0,
              ),
            )),
      ],
    );
  }
}
