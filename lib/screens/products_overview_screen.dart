import 'package:flutter/material.dart';

// Third party packages
import 'package:provider/provider.dart';

// Widgets Imports
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

// Screen Imports
import '../screens/cart_screen.dart';

// Provider Imports
import '../providers/cart.dart';
import '../providers/products.dart';
import '../providers/partner.dart';

enum FilterOptions { Favorites, All }

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavorites = false;
  var isInit = false;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (!isInit) {
      _isLoading = true;
      Provider.of<Partner>(context).partnerStatus();
      Provider.of<Products>(context).fetchAndSetProduct().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amazine'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            color: Theme.of(context).primaryColorLight,
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Text("Display only Favorites"),
                value: FilterOptions.Favorites,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (ctx, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: Column(
                children: [
                  Text(
                    'Fetching Products',
                    style: TextStyle(fontSize: 28),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator()
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
