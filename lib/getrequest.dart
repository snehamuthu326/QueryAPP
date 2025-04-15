import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetRequest extends StatefulWidget {
  @override
  _GetRequestState createState() => _GetRequestState();
}

class _GetRequestState extends State<GetRequest> {
  List<dynamic> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/problem/all'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _data = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('❌Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('❌Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Request'),
        backgroundColor: const Color.fromARGB(255, 255, 125, 25),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(minWidth: 800),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Description')),
                          // DataColumn(label: Text('Image')),
                          DataColumn(label: Text('Date Created')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows:
                            _data
                                .map(
                                  (item) => DataRow(
                                    cells: [
                                      DataCell(Text(item['pid'].toString())),
                                      DataCell(Text(item['category'] ?? 'N/A')),
                                      DataCell(
                                        Text(item['description'] ?? 'N/A'),
                                      ),
                                      //DataCell(Text(item['imagePath'] ?? '')),
                                      /*DataCell(
                                        item['imagePath'] != null && item['imagePath'].toString().isNotEmpty
                                            ? Image.network( item['imagePath'], width: 80, height: 80, fit: BoxFit.cover,
                                              errorBuilder:( context, error, stackTrace, ) => Icon(Icons.broken_image),
                                            )
                                            : Icon(Icons.image_not_supported),
                                      ),*/
                                      DataCell(
                                        Text(item['uploadTime'] ?? 'N/A'),
                                      ),
                                      DataCell(
                                        Text(item['fprocess'] ?? 'Progress'),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                ),
              ),
    );
  }
}
