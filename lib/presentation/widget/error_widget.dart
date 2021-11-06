import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String error;
  Function? onTap;

  AppErrorWidget({required this.error, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            error,
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          if(onTap!= null)SizedBox(height: 12),
          if(onTap!= null)OutlinedButton(
                child: Text('Fix'),
                onPressed: () {
                  if (onTap != null) onTap!();
                })

        ],
      ),
    );
  }
}
