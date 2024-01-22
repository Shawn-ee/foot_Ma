import 'package:flutter/material.dart';
class CouponWidget extends StatefulWidget {
  final Function(String)? onCouponApplied;

  CouponWidget({Key? key, this.onCouponApplied}) : super(key: key);

  @override
  _CouponWidgetState createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  final TextEditingController _couponController = TextEditingController();
  String? _errorText;

  void _applyCoupon() {
    if (_couponController.text.isNotEmpty) {
      // Perform your coupon validation here
      // For now, let's assume 'DISCOUNT10' is a valid coupon
      final isValidCoupon = _couponController.text == 'DISCOUNT10';
      setState(() {
        _errorText = isValidCoupon ? null : 'Invalid coupon code';
      });
      if (isValidCoupon) {
        // Trigger the callback for a valid coupon
        widget.onCouponApplied?.call(_couponController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: _couponController,
        decoration: InputDecoration(
          labelText: 'Coupon Code',
          errorText: _errorText,
          border: InputBorder.none, // Hides the default TextField border
          contentPadding: EdgeInsets.zero, // Adjust padding to match ListTile style
        ),
      ),
      trailing: ElevatedButton(
        onPressed: _applyCoupon,
        child: Text('Apply'),
        
      ),
    );
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }
}
