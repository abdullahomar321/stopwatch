import 'package:flutter/material.dart';
import 'package:stopwatch/stopwatch.dart';


class logo extends StatelessWidget {
  const logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade900,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            backgroundColor: Colors.purple.shade900,
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, 
                  MaterialPageRoute(builder: (context)=>stopwatch()));
                },                
                child: Text(
                'TimeIt',
                style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: 90,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,

                ),
              ),
            ),
            ),
          )

        ],
      ),
    );
  }
}
