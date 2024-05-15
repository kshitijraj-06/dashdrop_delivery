import 'package:flutter/material.dart';

class FarmerEarningsOverviewPage extends StatefulWidget {
  const FarmerEarningsOverviewPage({super.key});

  @override
  State<FarmerEarningsOverviewPage> createState() => _FarmerEarningsOverviewPageState();
}

class _FarmerEarningsOverviewPageState extends State<FarmerEarningsOverviewPage> {
  // State variables to hold retrieved data
  double totalRevenue = 0.0;
  Map<String, double> categoryRevenue = {}; // Map to store revenue by category

  @override
  void initState() {
    super.initState();
    _fetchEarningsData(); // Call to fetch data on widget initialization
  }

  Future<void> _fetchEarningsData() async {
    // Replace with your logic to fetch data from your source (e.g., local storage, API)
    // This example simulates data for vegetables and fruits
    final data = {
      'vegetables': {
        'quantity_sold': 50.0,
        'average_price': 20.0,
      },
      'fruits': {
        'quantity_sold': 20.0,
        'average_price': 30.0,
      },
    };

    setState(() {
      totalRevenue = 0.0;
      categoryRevenue.clear();
      for (final category in data.keys) {
        final categoryData = data[category];
        final quantitySold = categoryData!['quantity_sold'] as double;
        final averagePrice = categoryData['average_price'] as double;
        final categoryTotal = quantitySold * averagePrice;
        totalRevenue += categoryTotal;
        categoryRevenue[category] = categoryTotal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings Overview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEarningsCard(context),
            const SizedBox(height: 10),
            _buildCategoryRevenueList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Revenue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '₹${totalRevenue.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRevenueList(BuildContext context) {
    if (categoryRevenue.isEmpty) {
      return const Text('No category data available.');
    }

    return ListView.builder(
      shrinkWrap: true, // Prevent excessive scrolling
      itemCount: categoryRevenue.length,
      itemBuilder: (context, index) {
        final category = categoryRevenue.keys.elementAt(index);
        final revenue = categoryRevenue[category]!;
        return ListTile(
          title: Text(category),
          trailing: Text('₹${revenue.toStringAsFixed(2)}'),
        );
      },
    );
  }
}
