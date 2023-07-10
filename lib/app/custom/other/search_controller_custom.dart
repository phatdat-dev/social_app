import 'package:flutter/material.dart';

// https://api.flutter.dev/flutter/material/SearchAnchor-class.html
class SelectedSearchControllerCustom<T extends SearchDelegateQueryName> extends SearchController {
  SelectedSearchControllerCustom({required this.data});
  List<T> data; //nên để final
  Set<T> searchHistory = {};
  T? selectedItem;
  ValueChanged<T>? onSelectionChanged;

  void _handleSelection(T item) {
    closeView(item.queryName);
    //
    selectedItem = item;

    //xóa để add lại vào đầu
    searchHistory.remove(item);
    final length = searchHistory.length;
    if (length >= 5) {
      final lastElement = searchHistory.elementAt(length - 1);
      searchHistory.remove(lastElement);
    }
    searchHistory.add(item);
    //
    onSelectionChanged?.call(item);
  }

  Iterable<Widget> getHistoryList() {
    return searchHistory
        .map((item) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(item.queryName),
              trailing: _buildTrailingIconButton(item),
              onTap: () => _handleSelection(item),
            ))
        .toList()
        .reversed;
  }

  Iterable<Widget> getSuggestions() {
    return data.where((element) => element.queryName.toLowerCase().contains(text.toLowerCase())).map((item) => ListTile(
          title: Text(item.queryName),
          trailing: _buildTrailingIconButton(item),
          onTap: () => _handleSelection(item),
        ));
  }

  Widget _buildTrailingIconButton(T item) => IconButton(
      icon: const Icon(Icons.call_missed),
      onPressed: () {
        text = item.queryName;
        selection = TextSelection.collapsed(offset: text.length);
      });
}

abstract class SearchDelegateQueryName {
  String get queryName;
  set queryName(String value) => queryName = value;
  Object? objectt;
}

class TesttSearchDelegateModel extends SearchDelegateQueryName {
  final String? id;
  final String? no;
  final String? name;

  TesttSearchDelegateModel({this.id, this.no, this.name});

  @override
  String get queryName => name ?? '';
}

/*
searchController = CSearchController<TesttSearchDelegateModel>(searchSuggestions: [
      ...List.generate(10, (index) => TesttSearchDelegateModel(id: '$index', no: 'no $index', name: 'name $index')),
    ]);
    
SearchAnchor(
            searchController: searchController,
            viewHintText: 'Search friends',
            headerHintStyle: Theme.of(context).textTheme.bodySmall,
            builder: (context, searchController) => AppBarIcon(
                  icon: const Icon(MdiIcons.magnify),
                  onPressed: () => searchController.openView(),
                ),
            suggestionsBuilder: (context, searchController) {
              searchController = (searchController as CSearchController);
              if (searchController.text.isEmpty) {
                if (searchController.searchHistory.isNotEmpty) {
                  return searchController.getHistoryList();
                }
                return <Widget>[
                  const Center(
                    child: Text('No search history.', style: TextStyle(color: Colors.grey)),
                  )
                ];
              }
              return searchController.getSuggestions();
            }),
*/