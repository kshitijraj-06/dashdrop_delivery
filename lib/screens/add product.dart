import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState(products: []);
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<Map<String, dynamic>> products;
  String? selectedProduct;

  _AddProductState({required this.products});

  @override
  void initState() {
    super.initState();
    fetchProductsFromFirestore();
  }

  Future<void> fetchProductsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      setState(() {
        products = querySnapshot.docs.map((doc) {
          print('Document ID: ${doc.id}');
          print('Document Data: ${doc.data()}');
          return {
            'productId': doc.id,
            'name': doc['name'],
          };
        }).toList();
      });
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    const Color background = Colors.green;
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    double fillPercent = MediaQuery.of(context).size.height /
        11; // 73.23% neeche se white rhega screen
    double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: gradient,
                    stops: stops,
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter))),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Text(
                          'DashDrop - Partner',
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 30,
                ),
                Text(
                  'Add Product',
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13.0),
                  child: Row(
                    children: [
                      Text(
                        'Enter Details of Product',
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    hint: const Text('Select Product'),
                    value: selectedProduct,
                    items: products.map<DropdownMenuItem<String>>((product) {
                      return DropdownMenuItem<String>(
                        value: product['productId'],
                        child: Text(
                          product['name'],
                          style: GoogleFonts.montserrat(),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedProduct = newValue;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Select Product',
                      helperText: 'Select the Product to add in your Inventory',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13.0),
                  child: Row(
                    children: [
                      Text('Enter Price of each piece of the Product',
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: 'Price (INR)',
                        hintText: 'Enter Product Price',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [_buildQuantityField()],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width/1.10,
                  child: ElevatedButton(
                    onPressed: () {
                      updateInventory();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        fixedSize: const Size(370, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: Text(
                      'Update Inventory',
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2)),
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                GestureDetector(
                  onTap: () {

                  },
                  child: Text(
                    'Having Trouble Adding Product??',
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }


  Widget _buildQuantityField() {
    return Padding(
      padding: const EdgeInsets.only(left: 13.0, top: 8, bottom: 8),
      child: Row(
        children: [
          Text(
            'Quantity:',
            style: GoogleFonts.montserrat(
              textStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() {
                    // Handle decrementing quantity (ensure it doesn't go negative)
                    if (_quantityController.text.isNotEmpty &&
                        int.parse(_quantityController.text) > 0) {
                      _quantityController.text =
                          (int.parse(_quantityController.text) - 1).toString();
                    }
                  }),
                ),
                SizedBox(
                  width: 55,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() {
                    // Handle incrementing quantity
                    _quantityController.text =
                        (int.parse(_quantityController.text) + 1).toString();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateInventory() async {
    String quantity = _quantityController.text;
    String? productId = selectedProduct?.toString();
    String price = _priceController.text;

    if (productId != null) {
      try {
        // Fetch current product data
        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();

        if (productSnapshot.exists) {
          int currentQuantity = (productSnapshot.data()
              as Map<String, dynamic>)['quantity'] as int;
          int newQuantity = int.parse(quantity);
          int updatedQuantity = currentQuantity + newQuantity;

          // Update the product with new quantity and price
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .update({
            'price': price,
            'quantity': updatedQuantity,
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Product added to inventory successfully')));
        } else {
          // Handle case where product document doesn't exist
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Product not found in inventory.'),
          ));
        }
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to update inventory. Please try again.'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a valid product.'),
      ));
    }
  }
}
