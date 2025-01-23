import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Provider/userprovider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch users when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers(loadMore: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Top Container with Back Button and Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff5a46ff),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Expanded(
                          child: Text(
                            'Dating List',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Search Field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Body Content
            Expanded(
              child: userProvider.isLoading && userProvider.users.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : userProvider.users.isEmpty
                  ? const Center(child: Text('No users found'))
                  : NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent &&
                      !userProvider.isLoading) {
                    // Trigger loading of the next page when the user scrolls to the bottom
                    userProvider.fetchUsers(loadMore: true);
                  }
                  return true;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: userProvider.users.length + (userProvider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == userProvider.users.length) {
                      // Show loading indicator at the bottom
                      return const Center(child: CircularProgressIndicator());
                    }

                    final user = userProvider.users[index];
                    final List<String> dateActivities = ["Dinner", "Watch a Movie", "Aquarium Date"];
                    String activity = dateActivities[index % dateActivities.length];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.book,
                                color: Colors.black,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                activity, // Dynamic activity name
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.more_horiz,
                                size: 20.sp,
                                color:  Colors.black,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          // Avatar with Purple Outline
                          Row(
                            children: [
                              Stack(
                                children: [
                                  // Profile Picture with Purple Outline
                                  Container(
                                    padding: EdgeInsets.all(3.w), // Purple border thickness
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xff5a46ff), // Purple outline
                                        width: 2.w, // Border width
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(user.picture.large),
                                      radius: 25.r, // Smaller size
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),

                                  // Green Online Indicator
                                  Positioned(
                                    bottom: 2, // Positioning the green dot at the bottom
                                    right: 2,  // Positioning the green dot at the right
                                    child: Container(
                                      width: 14.w, // Adjust size as needed
                                      height: 14.h,
                                      decoration: BoxDecoration(
                                        color: Colors.green, // Green color
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1.w), // White border
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user.name.first} ${user.name.last}, ${user.dob.age}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      '3 km from you',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.solidMessage,
                                      color: const Color(0xff5a46ff),
                                      size: 20.sp,
                                    ),
                                    onPressed: () {
                                      // Handle Message Action
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.call,
                                      color: const Color(0xff5a46ff),
                                      size: 20.sp,
                                    ),
                                    onPressed: () {
                                      // Handle Call Action
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          // Date and Time Info
                          Row(
                            children: [
                              // First Column (Date & Time)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.black,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  // Displaying the day and date
                                  Text(
                                    '${DateFormat('E, MMM d yyyy').format(user.dob.date.toLocal())}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  // Time with AM/PM format
                                  Text(
                                    'Time: ${DateFormat('h:mm a').format(user.dob.date.toLocal())}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),

                              // Vertical Divider (Spacing + Line)
                              SizedBox(width: 15.w), // Add spacing
                              Container(
                                width: 1.5.w, // Thickness of the divider
                                height: 50.h, // Height of the divider
                                color: Colors.grey[400], // Divider color
                              ),
                              SizedBox(width: 15.w), // Add spacing

                              // Second Column (Your Additional Content)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on),
                                      Text(
                                        'Location', // Replace with actual content
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,color: Colors.black
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text('  ${user.location.city}, ${user.location.country}', style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal,color: Colors.black
                                  ),)
                                  
                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
