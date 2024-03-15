import 'package:cidtmi/screens/desktop/shop/product_desktop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../bloc/cart_model.dart';
import '../../../bloc/dates_state_bloc.dart';
import 'menu_categories.dart';

class StoreDesktopView extends StatefulWidget {
  final ValueNotifier<bool> shopToTrue;
  final ValueNotifier <Map<String, dynamic>> mapProduct;
    const StoreDesktopView({
    super.key, required this.shopToTrue, required this.mapProduct,
  });

  @override
  State<StoreDesktopView> createState() => StoreDesktopViewState();
}

class StoreDesktopViewState extends State<StoreDesktopView> {
  final int _pageIndex = 0;
  late PageController _pageController;


  @override
  void initState() {
    super.initState();
    categorySelected = null;
    _scrollController = ScrollController();
    _pageController = PageController(initialPage: _pageIndex);
    Future.delayed(Duration.zero, () {
      navigateToProduct();
    });
  }

  void navigateToProduct() {
    if (widget.shopToTrue.value) {
      _pageController.jumpToPage(_pageIndex + 1);
    }
  }


  void goBack() {
    _pageController.jumpToPage(_pageIndex - 1);
  }

  // products
  final int _counterProduct = 1;

  //menu
  bool menuCategoriesBool = false;

  late ScrollController _scrollController;

  int? categorySelected;

  bool menuCategories = false;

  void updateCategorieSelected(int? newCategory, bool newState) {
    setState(() {
      categorySelected = newCategory;
      menuCategories = newState;
      selectedCategoriesMenu = [null];
    });
  }

  void selectedAllMenu() {
    setState(() {
      menuCategories = false;
      categorySelected = null;
    });
  }

  List<int?> selectedCategoriesMenu = [null];

  void updateSelectedCategoriesMenu(int? newCategory, int? parentCategory) {
    setState(() {
      int index = selectedCategoriesMenu.indexOf(parentCategory);
      if (index != -1) {
        // Si la categoría padre está en la lista, elimina todos los elementos a la derecha
        selectedCategoriesMenu = selectedCategoriesMenu.sublist(0, index + 1);
      }
      // Luego agrega la nueva categoría
      selectedCategoriesMenu.add(newCategory);
    });
  }

