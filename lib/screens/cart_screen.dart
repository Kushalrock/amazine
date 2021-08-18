import 'package:flutter/material.dart';

// Third party packages imports
import 'package:provider/provider.dart';

// Providers Imports
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../providers/my_product_orders.dart';

// Screen Imports
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final numberController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Consumer<Cart>(
                        builder: (ctx, cartData, _) => Chip(
                          label: Text(
                            '\$${cartData.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .title
                                  .color,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      OrderButton(
                        cart: cart,
                        addressController: addressController,
                        nameController: nameController,
                        numberController: numberController,
                      ),
                    ],
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: nameController,
                  ),
                  TextField(
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(labelText: 'Address'),
                    controller: addressController,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Mobile No.'),
                    controller: numberController,
                    maxLength: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartCard(
              id: cart.items.values.toList()[i].id,
              productId: cart.items.keys.toList()[i],
              title: cart.items.values.toList()[i].title,
              quantity: cart.items.values.toList()[i].qty,
              price: cart.items.values.toList()[i].price,
              imageUrl: cart.items.values.toList()[i].imageUrl,
            ),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    @required this.nameController,
    @required this.addressController,
    @required this.numberController,
  }) : super(key: key);

  final Cart cart;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController numberController;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  List<List<String>> lists = [];
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool _checkingTextInputs() {
      print('I am being checked');
      if (widget.addressController.text == "" ||
          widget.nameController.text == "" ||
          widget.numberController.text == "") {
        return true;
      }
      print(widget.numberController.text.length);
      if (widget.numberController.text.length < 10) {
        return true;
      }
      return false;
    }

    void _showError() {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please input the details correctly!!')));
    }

    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW!!'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              if (_checkingTextInputs()) {
                _showError();
                setState(() {
                  _isLoading = false;
                });
                return;
              }
              for (int i = 0; i < widget.cart.itemCount; i++) {
                final response = await Provider.of<MyProductOrders>(context,
                        listen: false)
                    .addProductOrder(
                        widget.cart.items.keys.toList()[i],
                        widget.cart
                            .findProduct(widget.cart.items.keys.toList()[i]),
                        widget.addressController.text,
                        widget.nameController.text,
                        widget.numberController.text);
                print(response);
                lists.add(response);
              }
              final resp = await Provider.of<Orders>(context, listen: false)
                  .addOrder(widget.cart.items.values.toList(),
                      widget.cart.totalAmount, lists);
              for (int i = 0; i < lists.length; i++) {
                Provider.of<MyProductOrders>(context, listen: false)
                    .linkData(lists[i][1], lists[i][0], i, resp);
              }
              widget.cart.clear();

              setState(() {
                _isLoading = false;
              });
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
