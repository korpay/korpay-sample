import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String? orderNumber;

  const SuccessScreen({super.key, this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            Text('주문번호: $orderNumber'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("홈으로 돌아가기"),
            )
          ],
        ),
      ),
    );
  }
}
