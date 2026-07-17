import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';

class ProductTile extends StatelessWidget {
  final ProductListElementDto product;

  const ProductTile({
    super.key,
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    final double relativeWidth = MediaQuery.sizeOf(context).width * 0.95;

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: relativeWidth,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 51), // 0.2 * 255 = 51
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child: product.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
              ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Price
                    if (product.price != null)
                      Text(
                        '${product.price!.toStringAsFixed(2)} zł',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    const SizedBox(height: 4),
                    // Chain and Rating
                    Row(
                      children: [
                        Text(
                          product.chainName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.reviewRatingAvg.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Tags
                    if (product.tagNames.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: product.tagNames.map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[800],
                            ),
                          ),
                        )).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
