// import 'dart:convert';
import 'dart:io';
//import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontendmcet/getrequest.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProbDesc extends StatefulWidget {
  const ProbDesc({super.key});
 
  @override
  State<ProbDesc> createState() => _ProbDescState();
}

class _ProbDescState extends State<ProbDesc> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedCategory;
  File? _selectedImage;

  
Future<void> _pickImage() async {
  final picker = ImagePicker();

  // Show options dialog
  showModalBottomSheet(
    context: context,
    builder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text('Take Photo'),
          onTap: () async {
            Navigator.pop(context);
            //final picked = 
            await picker.pickImage(source: ImageSource.camera);
            //if (picked != null) _cropImage(File(picked.path));
          },
        ),
        ListTile(
          leading: Icon(Icons.photo),
          title: Text('Choose from Gallery'),
          onTap: () async {
            Navigator.pop(context);
            //final picked = 
            await picker.pickImage(source: ImageSource.gallery);
            //if (picked != null) _cropImage(File(picked.path));
          },
        ),
      ],
    ),
  );
}

/*Future<void> _cropImage(File imageFile) async {
  final cropped = await ImageCropper().cropImage(
    sourcePath: imageFile.path,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
      ),
    ],
  );

  if (cropped != null) {
    setState(() {
      _selectedImage = File(cropped.path);
    });
  }
}*/

  

  void _submitRequest() async {
    if (_selectedCategory == null || _textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }
    print("Category: $_selectedCategory");
    print("Description: ${_textController.text}");
    //print("Image: ${_selectedImage?.path}");

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8080/problem/add'),
      );
      request.fields['category'] = _selectedCategory!;
      request.fields['description'] = _textController.text;
      // Add the image file if it exists
      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'imagePath', // The field name expected by the server
          _selectedImage!.path,
        ));
      }
      // Send the request
      final response = await request.send();

      /*final url = Uri.parse('http://10.0.2.2:8080/maintenance/add'); // Replace localhost with your IP if testing on real device

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'category': _selectedCategory,
      'description': _textController.text,
    }),
  );*/

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request submitted successfully!")),
        );
        print('✅ Problem added, Request sent');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to submit request")),
        );
        print('❌ Failed to add problem. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred")),
      );
      print('❌ Failed Error: $e');
    }
  }

  // adding a function to view the request

/*Future<void> addMaintenanceProblem() async {
  final url = Uri.parse('http://localhost:8080/maintenance/add'); // Replace localhost with your IP if testing on real device

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'category': _selectedCategory,
      'description': _textController.text,
    }),
  );

  if (response.statusCode == 200) {
    print('✅ Problem added: ${response.body}');
  } else {
    print('❌ Failed to add problem. Status: ${response.statusCode}');
    print('Response: ${response.body}');
  }
}*/



  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Request'),
        backgroundColor:const Color.fromARGB(255, 255, 125, 25),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Select Complaint Type",
                  border: OutlineInputBorder(),
                  focusColor: Color.fromARGB(255, 255, 125, 25),
                  contentPadding: EdgeInsets.all(8.0),
                ),
                items: ['Electrical', 'Civil', 'Others'].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _textController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Describe your problem',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Attach an image (optional):"),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text("Submit", style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Times New Roman',
                                  ),),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetRequest(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text("See All Request", style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Times New Roman',
                                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


