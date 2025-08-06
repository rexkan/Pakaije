// test/add_product_simple_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pakaije/vendor/add_product/add_product_model.dart';
import 'package:pakaije/flutter_flow/form_field_controller.dart';

void main() {
  group('Add Product Simple Tests', () {
    late AddProductModel model;

    // This runs before each test
    setUp(() {
      model = AddProductModel();
      // Initialize controllers if they're null
      model.itemNameTextController ??= TextEditingController();
      model.itemIdTextController ??= TextEditingController();
      model.priceTextController ??= TextEditingController();
      model.buyLinkTextController ??= TextEditingController();
      model.descriptionTextController ??= TextEditingController();

      // Initialize choice chip controllers
      model.choiceChipsValueController1 ??=
          FormFieldController<List<String>>(null);
      model.choiceChipsValueController2 ??=
          FormFieldController<List<String>>(null);
    });

    // This runs after each test
    tearDown(() {
      // Don't call dispose in tearDown since it's called multiple times
    });

    // Test 1: Check if model initializes correctly
    test('model should initialize with empty values', () {
      expect(model.itemNameTextController?.text, '');
      expect(model.itemIdTextController?.text, '');
      expect(model.priceTextController?.text, '');
      expect(model.categoryDropDownValue, isNull);
      expect(model.isDataUploading, false);
    });

    // Test 2: Test setting and getting text values
    test('should set and get text field values', () {
      // Set values
      model.itemNameTextController?.text = 'Test Product';
      model.itemIdTextController?.text = 'SKU123';
      model.priceTextController?.text = '29.99';

      // Check values
      expect(model.itemNameTextController?.text, 'Test Product');
      expect(model.itemIdTextController?.text, 'SKU123');
      expect(model.priceTextController?.text, '29.99');
    });

    // Test 3: Test category dropdown
    test('should set and get category value', () {
      model.categoryDropDownValue = 'Tops';
      expect(model.categoryDropDownValue, 'Tops');

      model.categoryDropDownValue = 'Bottoms';
      expect(model.categoryDropDownValue, 'Bottoms');
    });

    // Test 4: Test choice chips for colors
    test('should set and get color choice chip value', () {
      // Set the value using the controller
      model.choiceChipsValueController1?.value = ['Black'];
      expect(model.choiceChipsValue1, 'Black');

      model.choiceChipsValueController1?.value = ['White'];
      expect(model.choiceChipsValue1, 'White');
    });

    // Test 5: Test choice chips for occasions
    test('should set and get occasion choice chip value', () {
      // Set the value using the controller
      model.choiceChipsValueController2?.value = ['Casual'];
      expect(model.choiceChipsValue2, 'Casual');

      model.choiceChipsValueController2?.value = ['Formal'];
      expect(model.choiceChipsValue2, 'Formal');
    });

    // Test 6: Test upload state
    test('should toggle upload state', () {
      expect(model.isDataUploading, false);

      model.isDataUploading = true;
      expect(model.isDataUploading, true);

      model.isDataUploading = false;
      expect(model.isDataUploading, false);
    });

    // Test 7: Test form validation functions
    test('product name validation should work correctly', () {
      // Test empty name
      String? result = validateProductName('');
      expect(result, 'Product name is required');

      // Test short name
      result = validateProductName('A');
      expect(result, 'Product name must be at least 2 characters');

      // Test valid name
      result = validateProductName('Valid Product');
      expect(result, isNull);
    });

    // Test 8: Test item ID validation
    test('item ID validation should work correctly', () {
      // Test empty ID
      String? result = validateItemId('');
      expect(result, 'Item ID is required');

      // Test short ID
      result = validateItemId('AB');
      expect(result, 'Item ID must be at least 3 characters');

      // Test valid ID
      result = validateItemId('SKU123');
      expect(result, isNull);
    });

    // Test 9: Test price validation
    test('price validation should work correctly', () {
      // Test empty price
      String? result = validatePrice('');
      expect(result, 'Price is required');

      // Test invalid price
      result = validatePrice('not_a_number');
      expect(result, 'Please enter a valid price');

      // Test valid price
      result = validatePrice('29.99');
      expect(result, isNull);

      // Test integer price
      result = validatePrice('50');
      expect(result, isNull);
    });

    // Test 10: Test category validation
    test('category validation should work correctly', () {
      // Test null category
      String? result = validateCategory(null);
      expect(result, 'Category is required');

      // Test empty category
      result = validateCategory('');
      expect(result, 'Category is required');

      // Test valid category
      result = validateCategory('Tops');
      expect(result, isNull);
    });

    // Test 11: Test clearing form data
    test('should clear all form data', () {
      // Set some data first
      model.itemNameTextController?.text = 'Test Product';
      model.itemIdTextController?.text = 'SKU123';
      model.priceTextController?.text = '29.99';
      model.categoryDropDownValue = 'Tops';
      model.choiceChipsValueController1?.value = ['Black'];
      model.choiceChipsValueController2?.value = ['Casual'];

      // Clear data
      model.itemNameTextController?.clear();
      model.itemIdTextController?.clear();
      model.priceTextController?.clear();
      model.categoryDropDownValue = null;
      model.choiceChipsValueController1?.value = null;
      model.choiceChipsValueController2?.value = null;

      // Check if cleared
      expect(model.itemNameTextController?.text, '');
      expect(model.itemIdTextController?.text, '');
      expect(model.priceTextController?.text, '');
      expect(model.categoryDropDownValue, isNull);
      expect(model.choiceChipsValue1, isNull);
      expect(model.choiceChipsValue2, isNull);
    });

    // Test 12: Test model disposal (separate test that actually disposes)
    test('should dispose model without errors', () {
      // Create a separate model instance for disposal test
      final testModel = AddProductModel();
      testModel.itemNameTextController ??= TextEditingController();
      testModel.itemIdTextController ??= TextEditingController();

      expect(() => testModel.dispose(), returnsNormally);
    });
  });
}

// Helper validation functions (copy these from your widget)
String? validateProductName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Product name is required';
  }
  if (value.length < 2) {
    return 'Product name must be at least 2 characters';
  }
  return null;
}

String? validateItemId(String? value) {
  if (value == null || value.isEmpty) {
    return 'Item ID is required';
  }
  if (value.length < 3) {
    return 'Item ID must be at least 3 characters';
  }
  return null;
}

String? validatePrice(String? value) {
  if (value == null || value.isEmpty) {
    return 'Price is required';
  }
  if (double.tryParse(value) == null) {
    return 'Please enter a valid price';
  }
  return null;
}

String? validateCategory(String? value) {
  if (value == null || value.isEmpty) {
    return 'Category is required';
  }
  return null;
}
