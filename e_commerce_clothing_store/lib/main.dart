// import 'package:e_commerce_clothing_store/bloc/presentation/pages/searcing_page.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SearcingPage()
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.purple,
          inactiveTrackColor: Colors.grey[300],
          thumbColor: Colors.purple,
          overlayColor: Colors.purple.withOpacity(0.3),
        ),
      ),
      home: const FilterScreen(),
    );
  }
}

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? _selectedGender;
  String? _selectedBrand;
  RangeValues _priceRange = const RangeValues(16, 543);
  String? _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button action
          },
        ),
        title: const Text('Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildFilterButton(
                  label: 'All',
                  isSelected: _selectedGender == 'All',
                  onPressed: () => setState(() => _selectedGender = 'All'),
                ),
                const SizedBox(width: 8),
                _buildFilterButton(
                  label: 'Men',
                  isSelected: _selectedGender == 'Men',
                  onPressed: () => setState(() => _selectedGender = 'Men'),
                ),
                const SizedBox(width: 8),
                _buildFilterButton(
                  label: 'Women',
                  isSelected: _selectedGender == 'Women',
                  onPressed: () => setState(() => _selectedGender = 'Women'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Brand', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterButton(
                  label: 'Adidas',
                  isSelected: _selectedBrand == 'Adidas',
                  onPressed: () => setState(() => _selectedBrand = 'Adidas'),
                ),
                _buildFilterButton(
                  label: 'Puma',
                  isSelected: _selectedBrand == 'Puma',
                  onPressed: () => setState(() => _selectedBrand = 'Puma'),
                  selectedColor: Colors.purple,
                  selectedTextColor: Colors.white,
                ),
                _buildFilterButton(
                  label: 'CR7',
                  isSelected: _selectedBrand == 'CR7',
                  onPressed: () => setState(() => _selectedBrand = 'CR7'),
                ),
                _buildFilterButton(
                  label: 'Nike',
                  isSelected: _selectedBrand == 'Nike',
                  onPressed: () => setState(() => _selectedBrand = 'Nike'),
                  selectedColor: Colors.purple,
                  selectedTextColor: Colors.white,
                ),
                _buildFilterButton(
                  label: 'Yeezy',
                  isSelected: _selectedBrand == 'Yeezy',
                  onPressed: () => setState(() => _selectedBrand = 'Yeezy'),
                ),
                _buildFilterButton(
                  label: 'Supreme',
                  isSelected: _selectedBrand == 'Supreme',
                  onPressed: () => setState(() => _selectedBrand = 'Supreme'),
                  selectedColor: Colors.purple,
                  selectedTextColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Price Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${_priceRange.start.round()}'),
                Text('\$${_priceRange.end.round()}'),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
                // rangeOverlayShape: const RoundRangeSliderOverlayShape(overlayRadius: 12),
              ),
              child: RangeSlider(
                values: _priceRange,
                min: 0,
                max: 600,
                onChanged: (RangeValues values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterButton(
                  label: 'White',
                  isSelected: _selectedColor == 'White',
                  onPressed: () => setState(() => _selectedColor = 'White'),
                ),
                _buildFilterButton(
                  label: 'Black',
                  isSelected: _selectedColor == 'Black',
                  onPressed: () => setState(() => _selectedColor = 'Black'),
                  selectedColor: Colors.purple,
                  selectedTextColor: Colors.white,
                ),
                _buildFilterButton(
                  label: 'Grey',
                  isSelected: _selectedColor == 'Grey',
                  onPressed: () => setState(() => _selectedColor = 'Grey'),
                ),
                _buildFilterButton(
                  label: 'Yellow',
                  isSelected: _selectedColor == 'Yellow',
                  onPressed: () => setState(() => _selectedColor = 'Yellow'),
                  selectedColor: Colors.purple,
                  selectedTextColor: Colors.white,
                ),
                _buildFilterButton(
                  label: 'Red',
                  isSelected: _selectedColor == 'Red',
                  onPressed: () => setState(() => _selectedColor = 'Red'),
                ),
                _buildFilterButton(
                  label: 'Green',
                  isSelected: _selectedColor == 'Green',
                  onPressed: () => setState(() => _selectedColor = 'Green'),
                  selectedColor: Colors.purple,
                  selectedTextColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Another option'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Handle another option tap
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Handle apply filter action
                  print('Selected Gender: $_selectedGender');
                  print('Selected Brand: $_selectedBrand');
                  print('Price Range: ${_priceRange.start.round()} - ${_priceRange.end.round()}');
                  print('Selected Color: $_selectedColor');
                },
                child: const Text('Apply Filter', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
    Color? selectedColor,
    Color? selectedTextColor,
  }) {
    final backgroundColor = isSelected ? (selectedColor ?? Colors.purple) : Colors.grey[200];
    final textColor = isSelected ? (selectedTextColor ?? Colors.white) : Colors.black;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: const Size(0, 0), // Allow button to shrink
      ),
      child: Text(label, style: TextStyle(fontSize: 14)),
    );
  }
}

