import 'package:flutter/material.dart';
import 'package:nutrition_calender/components/data_dummy.dart';
import 'package:nutrition_calender/constants/dbhelper.dart';

class SearchItems extends StatefulWidget {
  final String date;
  final int time;
  const SearchItems({super.key, required this.date, required this.time});

  @override
  State<SearchItems> createState() => _SelectItemsState();
}

class _SelectItemsState extends State<SearchItems> {
  List<Item> dataset = [];
  List<Item> displayedItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItemsFromDB();

    searchController.addListener(() {
      final query = searchController.text.toLowerCase();
      setState(() {
        displayedItems =
            dataset
                .where((item) => item.name.toLowerCase().contains(query))
                .toList();
      });
    });
  }

  Future<void> _loadItemsFromDB() async {
    final data = await DatabaseHelper().getAllItems();
    setState(() {
      dataset =
          data
              .map(
                (e) => Item(
                  e['Food name in Bengali']?.toString() ?? 'Unknown',
                  false,
                ),
              )
              .toList();

      displayedItems = List.from(dataset);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var selectedList = getSelectedList(check[widget.date], widget.time);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Food'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search food...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: displayedItems.length,
        itemBuilder: (context, index) {
          final item = displayedItems[index];
          final isSelected = selectedList.any(
            (selected) => selected.name == item.name,
          );

          return ListTile(
            title: Text(item.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        selectedList.removeWhere(
                          (selected) => selected.name == item.name,
                        );
                      });
                    },
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        selectedList.add(Item(item.name, false));
                      });
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

List<Item> getSelectedList(EatingTime? et, int time) {
  if (et == null) return [];
  switch (time) {
    case 0:
      return et.breakfast;
    case 1:
      return et.lunch;
    case 2:
      return et.dinner;
    default:
      return et.other;
  }
}
