import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:cosmetic_frontend/models/models.dart' hide Image;


class ProductDetailImageCarouselSlider extends StatelessWidget {
  final List<Carousel> carouselList;
  ProductDetailImageCarouselSlider({required this.carouselList});

  int _current = 0;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: CarouselSlider.builder(
        itemCount: carouselList.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          final crs = carouselList[itemIndex];
          return Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      crs.url,
                      errorBuilder: (context, url, error) =>
                          Icon(Icons.error),
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                      width: 1000,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: carouselList.map((crs) {
                  int index = carouselList.indexOf(crs);
                  return Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: itemIndex == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              )
            ],
          );
        },
        options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            aspectRatio: 16/9,
            viewportFraction: 1,
            onPageChanged: (index, reason) {

            }
        )
      ),
    );
  }
}


