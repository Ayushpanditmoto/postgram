// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/Profile.screen.dart';
import '../Services/firestore.services.dart';
import './like.button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../Screens/Comment.screen.dart';
import '../Screens/full.screen.image.dart';
import '../Providers/theme.provider.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';

class Post extends StatelessWidget {
  final Map<String, dynamic> snaps;
  final int index;
  final bool isAdminCheck;
  const Post(
      {super.key,
      required this.snaps,
      required this.index,
      required this.isAdminCheck});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    return Card(
      key: key,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: snaps['uid'],
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: snaps['profileUrl'] ??
                        'https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png'
                            .toString(),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          snaps['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy hh:mm')
                          .format(snaps['datePublished'].toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 50,
                  padding: const EdgeInsets.all(5),
                  constraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: theme.themeMode == ThemeMode.light
                        ? Colors.grey[300]
                        : Colors.grey[800],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.poll_sharp,
                        size: 12,
                        color: theme.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "#${index + 1}",
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Report Post'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Reason',
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  child: const Text('Report'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                leading: const Icon(Icons.report),
                                title: const Text('Report Post'),
                              ),
                              if (FirebaseAuth.instance.currentUser!.uid ==
                                  snaps['uid'])
                                ListTile(
                                  onTap: () async {
                                    // Navigator.pop(context);

                                    // await FirestoreMethods()
                                    //     .deletePost(snaps['postId']);
                                    //show dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Delete Post'),
                                          content: const Text(
                                              'Are you sure you want to delete this post?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await FirestoreMethods()
                                                    .deletePost(
                                                        snaps['postId']);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Delete Post'),
                                ),
                              if (isAdminCheck == true)
                                //profile page redirect
                                ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  leading: const Icon(Icons.person),
                                  title:
                                      const Text('View Profile (Admin Only)'),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              snaps['content'],
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            if (snaps['photoUrl'] != "")
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        imageUrl: snaps['photoUrl'],
                      ),
                    ),
                  );
                },
                child: CachedNetworkImage(
                  height: 150,
                  imageUrl: snaps['photoUrl'],
                  placeholder: (context, url) => SizedBox(
                    height: 100,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 150,
                        height: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                LikeAnimation(
                  isAnimating: snaps['likes']
                      .contains(FirebaseAuth.instance.currentUser!.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () {
                      FirestoreMethods().likePost(
                        snaps['postId'],
                        user.uid,
                        snaps['likes'],
                      );
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: snaps['likes'].contains(user!.uid)
                          ? Colors.red
                          : Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Comments(
                            snaps: snaps,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.comment,
                      color: Colors.grey,
                      size: 25,
                    )),
                const SizedBox(width: 5),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Share.share(
                        'Hey, check out this confession on JU confession App: ${snaps['confession']}',
                        subject: 'Confession');
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 5),
                // const Text(
                //   '1.2k',
                //   style: TextStyle(
                //     fontSize: 12,
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            //get all likes users
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(snaps['postId'])
                    .collection('likes')
                    .snapshots(),
                builder: (context, snapshot) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              child: InkWell(
                                  onTap: () {
                                    //show modal bottom sheet
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Liked by',
                                              style: TextStyle(
                                                fontSize: 20,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount:
                                                    snaps['likes'].length,
                                                itemBuilder: (context, index) {
                                                  return FutureBuilder(
                                                      future: FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(snaps['likes']
                                                              [index])
                                                          .get(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          //shimmer effect
                                                          return ListTile(
                                                            leading: Shimmer
                                                                .fromColors(
                                                              baseColor:
                                                                  Colors.grey,
                                                              highlightColor:
                                                                  Colors.white,
                                                              child:
                                                                  const CircleAvatar(
                                                                radius: 25,
                                                              ),
                                                            ),
                                                            title: Shimmer
                                                                .fromColors(
                                                              baseColor:
                                                                  Colors.grey,
                                                              highlightColor:
                                                                  Colors.white,
                                                              child: const Text(
                                                                'Loading...',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        return InkWell(
                                                          onTap: () {
                                                            //navigate to user profile
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProfileScreen(
                                                                  uid: snapshot
                                                                          .data![
                                                                      'uid'],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: ListTile(
                                                            leading:
                                                                CachedNetworkImage(
                                                              width: 50,
                                                              height: 50,
                                                              imageUrl: snapshot
                                                                      .data![
                                                                  'photoUrl'],
                                                              imageBuilder: (context,
                                                                      imageProvider) =>
                                                                  CircleAvatar(
                                                                backgroundImage:
                                                                    imageProvider,
                                                              ),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(
                                                                Icons.error,
                                                                color: Colors
                                                                    .redAccent,
                                                              ),
                                                            ),
                                                            title: Text(
                                                              snapshot.data![
                                                                  'name'],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child:
                                      Text('${snaps['likes'].length} Likes')),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
            // const SizedBox(height: 10),
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: RichText(
            //     text: TextSpan(
            //       children: [
            //         TextSpan(
            //           text: 'Vikas ',
            //           style: TextStyle(
            //             fontSize: 12,
            //             color: theme.themeMode == ThemeMode.light
            //                 ? Colors.black
            //                 : Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         TextSpan(
            //           text: 'Rashumi meri hai Lawde, Aur mera chota hai',
            //           style: TextStyle(
            //             fontSize: 12,
            //             color: theme.themeMode == ThemeMode.light
            //                 ? Colors.black
            //                 : Colors.white,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Comments(
                      snaps: snaps,
                    ),
                  ),
                );
              },
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('confession')
                      .doc(snaps['postId'])
                      .collection('comments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        'View all ${snapshot.data!.docs.length} comments',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
