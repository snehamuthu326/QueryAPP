import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class hod extends StatefulWidget {
  const hod({super.key});

  @override
  State<hod> createState() => _hodState();
}

class _hodState extends State<hod> {
  List<Map<String, dynamic>> _data = [];
  Map<int, String?> selectedOptions = {};
  Map<int, TextEditingController> commentControllers = {};

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  Future<void> fetchDataFromDatabase() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/problem/all'));
    if (response.statusCode == 200) {
      final List<dynamic> raw = jsonDecode(response.body);
      setState(() {
        _data = raw.cast<Map<String, dynamic>>();
        for (var item in _data) {
          commentControllers[item['pid']] = TextEditingController();
        }
      });
    }
  }

  Future<void> submitRecommendation(int pid) async {
    final comment = commentControllers[pid]?.text ?? '';
    final status = selectedOptions[pid] ?? '';

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/problem/recommend'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pid': pid,
        'recommendation': status,
        'comment': comment,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Submitted successfully for Problem ID $pid")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting for Problem ID $pid")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HOD')),
      body: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Problem ID')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Action')),
            DataColumn(label: Text('Comment')),
            DataColumn(label: Text('Submit')),
          ],
          rows: _data.map((row) {
            int pid = row['pid'];
            return DataRow(cells: [
              DataCell(Text(pid.toString())),
              DataCell(Text(row['description'] ?? '')),
              DataCell(Row(
                children: [
                  Radio<String>(
                    value: 'recommend',
                    groupValue: selectedOptions[pid],
                    onChanged: (value) {
                      setState(() {
                        selectedOptions[pid] = value;
                      });
                    },
                  ),
                  const Text('Recommend'),
                  Radio<String>(
                    value: 'not_recommend',
                    groupValue: selectedOptions[pid],
                    onChanged: (value) {
                      setState(() {
                        selectedOptions[pid] = value;
                      });
                    },
                  ),
                  const Text('Not Recommend'),
                ],
              )),
              DataCell(TextField(
                controller: commentControllers[pid],
                decoration: const InputDecoration(hintText: 'Enter comment'),
              )),
              DataCell(
                ElevatedButton(
                  onPressed: () => submitRecommendation(pid),
                  child: const Text('Submit'),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
