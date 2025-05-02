import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usettle/models/participant.dart';
import 'package:usettle/models/profile.dart';
import 'package:usettle/models/receipt.dart';
import 'package:usettle/view/assignment/assignment.dart';

class ContactsSelectionPage extends StatefulWidget {
  const ContactsSelectionPage({super.key});

  @override
  ContactsSelectionPageState createState() => ContactsSelectionPageState();
}

class ContactsSelectionPageState extends State<ContactsSelectionPage> {
  List<Contact> _allContacts = [];
  final List<Contact> _selectedContacts = [];
  List<Contact> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();

  static const Color _greyColor = Color(0xFF696969);
  static const Color _greenColor = Color(0xFF2A6E55);
  static const Color _darkGreenColor = Color(0xFF2B3347);

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
      );
      setState(() {
        _allContacts = contacts;
        _filteredContacts = contacts;
      });
    }
  }

  void _filterContacts(String query) {
    setState(() {
      _filteredContacts =
          _allContacts
              .where(
                (contact) => contact.displayName.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _filteredContacts = _allContacts;
      _searchController.clear();
    });
  }

  void _toggleSelection(Contact contact) {
    setState(() {
      if (_selectedContacts.contains(contact)) {
        _selectedContacts.remove(contact);
      } else {
        _selectedContacts.add(contact);
      }
    });
  }

  void _unselectContact(Contact contact) {
    setState(() {
      _selectedContacts.remove(contact);
    });
  }

  @override
  Widget build(BuildContext context) {
    final receipt = ModalRoute.of(context)?.settings.arguments as Receipt?;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Selecionar pessoas', style: TextStyle(fontSize: 19)),
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
                if (_selectedContacts.isNotEmpty) _buildSelectedContactsRow(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildSearchBar(),
                ),
                Expanded(
                  child:
                      _allContacts.isEmpty
                          ? _buildShimmerLoading()
                          : _buildContactList(),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _darkGreenColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black26,
                      ),
                      onPressed: () {
                        // TODO: Change page
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PhosphorIcon(
                            PhosphorIconsRegular.squareSplitHorizontal,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text('Pré-Dividir', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _greenColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black26,
                      ),
                      onPressed: () {
                        final selectedParticipants =
                            _selectedContacts
                                .map(
                                  (contact) => Participant(
                                    id: 0, // TODO: Get id
                                    person: Profile(
                                      name: contact.displayName,
                                      contact:
                                          contact.phones.isNotEmpty
                                              ? contact.phones.first.number
                                              : '',
                                      avatarImage: contact.thumbnail,
                                    ),
                                    items: [],
                                  ),
                                )
                                .toList();

                        // Assigment unique ids to participants
                        for (int i = 0; i < selectedParticipants.length; i++) {
                          selectedParticipants[i] = Participant(
                            id: i,
                            person: selectedParticipants[i].person,
                            items: selectedParticipants[i].items,
                          );
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AssignmentPage(
                                  receipt: receipt!, //TODO: danger here
                                  participants: selectedParticipants,
                                ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PhosphorIcon(
                            //PhosphorIconsFill.handPointing,
                            PhosphorIconsRegular.squareHalf,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text('Manual', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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

  Widget _buildSelectedContactsRow() {
    // TODO: Remove horizontal margin
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Container(
        alignment: Alignment.centerLeft, // This ensures left alignment
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var contact in _selectedContacts)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage:
                              contact.thumbnail != null &&
                                      contact.thumbnail!.isNotEmpty
                                  ? MemoryImage(contact.thumbnail!)
                                  : null,
                          backgroundColor: _greyColor,
                          child:
                              contact.thumbnail == null ||
                                      contact.thumbnail!.isEmpty
                                  ? Text(
                                    contact.displayName.isNotEmpty
                                        ? contact.displayName[0]
                                        : '?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  )
                                  : null,
                        ),
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: IconButton(
                            icon: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(0.5),
                              child: PhosphorIcon(
                                PhosphorIconsFill.xCircle,
                                color: _greyColor,
                                size: 25.0,
                                semanticLabel: 'Remove',
                              ),
                            ),
                            onPressed: () => _unselectContact(contact),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactList() {
    return ListView.builder(
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        final isSelected = _selectedContacts.contains(contact);
        return ListTile(
          leading:
              contact.thumbnail != null && contact.thumbnail!.isNotEmpty
                  ? CircleAvatar(
                    backgroundImage: MemoryImage(contact.thumbnail!),
                  )
                  : CircleAvatar(
                    backgroundColor: _greyColor,
                    child: Text(
                      contact.displayName.isNotEmpty
                          ? contact.displayName[0]
                          : '?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          title: Text(contact.displayName),
          trailing:
              isSelected
                  ? PhosphorIcon(
                    PhosphorIconsFill.checkCircle,
                    color: _greenColor,
                    size: 30.0,
                    semanticLabel: 'Selected',
                  )
                  : PhosphorIcon(
                    PhosphorIconsRegular.circle,
                    color: _greyColor,
                    size: 30.0,
                    semanticLabel: 'Not selected',
                  ),
          onTap: () => _toggleSelection(contact),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: _filterContacts,
      decoration: InputDecoration(
        hintText: 'Pesquisar contacto...',
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
