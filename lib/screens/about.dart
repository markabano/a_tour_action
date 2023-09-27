import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 150,
              ),
              Text(
                'ABOUT A-TOUR-ACTION',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 70, 159, 209),
                ),
              ),
              Text(
                "A-TOUR-ACTION is a mobile application that allows users to experience Baguio City's rich historical landmarks. The app provides a guide to the city's historical sites, including information about their history, significance, and architecture. With the app's audio guides and 360-degree image views, users can immerse themselves in the history of each site. Additionally, the app offers real-time weather updates and peak hours information, allowing users to plan their visits efficiently. The site recognition feature in augmented reality allows users to gain more information about the historical site. A-TOUR-ACTION is designed to be user-friendly, reliable, and accessible to all users. The app's scalability and integration with other services ensure a seamless experience for users.",
                textAlign: TextAlign.justify,
                style: TextStyle(wordSpacing: 5, height: 1.5),
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Card(
                    elevation:
                        5, // Adjust the elevation to control the shadow depth
                    shape: CircleBorder(),
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width:
                                3, // Adjust the width of the border as needed
                          ),
                        ),
                        child: 
                        // OctoImage(
                        //   image: AssetImage("'assets/images/Patacsil1.jpg"),
                        //   progressIndicatorBuilder: (context, progress) =>
                        //       CircularProgressIndicator(),
                        //   imageBuilder: (context, child) => CircleAvatar(
                        //     maxRadius: 50,
                        //     backgroundImage: child,
                        //   ),
                        // )
                        CircleAvatar(
                          maxRadius: 50,
                          backgroundImage: AssetImage(
                            'assets/images/Patacsil1.jpg',
                          ),
                        ),
                        ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Dr. Frederick F. Patacsil',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 72, 113),
                        ),
                      ),
                      Text(
                        'College Dean/Capstone Coordinator',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 128, 202),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Card(
                    elevation:
                        5, // Adjust the elevation to control the shadow depth
                    shape: CircleBorder(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 255, 255),
                          width: 3, // Adjust the width of the border as needed
                        ),
                      ),
                      child: CircleAvatar(
                        maxRadius: 50,
                        backgroundImage: AssetImage(
                          'assets/images/Tablatin1.jpg',
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Dr. Christine Lourrine S. Tablatin',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 72, 113),
                        ),
                      ),
                      Text(
                        'IT Department Chairperson',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 128, 202),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  Card(
                    elevation:
                        5, // Adjust the elevation to control the shadow depth
                    shape: CircleBorder(),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 255, 255),
                          width: 3, // Adjust the width of the border as needed
                        ),
                      ),
                      child: CircleAvatar(
                        maxRadius: 50,
                        backgroundImage: AssetImage(
                          'assets/images/Bernisca1.jpg',
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Rhenel K. Bernisca',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 72, 113),
                        ),
                      ),
                      Text(
                        'Capstone Adviser',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 128, 202),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'CAPSTONE TEAM',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 128, 202),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Card(
                elevation:
                    5, // Adjust the elevation to control the shadow depth
                shape: CircleBorder(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 3, // Adjust the width of the border as needed
                    ),
                  ),
                  child: CircleAvatar(
                    maxRadius: 50,
                    backgroundImage: AssetImage(
                      'assets/images/Badua1.jpg',
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    'Christian Badua',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 72, 113),
                    ),
                  ),
                  Text(
                    'Project Leader',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 128, 202),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Card(
                elevation:
                    5, // Adjust the elevation to control the shadow depth
                shape: CircleBorder(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 3, // Adjust the width of the border as needed
                    ),
                  ),
                  child: CircleAvatar(
                    maxRadius: 50,
                    backgroundImage: AssetImage(
                      'assets/images/Abaño.jpg',
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    'Mark Joseph Abaño',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 72, 113),
                    ),
                  ),
                  Text(
                    'Lead Programmer',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 128, 202),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Team Members',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 128, 202),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        child: CircleAvatar(),
                      ),
                      Column(
                        children: [
                          Text(
                            'Rheimark Edrosolan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 72, 113),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        child: CircleAvatar(),
                      ),
                      Column(
                        children: [
                          Text(
                            'Rose Mary Dela Cruz',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 72, 113),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        child: CircleAvatar(),
                      ),
                      Column(
                        children: [
                          Text(
                            'Dharryl Clyde Santos',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 72, 113),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        child: CircleAvatar(),
                      ),
                      Column(
                        children: [
                          Text(
                            'Dominique Louise Magat',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 72, 113),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
