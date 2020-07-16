import 'package:flutter/material.dart';
import 'package:lawyer_application/model/slide.dart';

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage(slideList[index].imageUrl),
                  fit: BoxFit.cover)
          ),
        ),
        SizedBox(height: 40,),
        new Text(
          slideList[index].title,
          style: TextStyle(
            fontSize: 22,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
        SizedBox(height: 20,),
        Text(
          slideList[index].description,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
