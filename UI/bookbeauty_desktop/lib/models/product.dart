enum Category { shampoo, oil, serum, cream }

const categoryName = {
  Category.shampoo: 'Sampon',
  Category.oil: 'Ulje',
  Category.cream: 'Krema',
  Category.serum: 'Serum',
};

class Product {
  Product(
      {required this.title,
      required this.id,
      required this.amount,
      required this.category});

  final String id;
  final String title;
  final double amount;
  final Category category;
}

class ProductBucket {
  const ProductBucket({required this.category, required this.products});

  final Category category;
  final List<Product> products;

  ProductBucket.forCategory(List<Product> allProducts, this.category)
      : products = allProducts.where((e) => e.category == category).toList();

  double get totalExpenses {
    double sum = 0;
    for (final product in products) {
      sum += product.amount;
    }
    return sum;
  }
}
