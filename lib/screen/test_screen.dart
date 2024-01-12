import 'package:flutter/material.dart';

class StampTest extends StatelessWidget {
  const StampTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stamp Test'),
      ),
      body: Center(
        child: Container(
          // color: Colors.red,
          width: 200,
          height: 100,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Colors.white,
              width: 5,
            ),
          ),
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 20,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    // borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.red,
                        width: 5,
                      ),
                    ),
                  ),
                  child: FittedBox(
                    child: Center(
                      child: Text(
                        'STAMP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'STAMP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'STAMP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.purple,
    );
  }
}
