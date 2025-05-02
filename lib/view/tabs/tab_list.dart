import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usettle/view/tabs/tab_screen.dart';

class TabSelectionPage extends StatefulWidget {
  final List<CustomTab> initialTabs;

  const TabSelectionPage({super.key, required this.initialTabs});

  @override
  TabSelectionPageState createState() => TabSelectionPageState();
}

class TabSelectionPageState extends State<TabSelectionPage> {
  List<CustomTab> _allTabs = [];
  List<CustomTab> _filteredTabs = [];
  final TextEditingController _searchController = TextEditingController();

  static const Color _greyColor = Color(0xFF696969);
  static const Color _greenColor = Color(0xFF2A6E55);
  static const Color _redColor = Colors.redAccent;

  @override
  void initState() {
    super.initState();
    _allTabs = widget.initialTabs;
    _filteredTabs = widget.initialTabs;
  }

  void _filterTabs(String query) {
    setState(() {
      _filteredTabs =
          _allTabs
              .where(
                (tab) => tab.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _filteredTabs = _allTabs;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(
            PhosphorIconsRegular.caretLeft,
            color: _greyColor,
            size: 30.0,
            semanticLabel: 'Back',
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildSearchBar(),
                ),
                Expanded(
                  child:
                      _allTabs.isEmpty
                          ? _buildShimmerLoading()
                          : _buildTabList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.white),
            title: Container(width: 150, height: 10, color: Colors.white),
            subtitle: Container(width: 100, height: 10, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildTabList() {
    return ListView.builder(
      itemCount: _filteredTabs.length,
      itemBuilder: (context, index) {
        final tab = _filteredTabs[index];
        return ListTile(
          leading:
              tab.imageUrl != null
                  ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/id/${_filteredTabs.indexOf(tab) + 20}/200/200',
                    ),
                  )
                  : CircleAvatar(
                    backgroundColor: _greyColor,
                    child: Text(
                      tab.name.isNotEmpty ? tab.name[0] : '?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tab.name),
              Text(
                tab.owes
                    ? 'Devo ${tab.total.toStringAsFixed(2)}€'
                    : 'Deve-me ${tab.total.toStringAsFixed(2)}€',
                style: TextStyle(color: tab.owes ? _redColor : _greenColor),
              ),
            ],
          ),
          trailing: PhosphorIcon(
            PhosphorIcons.caretRight(),
            color: _greenColor,
            size: 30.0,
          ),
          onTap:
              () => {
                Navigator.pushNamed(context, '/single-tab', arguments: tab),
              },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _filterTabs,
      decoration: InputDecoration(
        hintText: 'Pesquisar...',
        prefixIcon: PhosphorIcon(
          PhosphorIconsRegular.magnifyingGlass,
          color: _greyColor,
          size: 20.0,
        ),
        suffixIcon:
            _searchController.text.isEmpty
                ? null
                : IconButton(
                  icon: PhosphorIcon(
                    PhosphorIconsRegular.x,
                    color: _greyColor,
                    size: 20.0,
                  ),
                  onPressed: _clearSearch,
                ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 14.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: _greenColor, width: 1.5),
        ),
      ),
    );
  }
}
