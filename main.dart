import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  timeDilation = 1.5; // Slows down Hero animations
  runApp(const MyApp());
}

class Car {
  final String name, model, image;
  final int price;
  Car({
    required this.name,
    required this.model,
    required this.image,
    required this.price,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cars = [
    Car(
      name: "Toyota Corolla",
      model: "2022",
      image: "images/6.jpeg",
      price: 5000,
    ),
    Car(
      name: "Honda Civic",
      model: "2021",
      image: "images/7.jpeg",
      price: 5500,
    ),
    Car(
      name: "Suzuki Swift",
      model: "2023",
      image: "images/8.jpeg",
      price: 4500,
    ),
    Car(name: "Tesla", model: "2022", image: "images/5.jpeg", price: 3000),
  ];
  final booked = <Car>[];

  void _goToBookings() => Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (_) => BookingsPage(
            bookings: booked,
            onRemove: (c) {
              setState(() => booked.remove(c));
            },
          ),
    ),
  );

  void _goToDetails(Car c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => DetailPage(
              car: c,
              onBook: () {
                setState(() => booked.add(c));
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Car booked!")));
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Cars"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _goToBookings,
              ),
              if (booked.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      "${booked.length}",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (_, i) {
          final c = cars[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Hero(
                tag: c.image,
                child: Image.asset(
                  c.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(c.name),
              subtitle: Text("${c.model} • Rs ${c.price}/day"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => _goToDetails(c),
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Car car;
  final VoidCallback? onBook;
  const DetailPage({super.key, required this.car, required this.onBook});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: car.image,
            child: Image.asset(car.image, height: 250, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              car.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "Model: ${car.model}",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "Rs ${car.price} / day",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ElevatedButton.icon(
              onPressed: onBook,
              icon: const Icon(Icons.check, color: Colors.black),
              label: const Text("Book Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingsPage extends StatefulWidget {
  final List<Car> bookings;
  final Function(Car) onRemove;
  const BookingsPage({
    super.key,
    required this.bookings,
    required this.onRemove,
  });
  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  @override
  Widget build(BuildContext context) {
    final total = widget.bookings.fold<int>(0, (sum, c) => sum + c.price);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Bookings"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:
          widget.bookings.isEmpty
              ? const Center(child: Text("No bookings yet."))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.bookings.length,
                      itemBuilder: (context, i) {
                        final c = widget.bookings[i];
                        return ListTile(
                          leading: Hero(
                            tag: c.image,
                            child: Image.asset(
                              c.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(c.name),
                          subtitle: Text("Rs ${c.price} / day"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                widget.onRemove(c);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Total: Rs $total",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
