import 'package:flutter/material.dart';
import 'package:online_medicine/core/app_data.dart';

class ProductPage extends StatefulWidget {
  final String name;
  final double price;
  final String image;

  const ProductPage({
    super.key,
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isAdded = false;
  int quantity = 1;

  void add() {
    setState(() {
      quantity++;
    });
  }

  void remove() {
    setState(() {
      if (quantity > 1) quantity--;
    });
  }

  void toggleCart() {
    setState(() {
      isAdded = !isAdded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(widget.image),
            ),

            const SizedBox(height: 20),

            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "\$${widget.price}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            const Text(
              "This medicine helps in relieving pain, fever, and headaches. "
                  "Use it as directed by your doctor for best results.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                // زرار -
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: remove,
                    icon: const Icon(Icons.remove),
                  ),
                ),

                const SizedBox(width: 10),

                // العدد
                Text(
                  "$quantity",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 10),

                // زرار +
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff5EA8F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: add,
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),

            const Spacer(),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: toggleCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isAdded ? Colors.red : const Color(0xff5EA8F2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(isAdded ? "Remove from Cart" : "Add to Cart",style:TextStyle(color:AppColors.white ) ,),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}