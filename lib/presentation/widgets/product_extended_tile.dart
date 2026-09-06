import 'package:flutter/material.dart';
import 'package:strawa/presentation/widgets/product_extended_tile_viewmodel.dart';

class ProductExtendedTile extends StatelessWidget {
  final ProductExtendedTileViewModel viewModel;

  const ProductExtendedTile({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final double relativeWidth = MediaQuery.sizeOf(context).width * 0.92;

    return Container(
      width: relativeWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 77), // 0.3 * 255 = 77
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProductImage(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  viewModel.product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                // Price and Rating
                Row(
                  children: [
                    if (viewModel.product.price != null)
                      Text(
                        '${viewModel.product.price!.toStringAsFixed(2)} zł',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star, size: 22, color: Colors.amber[700]),
                        const SizedBox(width: 6),
                        Text(
                          viewModel.product.reviewRatingAvg.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Chain
                Row(
                  children: [
                    Icon(Icons.storefront, size: 20, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        viewModel.product.chainName,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Tags
                if (viewModel.product.tagNames.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: viewModel.product.tagNames
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    final String? imageUrl = viewModel.product.imageUrl;

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: ColoredBox(
        color: Colors.grey[200]!,
        child: imageUrl != null
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 220,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 64,
                  color: Colors.grey,
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              )
            : const Icon(
                Icons.image_not_supported,
                size: 64,
                color: Colors.grey,
              ),
      ),
    );
  }
}
