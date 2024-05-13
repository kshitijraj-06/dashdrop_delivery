import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatAndSupport extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    const Color background = Colors.green;
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    double fillPercent = MediaQuery.of(context).size.height /
        11; // 73.23% neeche se white rhega screen
    double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: gradient,
                    stops: stops,
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter))
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Text(
                        'DashDrop - Partner',
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height / 30,
              ),
              Text(
                'Chat & Support',
                style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 80,
              ),


            ],

          ),
        )
      ],
    );
  }
}