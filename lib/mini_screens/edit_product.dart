import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebasestorage;
import 'package:multi_vendor/widgets/elevated_button.dart';
import 'package:path/path.dart' as path;

import '../utilities/categ_list.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/pick_image_icons.dart';
import '../widgets/snack_bar.dart';


class Edit_Product extends StatefulWidget {
  final dynamic items;
  const Edit_Product({Key? key, required this.items}) : super(key: key);

  @override
  _Edit_ProductState createState() => _Edit_ProductState();
}

class _Edit_ProductState extends State<Edit_Product> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey =
  GlobalKey<ScaffoldMessengerState>();
  late double price;
  late int quantity;
  int? discount = 0;
  late String product_name;
  late String product_description;
  late String product_id;
  late String mainCategValue;
  late String subCategValue;
  bool proccessing = false;
  List<String> subCategList = [];

  ImagePicker picker = ImagePicker();
  dynamic _pickImage_fromError;
  List<XFile>? product_image_list = [];
  List<dynamic> images_Ur_lList = [];

  Future pick_Product_Images() async {
    try {
      final picked_image = await picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        product_image_list = picked_image!;
      });
    } catch (e) {
      setState(() {
        _pickImage_fromError = e;
      });
    }
  }

  Widget previewImages() {
    if (product_image_list!.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: product_image_list!.length,
          itemBuilder: (context, index) {
            return Image.file(File(product_image_list![index].path));
          });
    } else {
      return const Center(
        child: Text(
          'You have not \n picked image yet',
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget preview_current_Images() {
    List<dynamic> item_images = widget.items['product_image'];
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: item_images.length,
        itemBuilder: (context, index) {
          return Image(image: NetworkImage(item_images[index].toString()));
        });
  }

  void selectedMainCateg(String? value) {
    if (value == 'Men') {
      subCategList = men;
    } else if (value == 'Women') {
      subCategList = women;
    } else if (value == 'Electronics') {
      subCategList = electronics;
    } else if (value == 'Accessories') {
      subCategList = accessories;
    } else if (value == 'Shoes') {
      subCategList = shoes;
    } else if (value == 'Home & Garden') {
      subCategList = homeandgarden;
    } else if (value == 'Beauty') {
      subCategList = beauty;
    } else if (value == 'Kids') {
      subCategList = kids;
    } else if (value == 'Bags') {
      subCategList = bags;
    }
    print(value);
    setState(() {
      mainCategValue = value!;
      subCategValue = 'subcategory';
    });
  }

  Future upload_images() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      if (product_image_list!.isNotEmpty) {
        if (mainCategValue != 'select category' &&
            subCategValue != 'subcategory') {
          try {
            for (var images in product_image_list!) {
              firebasestorage.Reference ref = firebasestorage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(images.path)}');
              await ref.putFile(File(images.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  images_Ur_lList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          MyMessageHandler.showSnackBar(
              'Please select the categories', _scaffoldkey);
        }
      } else {
        images_Ur_lList = widget.items['product_image'];
      }
    } else {
      MyMessageHandler.showSnackBar('Please Fill all the Field', _scaffoldkey);
    }
  }

  edit_Product_data() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.items['product_id']);
      transaction.update(documentReference, {
        'porduct_name': product_name,
        'product_price': price,
        'product_quantity': quantity,
        'product_description': product_description,
        'product_image': images_Ur_lList,
        'discount': discount,
        'category' : mainCategValue,
        'sub_category' : subCategValue,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  save_changes() async {
    await upload_images().whenComplete(() => edit_Product_data());
  }

  @override
  Widget build(BuildContext context) {
    mainCategValue = widget.items['category'];
    subCategValue = widget.items['sub_category'];

    return ScaffoldMessenger(
      key: _scaffoldkey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.3,
                            color: const Color(0xfffffbd5),
                            child: product_image_list!.isEmpty
                                ? preview_current_Images()
                                : previewImages()),
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Pick_image_icons(
                            icon: Icons.edit,
                            onPressed: () {
                              pick_Product_Images();
                            },
                          ))
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0,bottom: 18,top: 50),
                    child: Text('Detail:',style: TextStyle(color: Color(0xff00203F),fontSize: 28,fontWeight: FontWeight.w600),),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 13.0, bottom: 2),
                    child: Text(
                      'Product Name',
                      style:
                      TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        initialValue: widget.items['porduct_name'],
                        maxLength: 100,
                        decoration: decoration_Text_Field.copyWith(
                            hintText: 'Product Name',
                            label: const Text('Enter Product Name')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Product Name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          product_name = value!;
                        },
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 13.0, bottom: 2,top: 20),
                    child: Text(
                      'Product Description',
                      style:
                      TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        initialValue: widget.items['product_description'],
                        maxLength: 800,
                        maxLines: 5,
                        decoration: decoration_Text_Field.copyWith(
                            hintText: 'Product Description',
                            label: const Text('Enter Product Description')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Product Description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          product_description = value!;
                        },
                      ),
                    ),
                  ),

          const Padding(
            padding: EdgeInsets.only(left: 13.0, bottom: 2,top: 20),
            child: Text(
              'Price',
              style:
              TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      initialValue:
                      widget.items['product_price'].toString(),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: decoration_Text_Field.copyWith(
                          hintText: 'Price... \$',
                          label: const Text('Price')),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Product Price';
                        } else if (value.isValidPrice() != true) {
                          return 'Invalid Price';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        price = double.parse(value!);
                      },
                    ),
                  ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 13.0, bottom: 2,top: 30),
            child: Text(
              'Product Quantity',
              style:
              TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: SizedBox(
                    width: MediaQuery.of(context).size.width ,
                    child: TextFormField(
                      initialValue:
                      widget.items['product_quantity'].toString(),
                      keyboardType: TextInputType.number,
                      decoration: decoration_Text_Field.copyWith(
                          hintText: 'Quantity',
                          label: const Text('Quantity')),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Product Quantity';
                        } else if (value.isValidQuantity() != true) {
                          return 'Invalid Quantity';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        quantity = int.parse(value!);
                      },
                    ),
                  ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 13.0, bottom: 2,top: 30),
            child: Text(
              'Product Discount',
              style:
              TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      initialValue: widget.items['discount'].toString(),
                      maxLength: 2,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: decoration_Text_Field.copyWith(
                          hintText: 'Discount... %',
                          label: const Text('Discount')),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return null;
                        } else if (value.isValidDiscount() != true) {
                          return 'Invalid Discount';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        discount = int.parse(value!);
                      },
                    ),
                  ),
          ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10, 0),
                    child: Column(
                      children: [
                    Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xffE7A44D))
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Padding(
                          padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 0),
                          child: DropdownButton(
                              hint: Text(widget.items['category']),
                              value: mainCategValue,
                              iconDisabledColor: Colors.black,
                              isExpanded: true,
                              menuMaxHeight: 400,
                              borderRadius: BorderRadius.circular(10.0),
                              items: maincateg
                                  .map<DropdownMenuItem<String>>(
                                      (value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ))
                                  .toList(),
                              onChanged: (String? value) {
                                selectedMainCateg(value);
                              }),
                        ),
                    ),
        const SizedBox(
          height: 40,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xffE7A44D))
          ),
          padding: const EdgeInsets.all(5),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 0),
                          child: DropdownButton(
                              hint: Text(widget.items['sub_category']),
                              isExpanded: true,
                              value: subCategValue,
                              menuMaxHeight: 400,
                              borderRadius: BorderRadius.circular(10.0),
                              items: subCategList
                                  .map<DropdownMenuItem<String>>(
                                      (value) => DropdownMenuItem(
                                    child: Text(value),
                                    value: value,
                                  ))
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  subCategValue = value!;
                                });
                              }),
                        )
        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: Column(
                        children: [
                          Elevated_button(
                            text: 'Cancel',
                            width: 350,
                            height: 60,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Elevated_button(
                            text: 'Save Changes',
                            width: 350,
                            height: 60,
                            onPressed: () {
                              save_changes();
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Elevated_button(
                            text: 'Delete Product',
                            width: 350,
                            height: 60,
                            onPressed: () async{
                              await FirebaseFirestore.instance.runTransaction((transaction)async{
                                DocumentReference documentReference = FirebaseFirestore.instance.collection('products').doc(widget.items['product_id']);
                                transaction.delete(documentReference);
                              }).whenComplete(() => Navigator.pop(context));
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^\d{0,8}$').hasMatch(this);
  }
}

extension Price on String {
  bool isValidPrice() {
    return RegExp(r'^\d{0,8}(\.\d{1,4})?$').hasMatch(this);
  }
}

extension Discount on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9]*)$').hasMatch(this);
  }
}
