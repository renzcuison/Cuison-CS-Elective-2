class Product {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final String description;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.category,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

List<CartItem> globalCart = [];

const List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'iPhone 15 Pro Max',
    price: 84990.00,
    imagePath:
        'https://images.unsplash.com/photo-1695048133142-1a20484d2569?q=80&w=600&auto=format&fit=crop',
    description:
        'Forged in titanium. A17 Pro chip. The most powerful iPhone camera system ever.',
    category: 'iPhone',
  ),
  Product(
    id: '2',
    name: 'MacBook Pro 16" M3 Max',
    price: 229990.00,
    imagePath:
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=600&auto=format&fit=crop',
    description:
        'Mind-blowing performance. Liquid Retina XDR display. Up to 22 hours of battery life.',
    category: 'Mac',
  ),
  Product(
    id: '3',
    name: 'iPad Pro 13" M4',
    price: 82990.00,
    imagePath:
        'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?q=80&w=600&auto=format&fit=crop',
    description:
        'Unbelievably thin. Ultra Retina XDR display. Outrageous performance with M4.',
    category: 'iPad',
  ),
  Product(
    id: '4',
    name: 'Apple Watch Ultra 2',
    price: 44990.00,
    imagePath:
        'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?q=80&w=600&auto=format&fit=crop',
    description:
        'The ultimate sports and adventure watch. Brightest display ever in an Apple Watch.',
    category: 'Watch',
  ),
  Product(
    id: '5',
    name: 'AirPods Max',
    price: 32990.00,
    imagePath:
        'https://images.unsplash.com/photo-1613040809024-b4ef7ba99bc3?q=80&w=600&auto=format&fit=crop',
    description:
        'High-fidelity audio with active noise cancellation and personalized spatial audio.',
    category: 'Audio',
  ),
  Product(
    id: '6',
    name: 'Mac mini M2 Pro',
    price: 79990.00,
    imagePath:
        'https://images.unsplash.com/photo-1629131726692-1accd0c53ce0?q=80&w=600&auto=format&fit=crop',
    description:
        'More muscle. More hustle. Mini footprint with massive capability.',
    category: 'Mac',
  ),
  Product(
    id: '7',
    name: 'Studio Display',
    price: 99990.00,
    imagePath:
        'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?q=80&w=600&auto=format&fit=crop',
    description:
        '27-inch 5K Retina display. 12MP Ultra Wide camera with Center Stage.',
    category: 'Accessories',
  ),
  Product(
    id: '8',
    name: 'HomePod mini',
    price: 5790.00,
    imagePath:
        'https://images.unsplash.com/photo-1543512214-318c7553f230?q=80&w=600&auto=format&fit=crop',
    description:
        'Jam-packed with innovation, HomePod mini delivers unexpectedly big sound.',
    category: 'Audio',
  ),
];
