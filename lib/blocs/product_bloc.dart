import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  ProductBloc({required this.categoryId, this.product}) {
    if (product != null) {
      unsavedData = Map.of(product!.data()! as Map<String, dynamic>);
      unsavedData['image'] = List.of(product!.get('image'));
      unsavedData['sizes'] = List.of(product!.get('sizes'));

      _createdController.add(true);
    } else if (product == null) {
      unsavedData = {
        'title': null,
        'description': null,
        'price': null,
        'image': [],
        'sizes': []
      };

      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  String categoryId;
  DocumentSnapshot? product;

  final _loadingController = BehaviorSubject<bool>();
  final _dataController = BehaviorSubject<Map>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  late Map<String, dynamic> unsavedData;

  void saveTitle(String? title) {
    unsavedData['title'] = title;
  }

  void saveDescription(String? description) {
    unsavedData['description'] = description;
  }

  void savePrice(String? price) {
    unsavedData['price'] = double.parse(price!);
  }

  void saveImage(List? image) {
    unsavedData['image'] = image;
  }

  void saveSizes(List? sizes) {
    unsavedData['sizes'] = sizes;
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);

    try {
      if (product != null) {
        await _uploadImages(product!.id);
        await product!.reference.update(unsavedData);
      } else {
        DocumentReference dr = await FirebaseFirestore.instance
            .collection('products')
            .doc(categoryId)
            .collection('items')
            .add(Map.from(unsavedData)..remove(("image")));
        await _uploadImages(dr.id);
        await dr.update(unsavedData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String productId) async {
    for (int i = 0; i < unsavedData["image"].length; i++) {
      if (unsavedData["image"][i] is String) continue;

      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(productId)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsavedData["image"][i]);


      unsavedData['image'][i] = await (await task).ref.getDownloadURL();

    }
  }

  void deleteProduct(){
    product!.reference.delete();
  }


  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
