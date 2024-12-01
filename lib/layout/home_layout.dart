import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/pages/search/search_screen.dart';
import 'package:shop_app/shared/reusable_components/reusable_components.dart';
import '../shared/constants.dart';
import '../network/static/lists.dart';
import '../shared/controllers/shared_bloc/cubit.dart';
import '../shared/controllers/shared_bloc/states.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Shop App'),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context: context, widget: SearchScreen());
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: bottomScreens[currentInndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentInndex,
            onTap: (int index) {
              cubit.changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favourites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
