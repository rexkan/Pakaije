import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addWardrobeItem({
  required FakeFirebaseFirestore firestore,
  required String userId,
  required String imageUrl,
  required String name,
  required String category,
  required String color,
  String? styleTag,
  required String weatherSuitability,
  bool isFavourite = false,
}) async {
  // Prepare occasion list (style category)
  List<String> occasionList = [];
  if (styleTag != null && styleTag.isNotEmpty) {
    occasionList.add(styleTag);
  }

  // Prepare weather suitability list
  List<String> weatherList = [];
  if (weatherSuitability.isNotEmpty) {
    weatherList.add(weatherSuitability);
  }

  final wardrobeItemData = {
    'user_id': userId,
    'image_url': imageUrl,
    'name': name,
    'category': category,
    'color': color,
    'occasion': occasionList,
    'weather_suitability': weatherList,
    'date_added': FieldValue.serverTimestamp(),
    'is_favourite': isFavourite,
  };

  await firestore.collection('wardrobe_items').add(wardrobeItemData);
}

void main() {
  group('Add New Item - User Role Tests', () {
    late FakeFirebaseFirestore fakeFs;

    setUp(() {
      fakeFs = FakeFirebaseFirestore();
    });

    test('successfully adds wardrobe item with all required fields', () async {
      print('Starting test: successfully adds wardrobe item with all required fields');
      
      try {
        await addWardrobeItem(
          firestore: fakeFs,
          userId: 'user123',
          imageUrl: 'https://example.com/tshirt.jpg',
          name: 'Blue Casual T-Shirt',
          category: 'Tops',
          color: 'Blue',
          styleTag: 'Casual',
          weatherSuitability: 'Hot weather',
          isFavourite: false,
        );
        print('Wardrobe item created successfully');

        // Read back from the fake DB
        final snap = await fakeFs.collection('wardrobe_items').get();
        print('Retrieved ${snap.docs.length} documents');

        expect(snap.docs, hasLength(1), reason: 'One wardrobe item should be written');

        final data = snap.docs.first.data();
        print('Document data: $data');
        
        expect(data['user_id'], 'user123');
        expect(data['image_url'], 'https://example.com/tshirt.jpg');
        expect(data['name'], 'Blue Casual T-Shirt');
        expect(data['category'], 'Tops');
        expect(data['color'], 'Blue');
        expect(data['occasion'], ['Casual']);
        expect(data['weather_suitability'], ['Hot weather']);
        expect(data['is_favourite'], false);

        final ts = data['date_added'];
        print('Timestamp type: ${ts.runtimeType}');
        expect(ts, isA<Timestamp>());
        
        print('Test completed successfully');
      } catch (e, stackTrace) {
        print('Test failed with error: $e');
        print('Stack trace: $stackTrace');
        rethrow;
      }
    });

    test('adds wardrobe item without style tag (optional field)', () async {
      print('Starting test: adds wardrobe item without style tag');
      
      try {
        await addWardrobeItem(
          firestore: fakeFs,
          userId: 'user123',
          imageUrl: 'https://example.com/shoes.jpg',
          name: 'Black Sneakers',
          category: 'Shoes',
          color: 'Black',
          styleTag: null, // No style tag
          weatherSuitability: 'Hot weather',
        );
        print('Wardrobe item created successfully without style tag');

        final snap = await fakeFs.collection('wardrobe_items').get();
        expect(snap.docs, hasLength(1));

        final data = snap.docs.first.data();
        expect(data['occasion'], isEmpty, reason: 'Occasion list should be empty when no style tag provided');
        expect(data['name'], 'Black Sneakers');
        expect(data['category'], 'Shoes');
        
        print('Test completed successfully');
      } catch (e, stackTrace) {
        print('Test failed with error: $e');
        print('Stack trace: $stackTrace');
        rethrow;
      }
    });

    test('creates multiple wardrobe items for same user', () async {
      print('Starting test: creates multiple wardrobe items for same user');
      
      try {
        // Add first item
        await addWardrobeItem(
          firestore: fakeFs,
          userId: 'user123',
          imageUrl: 'https://example.com/shirt.jpg',
          name: 'White Shirt',
          category: 'Tops',
          color: 'White',
          styleTag: 'Formal',
          weatherSuitability: 'Hot weather',
        );

        // Add second item
        await addWardrobeItem(
          firestore: fakeFs,
          userId: 'user123',
          imageUrl: 'https://example.com/jeans.jpg',
          name: 'Blue Jeans',
          category: 'Bottoms',
          color: 'Blue',
          styleTag: 'Casual',
          weatherSuitability: 'Cold weather',
        );

        final snap = await fakeFs.collection('wardrobe_items').get();
        print('Retrieved ${snap.docs.length} documents');

        expect(snap.docs, hasLength(2), reason: 'Two wardrobe items should be written');
        
        final userIds = snap.docs.map((doc) => doc.data()['user_id']).toList();
        expect(userIds, everyElement('user123'), reason: 'All items should belong to same user');
        
        final categories = snap.docs.map((doc) => doc.data()['category']).toList();
        print('Categories found: $categories');
        expect(categories, containsAll(['Tops', 'Bottoms']));
        
        print('Test completed successfully');
      } catch (e, stackTrace) {
        print('Test failed with error: $e');
        print('Stack trace: $stackTrace');
        rethrow;
      }
    });

    test('handles different style categories correctly', () async {
      print('Starting test: handles different style categories correctly');
      
      try {
        final styleCategories = ['Casual', 'Formal', 'Party'];
        
        for (int i = 0; i < styleCategories.length; i++) {
          await addWardrobeItem(
            firestore: fakeFs,
            userId: 'user123',
            imageUrl: 'https://example.com/item$i.jpg',
            name: '${styleCategories[i]} Item',
            category: 'Tops',
            color: 'Black',
            styleTag: styleCategories[i],
            weatherSuitability: 'Hot weather',
          );
        }

        final snap = await fakeFs.collection('wardrobe_items').get();
        print('Retrieved ${snap.docs.length} documents');
        expect(snap.docs, hasLength(3), reason: 'Three items should be created');

        final occasions = snap.docs.map((doc) => (doc.data()['occasion'] as List).first).toList();
        print('Style categories found: $occasions');
        expect(occasions, containsAll(['Casual', 'Formal', 'Party']));
        
        print('Test completed successfully');
      } catch (e, stackTrace) {
        print('Test failed with error: $e');
        print('Stack trace: $stackTrace');
        rethrow;
      }
    });

    test('handles different weather suitability options correctly', () async {
      print('Starting test: handles different weather suitability options correctly');
      
      try {
        final weatherOptions = ['Hot weather', 'Cold weather'];
        
        for (int i = 0; i < weatherOptions.length; i++) {
          await addWardrobeItem(
            firestore: fakeFs,
            userId: 'user123',
            imageUrl: 'https://example.com/weather$i.jpg',
            name: '${weatherOptions[i]} Item',
            category: 'Tops',
            color: 'Grey',
            styleTag: 'Casual',
            weatherSuitability: weatherOptions[i],
          );
        }

        final snap = await fakeFs.collection('wardrobe_items').get();
        expect(snap.docs, hasLength(2));

        final weatherSuitabilities = snap.docs.map((doc) => (doc.data()['weather_suitability'] as List).first).toList();
        print('Weather options found: $weatherSuitabilities');
        expect(weatherSuitabilities, containsAll(['Hot weather', 'Cold weather']));
        
        print('Test completed successfully');
      } catch (e, stackTrace) {
        print('Test failed with error: $e');
        print('Stack trace: $stackTrace');
        rethrow;
      }
    });

    test('creates items for different users correctly', () async {
      print('Starting test: creates items for different users correctly');
      
      try {
        // Create item for user 1
        await addWardrobeItem(
          firestore: fakeFs,
          userId: 'user1',
          imageUrl: 'https://example.com/user1_item.jpg',
          name: 'User 1 Item',
          category: 'Tops',
          color: 'Blue',
          styleTag: 'Casual',
          weatherSuitability: 'Hot weather',
        );

        // Create item for user 2
        await addWardrobeItem(
          firestore: fakeFs,
          userId: 'user2',
          imageUrl: 'https://example.com/user2_item.jpg',
          name: 'User 2 Item',
          category: 'Bottoms',
          color: 'Black',
          styleTag: 'Formal',
          weatherSuitability: 'Cold weather',
        );

        final snap = await fakeFs.collection('wardrobe_items').get();
        expect(snap.docs, hasLength(2));

        final userIds = snap.docs.map((doc) => doc.data()['user_id']).toList();
        print('User IDs found: $userIds');
        expect(userIds, containsAll(['user1', 'user2']));
        
        // Verify each item belongs to correct user
        final user1Items = snap.docs.where((doc) => doc.data()['user_id'] == 'user1').toList();
        final user2Items = snap.docs.where((doc) => doc.data()['user_id'] == 'user2').toList();
        
        expect(user1Items, hasLength(1));
        expect(user2Items, hasLength(1));
        expect(user1Items.first.data()['name'], 'User 1 Item');
        expect(user2Items.first.data()['name'], 'User 2 Item');
        
        print('Test completed successfully');
      } catch (e, stackTrace) {
        print('Test failed with error: $e');
        print('Stack trace: $stackTrace');
        rethrow;
      }
    });
  });
}