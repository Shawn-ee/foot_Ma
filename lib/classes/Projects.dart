class Project {
  String name;
  String timeLength;
  double price;
  String description;
  int quantity;

  Project({
    required this.name,
    required this.timeLength,
    required this.price,
    required this.description,
    this.quantity = 0,
  });

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 0) quantity--;
  }

  double get totalPrice => quantity * price;
}