import 'package:flutter/material.dart';

class hod extends StatefulWidget {
  const hod({super.key});

  @override
  State<hod> createState() => _hodState();
}

class _hodState extends State<hod> {
  Future<List<Map<String, dynamic>>> fetchDataFromDatabase() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      {'problem_id': 1, 'description': 'Issue with login'},
      {'problem_id': 2, 'description': 'Page not loading'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOD'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDataFromDatabase(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Problem ID')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Action')),
                DataColumn(label: Text('Comment')),
              ],
              rows: data.map((row) {
                TextEditingController commentController = TextEditingController();
                String? selectedOption;

                return DataRow(cells: [
                  DataCell(Text(row['problem_id'].toString())),
                  DataCell(Text(row['description'])),
                  DataCell(Row(
                    children: [
                      Radio<String>(
                        value: 'recommend',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      ),
                      const Text('Recommend'),
                      Radio<String>(
                        value: 'not_recommend',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      ),
                      const Text('Not Recommend'),
                    ],
                  )),
                  DataCell(TextField(
                    controller: commentController,
                    decoration: const InputDecoration( hintText: 'Enter comment',),)),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}