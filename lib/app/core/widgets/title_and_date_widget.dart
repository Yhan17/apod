import 'package:flutter/material.dart';

import '../utils/app_pipes.dart';

class TitleAndDateWidget extends StatelessWidget {
  final String title;
  final DateTime date;

  const TitleAndDateWidget({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Text(
          AppPipes.formatDate(date, format: 'dd/MM/yyyy'),
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
