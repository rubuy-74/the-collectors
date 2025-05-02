import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:animations/animations.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:usettle/models/item.dart';
import 'package:dotted_separator/dotted_separator.dart';
import 'package:usettle/models/participant.dart';
import 'package:usettle/models/receipt.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({
    super.key,
    required this.receipt,
    required this.participants,
  });

  final Receipt receipt;
  final List<Participant> participants;

  @override
  AssignmentState createState() => AssignmentState();
}

class AssignmentState extends State<AssignmentPage> {
  late int _currentIndex;
  int? _activeParticipant;
  bool assigning = false;

  Map<String, List<Item>> namedItems = {};

  Map<String, List<int?>> assignments = {};

  Set<String> expandedItems = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;

    for (final item in widget.receipt.items) {
      if (!namedItems.containsKey(item.name)) {
        namedItems[item.name] = [item];
      } else {
        namedItems[item.name]!.add(item);
      }
    }

    for (final item in widget.receipt.items) {
      assignments[item.id.toString()] = [];
      for (int i = 0; i < namedItems[item.name]!.length; i++) {
        assignments[item.id.toString()]!.add(null);
      }
    }

    for (int participantIndex = 0;
        participantIndex < widget.participants.length;
        participantIndex++) {
      final participant = widget.participants[participantIndex];

      for (final participantItem in participant.items) {
        final itemId = participantItem.id.toString();
        if (assignments.containsKey(itemId)) {
          final assignmentList = assignments[itemId]!;
          final availableSlot = assignmentList.indexWhere(
            (assignment) => assignment == null,
          );
          if (availableSlot >= 0) {
            assignmentList[availableSlot] = participant.id;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Fatura",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            formatDate(widget.receipt.date),
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ]),
                  ],
                ),
                Text(
                  "${widget.receipt.total}€",
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: !assigning
          ? FloatingActionButton(
              onPressed: _allItemsHaveAssignments()
                  ? () {
                      Navigator.pushNamed(context, '/confirmation');
                    }
                  : null,
              backgroundColor: _allItemsHaveAssignments()
                  ? Colors.green[800]
                  : Colors.grey[400],
              disabledElevation: 0,
              child: PhosphorIcon(
                PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
                size: 24,
                color: Colors.white,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Text("Comece por selecionar uma pessoa..."),
          ),
          DashedLine(
            color: Colors.grey,
            height: 2,
            width: double.infinity,
            axis: Axis.horizontal,
            dashWidth: 5,
            dashSpace: 3,
            strokeWidth: 1.5,
            padding: EdgeInsets.symmetric(vertical: 8),
          ),
          _buildParticipantsCarousel(),
          DashedLine(
            color: Colors.grey,
            height: 2,
            width: double.infinity,
            axis: Axis.horizontal,
            dashWidth: 5,
            dashSpace: 3,
            strokeWidth: 1.5,
            padding: EdgeInsets.symmetric(vertical: 14),
          ),
          Expanded(child: _buildItemsList()),
          if (assigning)
            SafeArea(
                child: Center(
              child: Positioned(
                bottom: 10,
                child: TextButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(13)),
                    backgroundColor: WidgetStatePropertyAll(Colors.green[800]),
                  ),
                  onPressed: () => setState(() {
                    assigning = false;
                  }),
                  child: const Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildItemsList() => SingleChildScrollView(
        child: Column(
          children: namedItems.entries.map((entry) {
            if (entry.value.length == 1) {
              return _buildItemCard(entry.value[0]);
            } else {
              return _buildExpanded(entry.value);
            }
          }).toList(),
        ),
      );

  Widget _buildExpanded(List<Item> items) {
    final itemName = items[0].name;
    final isExpanded = expandedItems.contains(itemName);
    final totalQuantity = items.length;

    final bool allItemsHaveAssignments = items.every((item) {
      final itemAssignments = assignments[item.id.toString()]!;
      return itemAssignments.any((assignment) => assignment != null);
    });

    final uniqueParticipantIds = <int>{};
    if (allItemsHaveAssignments) {
      for (final item in items) {
        final itemAssignments =
            assignments[item.id.toString()]!.whereType<int>().toList();
        uniqueParticipantIds.addAll(itemAssignments);
      }
    }

    final bool isActiveParticipantAssigned = _activeParticipant != null &&
        assigning &&
        uniqueParticipantIds.contains(_activeParticipant);

    return Container(
      margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
      decoration: BoxDecoration(
        color: (_activeParticipant != null &&
                assigning &&
                !isActiveParticipantAssigned)
            ? Colors.grey[100]
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    expandedItems.remove(itemName);
                  } else {
                    expandedItems.add(itemName);
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _activeParticipant != null && assigning
                            ? () => setState(() {
                                  bool allItemsAssignedToActiveParticipant =
                                      items.every((item) {
                                    final peopleAssignedToItem =
                                        assignments[item.id.toString()]!;
                                    return peopleAssignedToItem
                                        .contains(_activeParticipant);
                                  });

                                  for (final item in items) {
                                    final peopleAssignedToItem =
                                        assignments[item.id.toString()]!;

                                    if (peopleAssignedToItem.length == 1 &&
                                        peopleAssignedToItem[0] == null) {
                                      peopleAssignedToItem.clear();
                                    }

                                    if (allItemsAssignedToActiveParticipant) {
                                      peopleAssignedToItem.removeWhere(
                                          (assignedPerson) =>
                                              assignedPerson ==
                                              _activeParticipant);
                                    } else {
                                      if (!peopleAssignedToItem
                                          .contains(_activeParticipant)) {
                                        peopleAssignedToItem
                                            .add(_activeParticipant);
                                      }
                                    }
                                  }
                                })
                            : null,
                        child: SizedBox(
                          height: 25,
                          width: allItemsHaveAssignments
                              ? (14 * min(uniqueParticipantIds.length, 3) +
                                  (uniqueParticipantIds.length > 3 ? 22 : 8))
                              : 25,
                          child: Stack(
                            children: [
                              if (!allItemsHaveAssignments)
                                Positioned(
                                  left: 0,
                                  child: PhosphorIcon(
                                    color: Colors.grey[500],
                                    size: 25,
                                    PhosphorIcons.circleDashed(
                                      PhosphorIconsStyle.duotone,
                                    ),
                                  ),
                                )
                              else
                                ...List.generate(
                                  min(uniqueParticipantIds.length, 3),
                                  (index) {
                                    final participantId =
                                        uniqueParticipantIds.elementAt(index);
                                    return Positioned(
                                      left: index * 14.0,
                                      child: CircleAvatar(
                                        radius: 11,
                                        backgroundColor: Colors.green[800],
                                        child: Text(
                                          widget.participants[participantId]
                                              .person.name[0]
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              if (allItemsHaveAssignments &&
                                  uniqueParticipantIds.length > 3)
                                Positioned(
                                  left: 14 * 3.0,
                                  top: 1,
                                  child: Container(
                                    height: 21.5,
                                    width: 21.5,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '+${uniqueParticipantIds.length - 3}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          itemName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: (_activeParticipant != null &&
                                    assigning &&
                                    !isActiveParticipantAssigned)
                                ? Colors.grey[400]
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'x$totalQuantity',
                          style: TextStyle(
                            color: (_activeParticipant != null &&
                                    assigning &&
                                    !isActiveParticipantAssigned)
                                ? Colors.grey[400]
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "${items.fold(0.0, (sum, item) => sum + item.price).toStringAsFixed(2)}€",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: (_activeParticipant != null &&
                                    assigning &&
                                    !isActiveParticipantAssigned)
                                ? Colors.grey[400]
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isExpanded
                  ? Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: items.map((item) {
                          final assignmentList =
                              assignments[item.id.toString()]!;
                          final itemAssignments =
                              assignmentList.whereType<int>().toList();
                          final hasAssignments = itemAssignments.isNotEmpty;

                          return GestureDetector(
                            onTap: _activeParticipant != null && assigning
                                ? () => setState(() {
                                      final peopleAssignedToItem =
                                          assignments[item.id.toString()]!;

                                      if (peopleAssignedToItem.length == 1 &&
                                          peopleAssignedToItem[0] == null) {
                                        final nullIndex =
                                            peopleAssignedToItem.indexOf(
                                          null,
                                        );
                                        if (nullIndex != -1) {
                                          peopleAssignedToItem.removeAt(
                                            nullIndex,
                                          );
                                        }
                                      }

                                      if (peopleAssignedToItem.contains(
                                        _activeParticipant,
                                      )) {
                                        final index = peopleAssignedToItem
                                            .indexOf(_activeParticipant);
                                        if (index != -1) {
                                          peopleAssignedToItem.removeAt(
                                            index,
                                          );
                                        }
                                      } else {
                                        peopleAssignedToItem.add(
                                          _activeParticipant,
                                        );
                                      }
                                    })
                                : null,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: (_activeParticipant != null &&
                                        assigning &&
                                        !itemAssignments
                                            .contains(_activeParticipant))
                                    ? Colors.grey[200]
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 25,
                                        width: hasAssignments
                                            ? (14 *
                                                    min(
                                                      itemAssignments.length,
                                                      3,
                                                    ) +
                                                (itemAssignments.length > 3
                                                    ? 22
                                                    : 8))
                                            : 25,
                                        child: Stack(
                                          children: _buildAvatarRow(
                                            item,
                                            1,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 6),
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: (_activeParticipant !=
                                                        null &&
                                                    assigning &&
                                                    !itemAssignments.contains(
                                                        _activeParticipant))
                                                ? Colors.grey[400]
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "x1",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: (_activeParticipant != null &&
                                                  assigning &&
                                                  !itemAssignments.contains(
                                                      _activeParticipant))
                                              ? Colors.grey[400]
                                              : Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "${item.price.toStringAsFixed(2)}€",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: (_activeParticipant != null &&
                                                  assigning &&
                                                  !itemAssignments.contains(
                                                      _activeParticipant))
                                              ? Colors.grey[400]
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(Item repeatedItem) {
    final bool isActiveParticipantAssigned = _activeParticipant != null &&
        assigning &&
        assignments[repeatedItem.id.toString()]!.contains(_activeParticipant);

    return Container(
      margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
      decoration: BoxDecoration(
        color: (_activeParticipant != null &&
                assigning &&
                !isActiveParticipantAssigned)
            ? Colors.grey[100]
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _activeParticipant != null && assigning
                  ? () => setState(() {
                        final peopleAssignedToItem =
                            assignments[repeatedItem.id.toString()]!;

                        if (peopleAssignedToItem.length == 1 &&
                            peopleAssignedToItem[0] == null) {
                          final nullIndex = peopleAssignedToItem.indexOf(null);
                          if (nullIndex != -1) {
                            peopleAssignedToItem.removeAt(nullIndex);
                          }
                        }

                        if (peopleAssignedToItem.contains(_activeParticipant)) {
                          final index = peopleAssignedToItem.indexOf(
                            _activeParticipant,
                          );
                          if (index != -1) {
                            peopleAssignedToItem.removeAt(index);
                          }
                        } else {
                          peopleAssignedToItem.add(_activeParticipant);
                        }
                      })
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                        width: 14 *
                                (max(
                                              1,
                                              assignments[repeatedItem.id
                                                      .toString()]!
                                                  .length,
                                            ) >
                                            3
                                        ? 4
                                        : max(
                                            1,
                                            assignments[
                                                    repeatedItem.id.toString()]!
                                                .length,
                                          ))
                                    .toDouble() +
                            8,
                        child: Stack(
                          children: _buildAvatarRow(repeatedItem, 1),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text(
                          repeatedItem.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: (_activeParticipant != null &&
                                    assigning &&
                                    !isActiveParticipantAssigned)
                                ? Colors.grey[400]
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'x1',
                              style: TextStyle(
                                fontSize: 15,
                                color: (_activeParticipant != null &&
                                        assigning &&
                                        !isActiveParticipantAssigned)
                                    ? Colors.grey[400]
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              '${repeatedItem.price.toStringAsFixed(2)}€',
                              style: TextStyle(
                                fontSize: 15,
                                color: (_activeParticipant != null &&
                                        assigning &&
                                        !isActiveParticipantAssigned)
                                    ? Colors.grey[400]
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAvatarRow(Item item, int displayCount) {
    final assignmentList = assignments[item.id.toString()]!;
    final assignedParticipants =
        assignmentList.where((a) => a != null).cast<int>().toList();
    final int assignedCount = assignedParticipants.length;

    final bool isIndividualInExpandedView =
        displayCount == 1 && namedItems[item.name]!.length > 1;

    if (isIndividualInExpandedView) {
      if (assignedCount == 0) {
        return [
          Positioned(
            left: 0,
            child: PhosphorIcon(
              color: Colors.grey[500],
              size: 25,
              PhosphorIcons.circleDashed(PhosphorIconsStyle.duotone),
            ),
          ),
        ];
      } else {
        final visibleAvatars = min(assignedCount, 3);
        final plusValue = assignedCount > 3 ? assignedCount - 3 : 0;

        return [
          ...List.generate(visibleAvatars, (index) {
            return Positioned(
              left: index * 14.0,
              child: CircleAvatar(
                radius: 11,
                backgroundColor: Colors.green[800],
                child: Text(
                  widget
                      .participants[assignedParticipants[index]].person.name[0]
                      .toUpperCase(),
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            );
          }),
          if (plusValue > 0)
            Positioned(
              left: 14 * 3.0,
              top: 1,
              child: Container(
                height: 21.5,
                width: 21.5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$plusValue',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ];
      }
    }

    final int totalQuantity = namedItems[item.name]?.length ?? 1;

    final int dashesToShow = assignedCount == 0 ? min(totalQuantity, 3) : 0;
    final int avatarsToShow = min(assignedCount, 3);

    final int remainingDashes = totalQuantity > 3 ? totalQuantity - 3 : 0;
    final int remainingAvatars = assignedCount > 3 ? assignedCount - 3 : 0;
    final int plusValue = remainingDashes + remainingAvatars;
    final bool showPlusIndicator = plusValue > 0;

    return [
      if (assignedCount == 0)
        ...List.generate(dashesToShow, (index) {
          return Positioned(
            left: index * 14.0,
            child: PhosphorIcon(
              color: Colors.grey[500],
              size: 25,
              PhosphorIcons.circleDashed(PhosphorIconsStyle.duotone),
            ),
          );
        }),
      ...List.generate(avatarsToShow, (index) {
        return Positioned(
          left: index * 14.0,
          child: CircleAvatar(
            radius: 11,
            backgroundColor: Colors.green[800],
            child: Text(
              widget.participants[assignedParticipants[index]].person.name[0]
                  .toUpperCase(),
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        );
      }),
      if (showPlusIndicator)
        Positioned(
          left: 14 * 3.0,
          top: 1,
          child: Container(
            height: 21.5,
            width: 21.5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '+$plusValue',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
    ];
  }

  Widget _buildActiveUserRow({Key? key}) {
    final participant =
        widget.participants.where((p) => p.id == _activeParticipant).first;

    final items = assignments.entries.where(
      (entry) => entry.value.contains(participant.id),
    );

    final totalAmount = items.fold(0.0, (sum, entry) {
      final id = entry.key;
      final item = widget.receipt.items.firstWhere(
        (i) => i.id.toString() == id,
      );
      return sum + item.price;
    });

    return GestureDetector(
        onTap: () {
          if (assigning) {
            setState(() {
              assigning = !assigning;
            });
          }
        },
        child: SizedBox(
          key: key,
          height: 140,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Text(
                      participant.person.name[0].toUpperCase(),
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Text(
                        items.length.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(participant.person.name,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                  Text(
                    "${totalAmount.toStringAsFixed(2)}€",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildParticipantsCarousel() {
    final pages = _chunkParticipants(widget.participants, 3);

    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          child: child,
        );
      },
      child: assigning
          ? _buildActiveUserRow(key: const ValueKey('activeUser'))
          : Column(
              key: const ValueKey('carousel'),
              children: [
                CarouselSlider.builder(
                  itemCount: pages.length,
                  itemBuilder: (context, pageIndex, realIndex) {
                    return _buildCarouselContent(pages[pageIndex]);
                  },
                  options: CarouselOptions(
                    height: 140,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: pages.length,
                  effect: WormEffect(
                    dotHeight: 4,
                    dotWidth: 4,
                    activeDotColor: Colors.green[800]!,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCarouselContent(List<Participant> participants) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: participants.map((participant) {
        final items = assignments.entries
            .where((entry) => entry.value.contains(participant.id))
            .toList();

        final totalAmount = items.fold(0.0, (sum, entry) {
          final id = entry.key;
          final item = widget.receipt.items.firstWhere(
            (i) => i.id.toString() == id,
          );
          return sum + item.price;
        });

        return Container(
          width: 90,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      assigning = true;
                      _activeParticipant = participant.id;
                    }),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey,
                      child: Text(
                        participant.person.name[0].toUpperCase(),
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Text(
                        items.length.toString(),
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                participant.person.name,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${totalAmount.toStringAsFixed(2)}€",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  bool _allItemsHaveAssignments() {
    return widget.receipt.items.every((item) {
      final assignmentList = assignments[item.id.toString()]!;

      return assignmentList.any((assignment) => assignment != null);
    });
  }

  String formatDate(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }

  List<List<Participant>> _chunkParticipants(
    List<Participant> participants,
    int chunkSize,
  ) {
    List<List<Participant>> chunks = [];
    for (var i = 0; i < participants.length; i += chunkSize) {
      chunks.add(
        participants.sublist(
          i,
          i + chunkSize > participants.length
              ? participants.length
              : i + chunkSize,
        ),
      );
    }
    return chunks;
  }
}
