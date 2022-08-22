import 'package:flutter/foundation.dart';
import 'package:multi_vendor/provider/product_class.dart';

class Cart extends ChangeNotifier{
  final List<Product> _list = [];
  List<Product> get getItem{
    return _list;
  }

  int? get count{
    return _list.length;
  }

  double get totalprice{

    double total = 0.0;
    for(var item in _list){
      total += item.price * item.qty;
    }
    return total;
  }

  void addItem(
      String name,
      double price,
      int qty,
      int qntty,
      List imagesUrl,
      String documentId,
      String suppId,
      ){
    final product = Product(name: name, price: price, qty: qty, qntty: qntty, imagesUrl: imagesUrl, documentId: documentId, suppId: suppId);
    _list.add(product);

    notifyListeners();
  }
  void increament(Product product){
    product.increase();
    notifyListeners();
  }
  void reduceOne(Product product){
    product.decrease();
    notifyListeners();
  }
  void remove(Product product){
    _list.remove(product);
    notifyListeners();
  }
  void clearCart(){
    _list.clear();
    notifyListeners();
  }
}