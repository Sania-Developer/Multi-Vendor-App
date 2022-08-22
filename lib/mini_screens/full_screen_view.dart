import 'package:flutter/material.dart';

import '../widgets/appbar_widgets.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imagelist;

  FullScreenView({required this.imagelist});

  @override
  _FullScreenViewState createState() => _FullScreenViewState();
}

PageController _pageController = PageController();
int index = 0;

class _FullScreenViewState extends State<FullScreenView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const AppBarBackButton(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                ('${index + 1}') + ('/') + (widget.imagelist.length.toString()),
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
              ),
            ),
            SizedBox(
                height: size.height * 0.5,
                child: imageView()
            ),
            SizedBox(
                height: size.height * 0.2,
                child: images()
            )
          ],
        ),
      ),
    );
  }

  Widget imageView(){
    return  PageView(
        controller: _pageController,
        onPageChanged: (value){
          setState(() {
            index = value;
          });
        },
        children: List.generate(widget.imagelist.length, ((index) {
          return InteractiveViewer(
              transformationController: TransformationController(),
              child: Image(
                  image: NetworkImage(widget.imagelist[index].toString())));
        })));
  }
  ListView images(){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imagelist.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              _pageController.jumpToPage(index);
            },
            child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border:
                    Border.all(color: const Color(0xffE7A44D), width: 4),
                    borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.imagelist[index])),
                )
            ),
          );
        });
  }
}
