import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/product_provider.dart';
// import '../providers/cart_provider.dart';
// import '../models/product.dart';
import 'package:e_commerce_clothing_store/providers/auth_provider.dart';
import 'package:e_commerce_clothing_store/providers/product_provider.dart';
import 'package:e_commerce_clothing_store/providers/cart_provider.dart';
import 'package:e_commerce_clothing_store/models/product.dart';


import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Fetch products and categories when the screen loads
    Future.microtask(() {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.fetchAllProducts();
      productProvider.fetchCategories();
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query, List<Product> allProducts) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredProducts = [];
      });
      return;
    }

    final results = allProducts.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase()) ||
          product.category.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _isSearching = true;
      _filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    
    // Get all products
    List<Product> allProducts = productProvider.products;
    
    // Get featured products (electronics and jewelery categories)
    List<Product> featuredProducts = allProducts.where((product) => 
      product.category == 'electronics' || product.category == 'jewelery'
    ).toList();
    
    // Get popular products (clothing categories)
    List<Product> popularProducts = allProducts.where((product) => 
      product.category == "men's clothing" || product.category == "women's clothing"
    ).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: productProvider.isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF6A5ACD)))
            : Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // User profile
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                'https://ui-avatars.com/api/?name=${authProvider.username}&background=random',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hello!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'John William',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Notification icon
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search here',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: (value) => _performSearch(value, allProducts),
                      ),
                    ),
                  ),
                  
                  // Main Content
                  Expanded(
                    child: _isSearching
                        ? _buildSearchResults()
                        : _buildHomeContent(featuredProducts, popularProducts),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF6A5ACD),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            // Show logout dialog
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      authProvider.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return ListTile(
          leading: Image.network(
            product.image,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
          title: Text(product.title),
          subtitle: Text('\$${product.price.toStringAsFixed(0)}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHomeContent(List<Product> featuredProducts, List<Product> popularProducts) {
    return ListView(
      children: [
        // Banner
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 120,
                child: PageView.builder(
                  controller: _bannerController,
                  itemCount: 4,
                  onPageChanged: (index) {
                    setState(() {
                      _currentBannerIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A5ACD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Get Winter Discount',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '20% Off',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'For Children',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1565084888279-aca607ecce0c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                                fit: BoxFit.cover,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // Pagination dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentBannerIndex == index
                          ? const Color(0xFF6A5ACD)
                          : Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Featured Products
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Featured Products Grid
        SizedBox(
          height: 180,
          child: featuredProducts.isEmpty
              ? const Center(child: Text('No featured products'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    final product = featuredProducts[index];
                    return ProductCard(
                      product: product,
                      width: 120,
                      customName: _getCustomProductName(product, index),
                      customPrice: _getCustomProductPrice(product, index),
                    );
                  },
                ),
        ),
        
        // Most Popular
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Most Popular',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Most Popular Products Grid
        SizedBox(
          height: 180,
          child: popularProducts.isEmpty
              ? const Center(child: Text('No popular products'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: popularProducts.length,
                  itemBuilder: (context, index) {
                    final product = popularProducts[index];
                    return ProductCard(
                      product: product,
                      width: 120,
                      customName: _getCustomPopularName(product, index),
                      customPrice: _getCustomPopularPrice(product, index),
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  String _getCustomProductName(Product product, int index) {
    final names = ['Watch', 'Bike Shoes', 'Airpods'];
    if (index < names.length) {
      return names[index];
    }
    return product.category;
  }
  
  String _getCustomProductPrice(Product product, int index) {
    final prices = ['40', '430', '125'];
    if (index < prices.length) {
      return prices[index];
    }
    return product.price.toStringAsFixed(0);
  }
  
  String _getCustomPopularName(Product product, int index) {
    final names = ['LG TV', 'Hoodie', 'Jacket'];
    if (index < names.length) {
      return names[index];
    }
    return product.category;
  }
  
  String _getCustomPopularPrice(Product product, int index) {
    final prices = ['330', '50', '400'];
    if (index < prices.length) {
      return prices[index];
    }
    return product.price.toStringAsFixed(0);
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final double width;
  final String? customName;
  final String? customPrice;

  const ProductCard({
    Key? key,
    required this.product,
    this.width = 120,
    this.customName,
    this.customPrice,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: widget.product),
          ),
        );
      },
      child: Container(
        width: widget.width,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with favorite icon
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(widget.product.image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Product name
            Text(
              widget.customName ?? widget.product.category,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Product price
            Text(
              '\$${widget.customPrice ?? widget.product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
