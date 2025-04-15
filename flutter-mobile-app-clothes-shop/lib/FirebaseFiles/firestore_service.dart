import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference headwear = FirebaseFirestore.instance.collection('Headwear');
  final CollectionReference earrings = FirebaseFirestore.instance.collection('Earrings');
  final CollectionReference necklaces = FirebaseFirestore.instance.collection('Necklaces');
  final CollectionReference faceAccessory = FirebaseFirestore.instance.collection('FaceAccessory');
  final CollectionReference userFavorites = FirebaseFirestore.instance.collection('userFavorites');
  final CollectionReference adminRequests = FirebaseFirestore.instance.collection('adminRequests');
  final CollectionReference admin = FirebaseFirestore.instance.collection('admin');
  final CollectionReference shopUsers = FirebaseFirestore.instance.collection('shopUsers');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      print("No user is currently signed in.");
      return null;
    }
  }

  //CREATE
  Future<void> addProduct(String prodName, String linkWeb, String desc, double price, String category, String imageURL, String modelURL, String userId, double productHeightCm, double productWidthCm) async {
    final data = {
      'prodName': prodName,
      'linkWeb': linkWeb,
      'desc': desc,
      'price': price,
      'category': category,
      'imageURL': imageURL,
      'modelURL': modelURL,
      'productHeightCm': productHeightCm,
      'productWidthCm': productWidthCm,
    };
    //depending on the category, add to the corresponding collection
    try {
      CollectionReference collection;
      if(category == "Headwear"){
        collection = headwear;
      }
      else if(category == "Earrings"){
        collection = earrings;
      }
      else if(category == "Necklaces"){
        collection = necklaces;
      }
      else if(category == "FaceAccessory"){
        collection = faceAccessory;
      } else {
        throw Exception('Invalid category: $category');
      }

      DocumentReference prodRef = await collection.add(data);
      DocumentReference userRef = shopUsers.doc(userId);
      await userRef.set({
        'uploadedProducts' : FieldValue.arrayUnion([prodRef])
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<String> uploadImage(File file, String fileName) async {
    try {
      final ref = _storage.ref().child('product_images/$fileName');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<String> uploadModel(File file, String fileName) async {
    try {
      final ref = _storage.ref().child('product_models/$fileName');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload model: $e');
    }
  }
  //READ
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final headwearDocs = await headwear.get();
    final earringsDocs = await earrings.get();
    final necklacesDocs = await necklaces.get();
    final faceAccessoryDocs = await faceAccessory.get();

    final List<Map<String, dynamic>> products = [];

    for (var doc in headwearDocs.docs) {
      var productData = doc.data() as Map<String, dynamic>;
      productData['id'] = doc.id;
      products.add(productData);
    }
    for (var doc in earringsDocs.docs) {
      var productData = doc.data() as Map<String, dynamic>;
      productData['id'] = doc.id;
      products.add(productData);
    }
    for (var doc in necklacesDocs.docs) {
      var productData = doc.data() as Map<String, dynamic>;
      productData['id'] = doc.id;
      products.add(productData);
    }
    for (var doc in faceAccessoryDocs.docs) {
      var productData = doc.data() as Map<String, dynamic>;
      productData['id'] = doc.id;
      products.add(productData);
    }

    return products;
  }
  //UPDATE
  Future<void> updateProduct(String id, String category, String newProdName, String newLinkWeb, String newDesc, double newPrice, String newModel, String newImage, String userId, double productHeightCm, double productWidthCm) async {

    try {
      CollectionReference collection;
      if(category == "Headwear"){
        collection = headwear;
      }
      else if(category == "Earrings"){
        collection = earrings;
      }
      else if(category == "Necklaces"){
        collection = necklaces;
      }
      else if(category == "FaceAccessory"){
        collection = faceAccessory;
      } else {
        throw Exception('Invalid category: $category');
      }

      collection.doc(id).update({
        'prodName': newProdName,
        'linkWeb': newLinkWeb,
        'desc': newDesc,
        'price': newPrice,
        'imageURL': newImage,
        'modelURL': newModel,
        'productHeightCm': productHeightCm,
        'productWidthCm': productWidthCm,
      });

      final uploadedProductsDoc = shopUsers.doc(userId);
      final uploadedProductRef = FirebaseFirestore.instance.collection(category).doc(id);

      await uploadedProductsDoc.set({
        'uploadedProducts' : FieldValue.arrayRemove([uploadedProductRef])
      }, SetOptions(merge: true));

      await uploadedProductsDoc.set({
        'uploadedProducts' : FieldValue.arrayUnion([uploadedProductRef])
      }, SetOptions(merge: true));
  
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
  //DELETE
  Future<void> removeProduct(String id, String category, String shopUserId) async {
    try {
      CollectionReference collection;
      if(category == "Headwear"){
        collection = headwear;
      }
      else if(category == "Earrings"){
        collection = earrings;
      }
      else if(category == "Necklaces"){
        collection = necklaces;
      }
      else if(category == "FaceAccessory"){
        collection = faceAccessory;
      } else {
        throw Exception('Invalid category: $category');
      }

      final userFavoritesSnapshot = await userFavorites.get();
      for (var userDoc in userFavoritesSnapshot.docs) {
        final userId = userDoc.id;
        await removeFavorite(userId, id, category);
      }

      final uploadedProductsDoc = shopUsers.doc(shopUserId);
      final uploadedProductRef = FirebaseFirestore.instance.collection(category).doc(id);

      await uploadedProductsDoc.set({
        'uploadedProducts' : FieldValue.arrayRemove([uploadedProductRef])
      }, SetOptions(merge: true));

      await collection.doc(id).delete();

    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> deleteUserData(String userId) async {
    try {
      bool isShopUserAccount = await isShopUser(userId);

      if (isShopUserAccount) {
        final shopUsersDoc = await shopUsers.doc(userId).get();

        if (!shopUsersDoc.exists) {
          throw Exception('User does not exist in shopUsers collection.');
        }
        
        final Map<String, dynamic>? shopUserData = shopUsersDoc.data() as Map<String, dynamic>?;
        if (shopUserData == null || !shopUserData.containsKey('uploadedProducts')) {
          await shopUsers.doc(userId).delete();
          return;
        }

        final List<dynamic> uploadedProducts = shopUsersDoc['uploadedProducts'] ?? [];

        for (var productRef in uploadedProducts) {
          if (productRef is DocumentReference) {
            final productSnapshot = await productRef.get();

            if (productSnapshot.exists) {
              final productData = productSnapshot.data() as Map<String, dynamic>;
              final category = productData['category'] as String?;

              if (category != null) {
                await removeProduct(productRef.id, category, userId);
              }
            }
          }
        }
        await shopUsers.doc(userId).delete();
      } else {
        await userFavorites.doc(userId).delete();
      }
      print("User data deleted successfully for userId: $userId");
    } catch (e) {
      throw Exception('Failed to delete user data: $e');
    }
  }

  //FAVORITES
  Future<void> addFavorite(String userId, String productID, String category) async {
    final userFavoritesRef = userFavorites.doc(userId);
    final productRef = FirebaseFirestore.instance.collection(category).doc(productID);

    await userFavoritesRef.set({
      'favorites' : FieldValue.arrayUnion([productRef])
    }, SetOptions(merge: true));

    CollectionReference collection;
    if(category == "Headwear"){
      collection = headwear;
    }
    else if(category == "Earrings"){
      collection = earrings;
    }
    else if(category == "Necklaces"){
      collection = necklaces;
    }
    else if(category == "FaceAccessory"){
      collection = faceAccessory;
    } else {
      throw Exception('Invalid category: $category');
    }

    await collection.doc(productID).update({
      'likes': FieldValue.increment(1)
    });
  }

  Future<void> removeFavorite(String userId, String productId, String category) async {
    final userFavoritesRef = userFavorites.doc(userId);
    final productRef = FirebaseFirestore.instance.collection(category).doc(productId);

    await userFavoritesRef.set({
      'favorites' : FieldValue.arrayRemove([productRef])
    }, SetOptions(merge: true));

    CollectionReference collection;
    if(category == "Headwear"){
      collection = headwear;
    }
    else if(category == "Earrings"){
      collection = earrings;
    }
    else if(category == "Necklaces"){
      collection = necklaces;
    }
    else if(category == "FaceAccessory"){
      collection = faceAccessory;
    } else {
      throw Exception('Invalid category: $category');
    }

    await collection.doc(productId).update({
      'likes': FieldValue.increment(-1)
    });
  }

  Future<bool> isFavorite(String userId, String productId, String category) async {
    final userFavoritesRef = userFavorites.doc(userId);
    final userFavoritesSnapshot = await userFavoritesRef.get();

    if (!userFavoritesSnapshot.exists) {
      return false;
    }
    final List<dynamic>? favorites = userFavoritesSnapshot['favorites'] as List<dynamic>?;

    if (favorites == null || favorites.isEmpty) {
      return false;
    }
    final productRef = FirebaseFirestore.instance.collection(category).doc(productId);
    return favorites.any((fav) => fav.path == productRef.path);
  }

  Stream<List<DocumentSnapshot>> getUserFavorites(String userId) {
    final userFavoritesRef = userFavorites.doc(userId);

    return userFavoritesRef.snapshots().asyncMap((snapshot) async {
      if (snapshot.exists && snapshot.data() != null) {
        final List<DocumentReference> favoritesRefs = List.from(snapshot['favorites']);
        final futures = favoritesRefs.map((docRef) => docRef.get());
        return Future.wait(futures);
      }
      return [];
    });
  }

  //ADMIN
  Future<bool> isAdmin(String userId) async {
    final user = await admin.doc(userId).get();
    return user.exists;
  }

  Stream<List<Map<String, dynamic>>> getAllRequests() {
    return adminRequests.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }

  // Método para cambiar el estado de una solicitud (por ejemplo, "approved" o "denied").
  Future<void> updateRequestStatus(String requestId, String newStatus) async {
    try {
      await adminRequests.doc(requestId).update({'status': newStatus});
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }


  Future<void> deleteRequest(String requestId) async {
    try {
      await adminRequests.doc(requestId).delete();
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }

  Future<void> addShopUser(String userId, String shopName, String shopDescription, String shopWebsite) async {
    try {
      await shopUsers.doc(userId).set({
        'isAccepted': false,
        'shopName': shopName,
        'shopDescription': shopDescription,
        'shopWebsite': shopWebsite,
      });
    } catch (e) {
      throw Exception('Failed to add user to shopUsers: $e');
    }
  }

  Future<void> createAdminRequest(
    String userId, String shopName, String shopWebsite, String shopDescription) async {
    try {
      await adminRequests.doc(userId).set({
        'userId': userId,
        'shopName': shopName,
        'shopWebsite': shopWebsite,
        'shopDescription': shopDescription,
      });
    } catch (e) {
      throw Exception('Failed to create admin request: $e');
    }
  }

  Future<void> resendAdminRequest(String userId, String shopName, String shopWebsite, String shopDescription) async {
    try {
      createAdminRequest(userId, shopName, shopWebsite, shopDescription);
      shopUsers.doc(userId).update({
        'shopName': shopName,
        'shopDescription': shopDescription,
        'shopWebsite': shopWebsite,
      });
    } catch (e) {
      throw Exception('Failed to resend admin request: $e');
    }
  }

  Future<void> acceptAdminRequest(String userId) async {
    try {
      await shopUsers.doc(userId).update({
        'isAccepted': true,
      });

      await adminRequests.doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to accept admin request: $e');
    }
  }

  Future<void> denyAdminRequest(String userId) async {
    try {
      await adminRequests.doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete the request: $e');
    }
  }

  Future<bool> isShopUser(String userId) async {
    try {
      final userDoc = await shopUsers.doc(userId).get();
      return userDoc.exists; 
    } catch (e) {
      throw Exception('Failed to check if the user is a shop user: $e');
    }
  }

  Future<bool> isUserAccepted(String userId) async {
    try {
      final userDoc = await shopUsers.doc(userId).get();
      if (userDoc.exists) {
        return userDoc['isAccepted'] == true; 
      }
      return false;
    } catch (e) {
      throw Exception('Failed to check if the user has been accepted: $e');
    }
  }

  Future<String> checkRequestStatus(String userId) async {
    try {
      final adminRequestDoc = await adminRequests.doc(userId).get();
      if (adminRequestDoc.exists) {
        return "Pending"; 
      }

      final shopUserDoc = await shopUsers.doc(userId).get();
      if (shopUserDoc.exists && shopUserDoc['isAccepted'] == false) {
        return "Denied";
      }

      return "No Request Found"; 
    } catch (e) {
      throw Exception('Failed to check request status: $e');
    }
  }

  Stream<List<DocumentSnapshot>> getUploadedProducts(String userId) {
    final userDocRef = shopUsers.doc(userId);

    return userDocRef.snapshots().asyncMap((snapshot) async {
      if (snapshot.exists && snapshot.data() != null) {
        final List<dynamic> uploadedModels = snapshot['uploadedProducts'] ?? [];

        if (uploadedModels.isEmpty) {
          return [];
        }

        final futures = uploadedModels.map((docRef) => (docRef as DocumentReference).get());
        return Future.wait(futures);
      }
      return [];
    });
  }
}