  void removeSelectedCategoriesMenu(int? newCategory) {
    setState(() {
      int? index = selectedCategoriesMenu.indexOf(newCategory);
      if (index != -1) {
        // Si el id está en la lista, elimina todos los elementos a la derecha
        selectedCategoriesMenu = selectedCategoriesMenu.sublist(0, index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<StoreDesktopViewState>.value(
      value: this,
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: Provider.of<ConnectionDatesBlocs>(context).categories,
        builder: (context, value, child) {
          final categorias = value;

          if (value.isEmpty) {
            return const Column(
              children: [
                SizedBox(
                  height: 300,
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              ],
            );
          } else {
            return ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable:
                    Provider.of<ConnectionDatesBlocs>(context).products,
                builder: (context, value, child) {
                  if (value.isEmpty) {
                    return const Column(
                      children: [
                        SizedBox(
                          height: 300,
                        ),
                        Center(
                          child: Text(
                            'No hay productos disponibles',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ],
                    );
                  } else {
                    final products = value;
                  return PageView(
                    controller: _pageController,
                    children: <Widget>[
                      Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, bottom: 30, top: 15),
                                  child: SizedBox(
                                    width: 150,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (menuCategories == false) {
                                            menuCategories = true;
                                          } else {
                                            menuCategories = false;
                                          }
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.category,
                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5),
                                            child: Text(
                                              'Categorias',
                                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                                  child: Wrap(
                                    spacing: 10,
                                    alignment: WrapAlignment.start,
                                    children: [
                                      for (final product in products) ...[
                                        if (categorySelected == null ||
                                            product['id_categorie_product'] ==
                                                categorySelected)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 13,
                                                left: 13,
                                                bottom: 20),
                                            child: SizedBox(
                                              height: 190,
                                              width: 240,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    bottom: 0,
                                                    child: Container(
                                                      height: 130,
                                                      width: 240,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                            const Offset(
                                                                1, 1),
                                                            blurRadius: 10,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                0.2),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 20),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 15,
                                                              bottom: 15,
                                                              right: 10),
                                                          child: SizedBox(
                                                            width: 100,
                                                            child:
                                                            Image.network(
                                                              product['mdcp'][0]['colors'][0]['photos'][0]['url'],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 70,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                        20),
                                                                    child:
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        final cart = Provider.of<CartModel>(
                                                                            context,
                                                                            listen:
                                                                            false);
                                                                        final success = cart.addProduct(
                                                                            product,
                                                                            _counterProduct);
                                                                        if (success) {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                                backgroundColor: Colors.green,
                                                                                content: Text('Producto agregado al carrito')),
                                                                          );
                                                                        } else {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                                backgroundColor: Colors.red,
                                                                                content: Text('Este producto ya está en el carrito')),
                                                                          );
                                                                        }
                                                                      },
                                                                      child:
                                                                      Container(
                                                                        height:
                                                                        35,
                                                                        width:
                                                                        35,
                                                                        decoration: const BoxDecoration(
                                                                            color: Colors.black,
                                                                            borderRadius: BorderRadius.only(
                                                                              topRight: Radius.circular(35),
                                                                              bottomRight: Radius.circular(35),
                                                                              topLeft: Radius.circular(35),
                                                                            )),
                                                                        child:
                                                                        const Icon(
                                                                          Icons
                                                                              .shopping_cart_outlined,
                                                                          color:
                                                                          Colors.white,
                                                                          size:
                                                                          20,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                product[
                                                                'name'],
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                    fontSize:
                                                                    14),
                                                                maxLines: 2,
                                                                // Limita a una línea de altura
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                    5),
                                                                child: Text(
                                                                  NumberFormat.simpleCurrency(
                                                                      locale:
                                                                      'en_US',
                                                                      decimalDigits:
                                                                      0)
                                                                      .format(product[
                                                                  'price_unit']),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                      13,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () {
                                                                  setState(() {
                                                                    widget.mapProduct.value = product;
                                                                  });
                                                                  _pageController.jumpToPage(_pageIndex + 1);
                                                                },
                                                                child:
                                                                Container(
                                                                  height: 25,
                                                                  width: 110,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: Colors
                                                                        .black87,
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        10),
                                                                  ),
                                                                  child: Center(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .remove_red_eye,
                                                                          color:
                                                                          Colors.white,
                                                                          size:
                                                                          12,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                          5,
                                                                        ),
                                                                        Text(
                                                                          'Ver producto',
                                                                          style: TextStyle(
                                                                              color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                              fontSize: 10),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 80,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 60,
                            left: 30,
                            child: menuCategories == true
                                ? Container(
                                    height: 300,
                                    width: 750,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Colors.grey)),
                                    child: categorias.isEmpty
                                        ? const Center(
                                            child: Text('Aun no ha categorias'),
                                          )
                                        : Scrollbar(
                                            thumbVisibility: true,
                                            controller: _scrollController,
                                            child: ListView.builder(
                                              controller: _scrollController,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  selectedCategoriesMenu.length,
                                              itemBuilder: (context, index) {
                                                final selectedCategory =
                                                    selectedCategoriesMenu[index];
                                                return MenuCategories(
                                                  idPadre: selectedCategory,
                                                  categories: categorias
                                                      .where((category) =>
                                                          category['id_padre'] ==
                                                          selectedCategory)
                                                      .toList(),
                                                  categoriesAll: categorias,
                                                  onCategorySelectedMenu:
                                                      updateSelectedCategoriesMenu,
                                                  onCategorySelected:
                                                      updateCategorieSelected,
                                                  offCategorySelectedMenu:
                                                      removeSelectedCategoriesMenu,
                                                  selectedMenuList:
                                                      selectedCategoriesMenu,
                                                  selectedAll: selectedAllMenu,
                                                );
                                              },
                                            ),
                                          ),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                      ProductDesktop(
                        product: widget.mapProduct.value
                      )
                    ],
                  );
                  }
                });
          }
        },
      ),
    );
  }
}
