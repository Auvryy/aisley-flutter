import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/models/order.dart';
import '../../core/widgets/aisley_button.dart';
import '../../state/buyer_state.dart';

class RateFeedbackModal extends StatefulWidget {
  final BuyerOrder order;

  const RateFeedbackModal({super.key, required this.order});

  @override
  State<RateFeedbackModal> createState() => _RateFeedbackModalState();
}

class _RateFeedbackModalState extends State<RateFeedbackModal> {
  double _rating = 5.0;
  final TextEditingController _commentController = TextEditingController();
  bool _hasPhotoAttached = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleSubmitReview(BuyerState state) {
    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      state.submitOrderReview(
        widget.order.id,
        _rating,
        _commentController.text.trim().isEmpty
            ? 'Exquisite luxury craftsmanship and swift white-glove arrival!'
            : _commentController.text.trim(),
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for sharing your feedback with the boutique!'),
          backgroundColor: AisleyColors.emeraldSuccess,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = BuyerStateProvider.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AisleyColors.obsidianSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AisleyColors.obsidianBorder : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.rate_review_outlined, color: AisleyColors.accentPink),
                const SizedBox(width: 8),
                Text(
                  'Rate & Review Order',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AisleyColors.textDarkPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Order Ref: ${widget.order.orderNumber}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AisleyColors.obsidianTextMuted : AisleyColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 16),

            // Interactive Star Rating
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return IconButton(
                    iconSize: 32,
                    icon: Icon(
                      starIndex <= _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() => _rating = starIndex.toDouble());
                    },
                  );
                }),
              ),
            ),
            Center(
              child: Text(
                _rating == 5
                    ? 'Exceptional Haute Experience (5/5)'
                    : _rating >= 4
                        ? 'Great Boutique Service (${_rating.toInt()}/5)'
                        : 'Feedback Submitted (${_rating.toInt()}/5)',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AisleyColors.accentPink),
              ),
            ),
            const SizedBox(height: 16),

            // Comment field
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Share your thoughts on the tailoring, fabric, and delivery...',
              ),
            ),
            const SizedBox(height: 12),

            // Photo attachment simulation
            InkWell(
              onTap: () {
                setState(() => _hasPhotoAttached = !_hasPhotoAttached);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AisleyColors.obsidianBorder : AisleyColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _hasPhotoAttached ? Icons.check_circle : Icons.add_photo_alternate_outlined,
                      size: 18,
                      color: _hasPhotoAttached ? AisleyColors.emeraldSuccess : AisleyColors.accentPink,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _hasPhotoAttached ? 'Photo Attached (lookbook_review.jpg)' : 'Attach Customer Photo (Optional)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _hasPhotoAttached ? AisleyColors.emeraldSuccess : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            AisleyButton(
              text: 'Submit Verified Buyer Review',
              isLoading: _isSubmitting,
              onPressed: () => _handleSubmitReview(state),
            ),
          ],
        ),
      ),
    );
  }
}
