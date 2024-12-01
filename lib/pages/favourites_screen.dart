import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/reusable_components/reusable_components.dart';
import '../shared/controllers/shared_bloc/cubit.dart';
import '../shared/controllers/shared_bloc/states.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, ShopStates state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.favoritesModel != null &&
              cubit.favoritesModel!.data.data.isNotEmpty,
          builder: (context) {
            return ListView.separated(
              itemBuilder: (context, index) => buildProductList(
                  cubit.favoritesModel!.data.data[index].product, context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: cubit.favoritesModel!.data.data.length,
            );
          },
          fallback: (context) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  color: Colors.black45,
                  size: 100.0,
                ),
                Text(
                  'No Favorites Yet',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
