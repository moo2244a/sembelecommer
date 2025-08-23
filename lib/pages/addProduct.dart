import 'package:doctor/addproduct_cubit/addproduct_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductPage extends StatefulWidget {
  String? pageState;
  AddProductPage({required this.pageState, super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();

  final List<String> mainCategories = [
    "Hoodies",
    "Shorts",
    "Shoes",
    "Bags",
    "Accessories",
  ];
  // قائمة المقاسات
  // المقاسات حسب الفئة
  final Map<String, List<String>> categorySizes = {
    "Hoodies": ["S", "M", "L", "XL", "XXL"],
    "Shorts": ["S", "M", "L", "XL"],
    "Shoes": ["39", "40", "41", "42", "43", "44", "45"],
    "Bags": ["Small", "Medium", "Large"],
    "Accessories": ["One Size"],
  };

  Map<String, List<String>> selectedSizes = {
    "Hoodies": [],
    "Shorts": [],
    "Shoes": [],
    "Bags": [],
    "Accessories": [],
  };
  List<String> selectedsubCategories = [];

  // الفئات الفرعية لكل فئة
  final Map<String, List<String>> subCategories = {
    'Hoodies': ['Men', 'Women', 'Kids'],

    'Shorts': ['Men', 'Women', 'Kids'],
    'Shoes': ['Men', 'Women', 'Kids'],
    'Bags': ['Men', 'Women', 'Kids'],

    'Accessories': ['Men', 'Women', 'Kids'],
  };
  bool hasDiscount = false; // هل المنتج له خصم؟
  final TextEditingController productDiscountController =
      TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => AddproductCubit()..getselectedMainCategory(widget.pageState),
      child: BlocConsumer<AddproductCubit, AddproductState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Add Product",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  _buildInputField(
                    controller: productNameController,
                    label: "Product Name",
                    icon: Icons.text_fields,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Choose Main Category",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white, // خلفية القائمة المنسدلة
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.category,
                        color: Colors.grey[700],
                      ), // أيقونة بلون رمادي واضح
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ), // لون الحدود
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100], // خلفية الحقل نفسها
                    ),
                    hint: Text(
                      "Choose Main Category",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ), // لون نص التلميح
                    ),
                    value:
                        BlocProvider.of<AddproductCubit>(
                          context,
                        ).selectedMainCategory,
                    items:
                        mainCategories
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ), // لون النصوص في العناصر
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      BlocProvider.of<AddproductCubit>(
                        context,
                      ).selectedMainCategor(value);
                    },
                  ),

                  const SizedBox(height: 20),

                  if (BlocProvider.of<AddproductCubit>(
                        context,
                      ).selectedMainCategory !=
                      null)
                    const Text(
                      "Choose Sub Category",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    children:
                        subCategories[BlocProvider.of<AddproductCubit>(
                              context,
                            ).selectedMainCategory]!
                            .map((subCat) {
                              final isSelected = selectedsubCategories.contains(
                                subCat,
                              );
                              return FilterChip(
                                label: Text(subCat),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedsubCategories.add(subCat);
                                    } else {
                                      selectedsubCategories.remove(subCat);
                                    }
                                  });
                                },
                                selectedColor:
                                    Colors
                                        .blueAccent, // لون الخلفية عند الاختيار
                                backgroundColor:
                                    Colors
                                        .grey[200], // لون الخلفية عند عدم الاختيار
                                checkmarkColor: Colors.white, // لون علامة الصح
                                labelStyle: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.black87, // لون النص
                                  fontWeight: FontWeight.w500,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            })
                            .toList(),
                  ),
                  SizedBox(height: 15),

                  // Product Price
                  _buildInputField(
                    controller: productPriceController,
                    label: "Product Price",
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Apply Discount?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: hasDiscount,
                        onChanged: (value) {
                          setState(() {
                            hasDiscount = value;
                            if (!hasDiscount) {
                              productDiscountController.clear();
                            }
                          });
                        },
                        activeColor: Colors.blueAccent,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (hasDiscount)
                    _buildInputField(
                      controller: productDiscountController,
                      label: "Discount (%)",
                      icon: Icons.discount,
                      keyboardType: TextInputType.number,
                    ),
                  SizedBox(height: 15),

                  // Product Description
                  _buildInputField(
                    controller: productDescriptionController,
                    label: "Product Description",
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 25),
                  // Sizes Section  Choose Sub Category
                  const Text(
                    "Choose Sizes",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    children:
                        (categorySizes[context
                                    .read<AddproductCubit>()
                                    .selectedMainCategory] ??
                                [])
                            .map((size) {
                              final isSelected = selectedSizes[context
                                      .read<AddproductCubit>()
                                      .selectedMainCategory]!
                                  .contains(size);
                              return FilterChip(
                                label: Text(size),
                                selected: isSelected,
                                onSelected: (sel) {
                                  setState(() {
                                    sel
                                        ? selectedSizes[context
                                                .read<AddproductCubit>()
                                                .selectedMainCategory]!
                                            .add(size)
                                        : selectedSizes[context
                                                .read<AddproductCubit>()
                                                .selectedMainCategory]!
                                            .remove(size);
                                  });
                                  print(
                                    selectedSizes[context
                                        .read<AddproductCubit>()
                                        .selectedMainCategory],
                                  );
                                },
                                selectedColor:
                                    Colors
                                        .blueAccent, // لون الخلفية عند الاختيار
                                backgroundColor: Colors.grey.shade100,
                                checkmarkColor: Colors.white,
                                labelStyle: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              );
                            })
                            .toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Add Colors",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      // عرض الألوان اللي تم اختيارها
                      ...BlocProvider.of<AddproductCubit>(
                        context,
                      ).seleColor.toList().map((color) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: color,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  BlocProvider.of<AddproductCubit>(
                                    context,
                                  ).seleColor.remove(color);
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(3),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      GestureDetector(
                        onTap:
                            () => BlocProvider.of<AddproductCubit>(
                              context,
                            ).pickColor(context),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.add, color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  // زر الإضافة
                  const Text(
                    "Upload Images",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AddproductCubit>(
                        context,
                      ).getimagegallery();
                    },
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade100,
                          style: BorderStyle.solid,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                      ),
                      child: Container(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (BlocProvider.of<AddproductCubit>(
                                      context,
                                    ).loginguploadImageToImgBB ==
                                    false)
                                ? Center(child: CircularProgressIndicator())
                                : SizedBox(),
                            Icon(
                              Icons.cloud_upload,
                              size: 40,
                              color: Colors.blueAccent,
                            ),

                            SizedBox(height: 8),
                            Text(
                              "Tap to upload",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Text(
                              "Upload product images",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                physics:
                                    const BouncingScrollPhysics(), // علشان يديك Scroll ناعم
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                itemCount:
                                    BlocProvider.of<AddproductCubit>(
                                      context,
                                    ).photo.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            BlocProvider.of<AddproductCubit>(
                                              context,
                                            ).photo[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: InkWell(
                                          onTap: () {
                                            BlocProvider.of<AddproductCubit>(
                                              context,
                                            ).clearImage(index);
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Upload Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final cubit = context.read<AddproductCubit>();
                        if (productNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter product name"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (BlocProvider.of<AddproductCubit>(
                          context,
                        ).data.contains(productNameController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Product already exists"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (productPriceController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter product price"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (productDescriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter product description"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (cubit.selectedMainCategory == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select main category"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (selectedsubCategories.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please select at least one subcategory",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if ((BlocProvider.of<AddproductCubit>(
                              context,
                            ).seleColor)
                            .isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select at least one color"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if ((selectedSizes[cubit.selectedMainCategory] ??
                                [])
                            .isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select at least one size"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (cubit.photo.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please upload at least one image"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          cubit.addprodutModel(
                            name: productNameController.text,
                            price: productPriceController.text,
                            description: productDescriptionController.text,
                            mainCategory: cubit.selectedMainCategory!,
                            subCategories: selectedsubCategories,
                            sizes: selectedSizes[cubit.selectedMainCategory]!,
                            images: cubit.photo,
                            color:
                                BlocProvider.of<AddproductCubit>(
                                  context,
                                ).seleColor,
                            discount:
                                hasDiscount &&
                                        productDiscountController
                                            .text
                                            .isNotEmpty
                                    ? int.parse(productDiscountController.text)
                                    : null,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white, // نص أبيض
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        "Upload",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is UploadtofirebasalSuss) {
            Navigator.pop(context);
          } else if (state is UploadtofirebasalFile) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Lost network"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: label,
          hintStyle: const TextStyle(color: Colors.black45),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
