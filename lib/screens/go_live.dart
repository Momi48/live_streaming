
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:twitch_clone/firebase/firestore_method.dart';
import 'package:twitch_clone/screens/broadcast_screen.dart';
import 'package:twitch_clone/utils/colors.dart';
import 'package:twitch_clone/utils/utils.dart';
import 'package:twitch_clone/widgets/custom_button.dart';
import 'package:twitch_clone/widgets/custom_textfield.dart';

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({super.key});

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? imageBytes;
  FirestoreMethod firestoreMethod = FirestoreMethod();
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  goLiveStream() async {
    if (_titleController.text.isEmpty || imageBytes == null) {
      print('Hello');
      showSnackBar(context, 'Please Fill All Field');
      return;
    }
    
    else { 
      
       String channelId = await firestoreMethod.startLiveChannel(
        context: context,
        image: imageBytes!,
      

        title: _titleController.text,
      );
      if (channelId.isNotEmpty) {
        showSnackBar(context, 'Live Stream Has Started Successfully!');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BroadcastScreen(channelId: channelId, isBroadcast: true),
          ),
        );
      
      }
     }
     
  
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                       
                          imageBytes = await pickFileImage(context: context);
                        

                        setState(() {});
                      },
                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 22.0,
                          vertical: 20.0,
                        ),
                        child: imageBytes != null
                            ? SizedBox(height: 300, child: Image.memory(imageBytes!))
                            : DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  radius: Radius.circular(10),
                                  dashPattern: [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color: buttonColor,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: buttonColor.withOpacity(.05),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        color: buttonColor,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        'Select your thumbnail',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CustomTextField(controller: _titleController),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CustomButton(
                color: buttonColor,
                text: 'Go Live!',

                onTap: goLiveStream,
                // onTap: (){
                //   FirestoreMethod().endLiveStream(context);
                // },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
