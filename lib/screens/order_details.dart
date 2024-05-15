import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orders.dart';

class OrderDetails extends StatefulWidget{
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List <Order> orders = [];

  @override
  void initState() {
  super.initState();
  _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .get();
      setState(() {
        orders = querySnapshot.docs.map((doc) {
          return Order.fromFirestore(doc.data() as Map<String, dynamic>);
        }).toList();
      });

    }catch(e){
      print('error : $e');
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
                    begin: Alignment.topCenter))
        ),

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
                  'Order Details',
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 80,
                ),
                ListView.builder(
                  shrinkWrap: true, // Prevent excessive scrolling
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Dismissible(
                      key: Key(order.orderId), // Unique key for each order
                      onDismissed: (direction) {
                        // Handle swipe actions (e.g., delete, archive)
                        if (direction == DismissDirection.endToStart) {
                          // Implement delete or archive functionality
                        }
                      },
                      child: InkWell(
                        onTap: () {
                          // Handle tap for order details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsPage(order: order),
                            ),
                          );
                        },
                        child: _buildOrderCard(order),
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        )
      ],
    );
  }
  Widget getStatusWidget(String status) {
    Color statusColor;
    switch (status) {
      case 'Pending':
        statusColor = Colors.yellow;
        break;
      case 'In Progress':
        statusColor = Colors.blue;
        break;
      case 'Delivered':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        status,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${order.orderId}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  order.customerName ?? 'Unknown Customer', // Handle missing name
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            Text(
              '₹${order.total.toString()}', // Format total with 2 decimals
              style: const TextStyle(fontSize: 14, color: Colors.green),
            ),
            getStatusWidget(order.status),
          ],
        ),
      ),
    );
  }

}

class Order {
  final String orderId;
  final String? customerName; // Optional customer name
  final String total;
  final String status;
  final String? phone;
  final String mop;
  final String? billing_address;
  final String? delivery_address;
  final String product_name;
  final String quantity;
  final String seller_id;

  // Add a constructor or factory method to parse data from Firestore
  Order.fromFirestore(Map<String, dynamic> data)
      : orderId = data['orderID'] ?? ' ',
        customerName = data['customerName'] ?? ' 'as String?,
        total = data['total'] ??  9 as String,
        status = data['status'] ?? ' ',
        phone = data['phone'] ?? ' ',
        billing_address = data['billing_address'] ?? ' ',
        delivery_address = data['delivery_address'] ?? ' ',
        product_name = data['product_name'] ?? ' ',
        quantity = data['quantity'] ?? ' ',
        mop = data['mop'] ?? ' ',
        seller_id = data['seller_id'] ?? ' ';


  const Order(
      this.billing_address,
      this.delivery_address,
      this.product_name,
      this.quantity,
      this.mop,
      this.seller_id,
      this.customerName,
      this.phone,
      {
      required this.orderId,
      required this.total,
      required this.status,
  });
}