import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vendor/utilities/categ_list.dart';
import 'package:multi_vendor/widgets/elevated_button.dart';
import 'package:multi_vendor/widgets/snack_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebasestorage;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import '../widgets/auth_widgets.dart';

class Upload_Product_Screen extends StatefulWidget {
  const Upload_Product_Screen({Key? key}) : super(key: key);

  @override
  _Upload_Product_ScreenState createState() => _Upload_Product_ScreenState();
}

class _Upload_Product_ScreenState extends State<Upload_Product_Screen> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey =
  GlobalKey<ScaffoldMessengerState>();
  late double price;
  late int quantity;
  int? discount = 0;
  late String product_name;
  late String product_description;
  late String product_id;
  String mainCategValue = 'select category';
  String subCategValue = 'subcategory';
  bool proccessing = false;
  List<String> subCategList = [];

  ImagePicker picker = ImagePicker();
  dynamic _pickImage_fromError;
  List<XFile>? product_image_list = [];
  List<String> images_Ur_lList = [];

  void pick_Product_Images() async {
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
          'Click here to pick Product Images',
          style: TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  void selectedMainCateg(String? value) {
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'Men') {
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

  Future<void> upload_images() async{
    if (mainCategValue != 'select category' && subCategValue != 'subcategory') {
      if (_formkey.currentState!.validate()) {
        _formkey.currentState!.save();
        if (product_image_list!.isNotEmpty) {
          setState(() {
            proccessing = true;
          });
          try{
            for (var images in product_image_list!) {
              firebasestorage.Reference ref = firebasestorage
                  .FirebaseStorage.instance
                  .ref('products/${path.basename(images.path)}');
              await ref.putFile(File(images.path)).whenComplete(() async{
                await ref.getDownloadURL().then((value) {
                  images_Ur_lList.add(value);
                });
              });
            }
          }catch(e){
            print(e);
          }
        } else {
          MyMessageHandler.showSnackBar(
              'Please pick the image first', _scaffoldkey);
        }
      } else {
        MyMessageHandler.showSnackBar(
            'Please Fill all the Field', _scaffoldkey);
      }
    } else {
      MyMessageHandler.showSnackBar(
          'Please select the categories', _scaffoldkey);
    }
  }

  void upload_data() async{
    if (images_Ur_lList.isNotEmpty) {
      CollectionReference product_ref = FirebaseFirestore.instance.collection('products');
      product_id = Uuid().v4();
      print(product_name);
      await product_ref.doc(product_id).set({
        'product_id' : product_id,
        'porduct_name' : product_name,
        'product_price' : price,
        'product_quantity' : quantity,
        'product_description' : product_description,
        'product_image' : images_Ur_lList,
        'discount' : discount,
        'category' : mainCategValue,
        'sub_category' : subCategValue,
        'sid': FirebaseAuth.instance.currentUser!.uid,
      }).whenComplete(() {
        setState(() {
          MyMessageHandler.showSnackBar(
              'Your Product has been uploaded', _scaffoldkey);
          product_image_list = [];
          mainCategValue = 'select category';
          subCategList = [];
          images_Ur_lList = [];
        });
        _formkey.currentState!.reset();
      });
    } else {
      print('no images');
    }
  }

  void upload_product() async {
    await upload_images().whenComplete(() => upload_data());
  }

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0,left: 20.0,right: 15.0,bottom: 15.0),
                        child: DottedBorder(
                          color: Colors.black,
                          strokeWidth: 1,
                          strokeCap: StrokeCap.round,
                          borderType: BorderType.RRect,
                          dashPattern: [4,4],
                          radius: const Radius.circular(15),
                          padding: const EdgeInsets.all(12),
                          child: GestureDetector(
                            onTap: (){
                              pick_Product_Images();
                            },
                            child: Stack(
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    color: const Color(0xffE7A44D),
                                    child: product_image_list != null
                                        ? previewImages()
                                        : const Center(
                                      child: Text(
                                        'Click here to pick Product Images',
                                        style: TextStyle(fontSize: 16.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                Positioned(
                                    top: 5,
                                    right: 5,
                                    child: product_image_list!.isNotEmpty ? IconButton(
                                      onPressed: (){
                                        setState(() {
                                          product_image_list = [];
                                        });
                                      },
                                      icon: const Icon(
                                         Icons.delete,
                                  color: Color(0xff00203F),
                                ),
                                    ): const SizedBox())
                              ],
                            ),
                          ),
                        ),
                      ),
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: decoration_Text_Field.copyWith(
                            hintText: 'Enter your Product Price... \$',
                            label: const Text('Enter your Product Price... \$')),
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
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: decoration_Text_Field.copyWith(
                            hintText: 'Enter your Product Quantity',
                            label: const Text('Enter your Product Quantity')),
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
                        maxLength: 2,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: decoration_Text_Field.copyWith(
                            hintText: 'Enter your Product Discount... %',
                            label: const Text('Enter your Product Discount... %')),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return null;
                          }
                          else if (value.isValidDiscount() != true) {
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
                    padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15, 0),
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
                                disabledHint: const Text('select category'),
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
                                disabledHint: const Text('subcategory'),
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
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Center(
                      child: Elevated_button(text: 'Upload Product', width: 350, height: 60,onPressed: proccessing == true ? null : () {
                        upload_product();
                      },),
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

