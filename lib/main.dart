import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const List<Item> _items = [
  Item(
    name: 'Pizza Veg',
    totalPriceCents: 2199,
    uid: '1',
    imageProvider: NetworkImage(
        'https://plus.unsplash.com/premium_photo-1675451537771-0dd5b06b3985?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    stock: '2 pieces left',
  ),
  Item(
    name: 'Ice Mokito',
    totalPriceCents: 1590,
    uid: '2',
    imageProvider: NetworkImage(
        'https://images.unsplash.com/photo-1497534446932-c925b458314e?q=80&w=2272&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    stock: '2 Piece Left',
  ),
  Item(
    name: 'Pizza Tuna',
    totalPriceCents: 2499,
    uid: '3',
    imageProvider: NetworkImage(
        'https://images.unsplash.com/photo-1613564834361-9436948817d1?q=80&w=2243&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    stock: '2 Piece Left',
  ),
  Item(
    name: 'Juice',
    totalPriceCents: 1250,
    uid: '4',
    imageProvider: NetworkImage(
        'https://images.unsplash.com/photo-1534353473418-4cfa6c56fd38?q=80&w=2187&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    stock: '2 Piece Left',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OrderingApp(),
    );
  }
}

class OrderingApp extends StatefulWidget {
  const OrderingApp({super.key});

  @override
  State<OrderingApp> createState() => _OrderingAppState();
}

class _OrderingAppState extends State<OrderingApp>
    with TickerProviderStateMixin {
  final List<Customer> _people = [
    Customer(
      name: 'Table 1',
      imageProvider: const NetworkImage(
          'https://th.bing.com/th/id/OIP.ipp7AwkJ1y5j-FPq9OiQxgHaHa?rs=1&pid=ImgDetMain'),
    ),
    Customer(
      name: 'Table 2',
      imageProvider: const NetworkImage(
          'https://th.bing.com/th/id/OIP.ipp7AwkJ1y5j-FPq9OiQxgHaHa?rs=1&pid=ImgDetMain'),
    ),
    Customer(
      name: 'Table 3',
      imageProvider: const NetworkImage(
          'https://th.bing.com/th/id/OIP.ipp7AwkJ1y5j-FPq9OiQxgHaHa?rs=1&pid=ImgDetMain'),
    )
  ];

  final GlobalKey _draggableKey = GlobalKey();

  void _itemDroppedOnCostomerCart(
      {required Item item, required Customer customer}) {
    setState(() {
      customer.items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildContent());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('POS Monitoring System'));
  }

  Widget _buildContent() {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMenuList(),
              ),
              _buildPeopleRow()
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMenuList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildMenuItem(item: item);
      },
      itemCount: _items.length,
    );
  }

  Widget _buildMenuItem({required Item item}) {
    return LongPressDraggable<Item>(
        data: item,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: DraggingListItem(
          dragKey: _draggableKey,
          photoProvider: item.imageProvider,
        ),
        child: MenuListItem(
          name: item.name,
          price: item.formattedTotalItemPrice,
          photoProvider: item.imageProvider,
        ));
  }

  Widget _buildPeopleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Row(
        children: _people.map(_buildPersonWithDropZone).toList(),
      ),
    );
  }

  Widget _buildPersonWithDropZone(Customer customer) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child:
            DragTarget<Item>(builder: (context, candidateItems, rejectedItems) {
          return CustomerCart(
            highlighted: candidateItems.isNotEmpty,
            customer: customer,
          );
        }, onAccept: (item) {
          _itemDroppedOnCostomerCart(item: item, customer: customer);
        }),
      ),
    );
  }
}

class CustomerCart extends StatefulWidget {
  const CustomerCart({
    super.key,
    required this.customer,
    this.highlighted = false,
  });

  final Customer customer;
  final bool highlighted;

  @override
  State<CustomerCart> createState() => _CustomerCartState();
}

class _CustomerCartState extends State<CustomerCart> {
  @override
  Widget build(BuildContext context) {
    final textColor = widget.highlighted ? Colors.white : Colors.black;

    return Transform.scale(
        scale: widget.highlighted ? 1.075 : 1.0,
        child: Material(
          elevation: widget.highlighted ? 8 : 4,
          borderRadius: BorderRadius.circular(22),
          color: widget.highlighted ? const Color(0xFFF64209) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.customer.items.clear();
                    });
                  },
                  child: const Icon(Icons.delete),
                ),
                ClipOval(
                  child: SizedBox(
                    width: 46,
                    height: 46,
                    child: Image(
                        image: widget.customer.imageProvider,
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.customer.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight: widget.customer.items.isNotEmpty
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                ),
                Visibility(
                  visible: widget.customer.items.isNotEmpty,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        widget.customer.formattedTotalItemPrice,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.customer.items.length} item${widget.customer.items.length != 1 ? 's' : ''}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: textColor,
                                  fontSize: 12,
                                ),
                      ),
                      Text(
                        'Proceed To Pay >>',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.redAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class MenuListItem extends StatelessWidget {
  const MenuListItem({
    super.key,
    this.name = '',
    this.price = '',
    required this.photoProvider,
    this.isDepressed = false,
    this.stock = '',
  });

  final String name;
  final String price;
  final ImageProvider photoProvider;
  final bool isDepressed;
  final String stock;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: isDepressed ? 115 : 120,
                    width: isDepressed ? 115 : 120,
                    child: Image(
                      image: photoProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
}

class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    super.key,
    required this.dragKey,
    required this.photoProvider,
  });

  final GlobalKey dragKey;
  final ImageProvider photoProvider;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Opacity(
            opacity: 0.85,
            child: Image(
              image: photoProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class Item {
  const Item({
    required this.totalPriceCents,
    required this.name,
    required this.uid,
    required this.imageProvider,
    required String stock,
  });

  final int totalPriceCents;
  final String name;
  final String uid;
  final ImageProvider imageProvider;
  String get formattedTotalItemPrice =>
      'RM${(totalPriceCents / 100.0).toStringAsFixed(2)}';
}

class Customer {
  Customer({
    required this.name,
    required this.imageProvider,
    List<Item>? items,
  }) : items = items ?? [];

  final String name;
  final ImageProvider imageProvider;
  final List<Item> items;

  String get formattedTotalItemPrice {
    final totalPriceCents =
        items.fold<int>(0, (prev, item) => prev + item.totalPriceCents);
    return 'RM${(totalPriceCents / 100.0).toStringAsFixed(2)}';
  }
}
