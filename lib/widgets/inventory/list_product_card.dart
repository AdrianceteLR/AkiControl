// ignore_for_file: camel_case_types

import 'package:akicontrol/models/models.dart';
import 'package:flutter/material.dart';

class ListProductCard extends StatelessWidget {
  final Product product;

  const ListProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: _cardBorders(),
      child: Stack(
        children: [
          _BackgroundImage(product.picture),

          // Disponible superior izquierda
          if (!product.available)
            Container(
              alignment: Alignment.topLeft,
              child: _NotAvailable(),
            ),

          // Precio superior derecha
          Container(
            alignment: Alignment.topRight,
            child: _QuantityDetails(
              quantity: product.quantity,
            ),
          ),

          // Descripcion inferior
          Container(
            alignment: Alignment.bottomLeft,
            child: _productDetails(
              name: product.name,
              category: product.category,
            ),
          ),
        ],
      ),
    );
  }

  // Borde de las tarjetas
  BoxDecoration _cardBorders() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 7),
          blurRadius: 10,
        )
      ],
    );
  }
}

// Detalle superior izquierda de las tarjetas
class _NotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(30),
        topLeft: Radius.circular(25),
      ),
      child: Container(
        alignment: Alignment.center,
        width: sizeWidth = sizeWidth * 0.25,
        height: sizeHeight = sizeHeight * 0.085,
        color: const Color.fromRGBO(255, 152, 0, 0.9),
        child: const Text(
          'No disponible',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Detalle superior derecho de las tarjetas
class _QuantityDetails extends StatelessWidget {
  final int quantity;

  const _QuantityDetails({
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        topRight: Radius.circular(25),
      ),
      child: Container(
        alignment: Alignment.center,
        width: sizeWidth = sizeWidth * 0.25,
        height: sizeHeight = sizeHeight * 0.085,
        color: const Color.fromRGBO(63, 81, 181, 0.9),
        child: Text(
          '$quantity',
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

// Detalle inferior de las tarjetas
class _productDetails extends StatelessWidget {
  final String name;
  final String category;

  const _productDetails({
    required this.name,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30), bottomLeft: Radius.circular(25)),
      child: Container(
        width: size = size * 0.75,
        height: sizeHeight = sizeHeight * 0.085,
        color: const Color.fromRGBO(63, 81, 181, 0.9),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Categoria: $category',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Imagen de fondo
class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage(this.url);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        //height: 400,
        child: url == null
            ? const Image(
                image: AssetImage('assets/images/no-image.png'),
                fit: BoxFit.cover,
              )
            : FadeInImage(
                placeholder: const AssetImage('assets/images/jar-loading.gif'),
                image: NetworkImage(url!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
