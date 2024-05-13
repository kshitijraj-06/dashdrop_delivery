import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'order_details.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details (ID: ${order.orderId})'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: GoogleFonts.montserrat(
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            _buildOrderSummary(order),
            const Divider(thickness: 1.0),
            const SizedBox(height: 10),
            Text(
              'Customer Information',
              style: GoogleFonts.montserrat(
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            _buildCustomerInfo(order),
            const Divider(thickness: 1.0),
            const SizedBox(height: 10),
            Text(
              'Billing Address',
              style: GoogleFonts.montserrat(
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            Text(order.billing_address ?? ' '),
            const Divider(thickness: 1.0),
            const SizedBox(height: 10),
            Text(
              'Delivery Address',
              style: GoogleFonts.montserrat(
                textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            Text(order.delivery_address ?? ' '),
            const Divider(thickness: 1.0),
            const SizedBox(height: 10),
            Text(
              'Products',
              style: GoogleFonts.montserrat(
                textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            _buildproductInfo(order),
            const Divider(thickness: 1.0),
            const SizedBox(height: 10),
            Text('Delivery Status',
              style: GoogleFonts.montserrat(
                textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10,),
            _builddeliveryInfo(order),
            // Add sections for Items, Delivery (if applicable), and Actions (optional)
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(Order order) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order ID: ${order.orderId}'),
        Text('Mode of Payment: ${order.mop}'),
        Text('Total Amount : ${order.total}'),
      ],
    );
  }

  Widget _buildCustomerInfo(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${order.customerName ?? 'Unknown'}'),
        Text('Phone Number : ${order.phone}')
        // Add additional customer information fields (e.g., phone number, address)
      ],
    );
  }

  Widget _buildproductInfo(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Product : ${order.product_name ?? ' '}'),
        Text('Quantity : ${order.quantity ?? ' '}'),
      ],
    );
  }

  Widget _builddeliveryInfo(Order order){
    return Column(
      children: [
        Text('Status: ${order.status ?? ' '}'),
      ],
    );
  }
}
