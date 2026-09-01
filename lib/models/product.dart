class Product {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
  });
}

// Sample mock data for testing
const List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Wireless Headphones',
    price: 99.99,
    imagePath: 'https://picsum.photos/id/100/300/300',
    description: 'High-quality noise-canceling wireless headphones.',
  ),
  Product(
    id: '2',
    name: 'Smart Watch',
    price: 149.99,
    imagePath: 'https://picsum.photos/id/102/300/300',
    description: 'Track your fitness, heart rate, and notifications.',
  ),
  Product(
    id: '3',
    name: 'Mechanical Keyboard',
    price: 79.99,
    imagePath: 'https://picsum.photos/id/106/300/300',
    description: 'RGB mechanical keyboard with tactile switches.',
  ),
  Product(
    id: '4',
    name: 'Gaming Mouse',
    price: 49.99,
    imagePath: 'https://picsum.photos/id/107/300/300',
    description: 'Ergonomic optical gaming mouse with high DPI.',
  ),
];
