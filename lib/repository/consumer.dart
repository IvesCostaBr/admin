import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core_dashboard/common/firebase.dart';


class ConsumerRepository {
  final FirebaseFirestore _firestore;

  ConsumerRepository() : _firestore = FirebaseFirestore.instance;

  // Certifique-se de que o Firebase está inicializado antes de usar o Firestore
  Future<void> _initializeFirebase() async {
    await FirebaseService().initialize();
  }

  // Busca todos os documentos na coleção 'consumers'
  Future<List<Map<String, dynamic>>> getConsumers() async {
    try {
      await _initializeFirebase();

      CollectionReference consumersCollection = _firestore.collection('consumers');
      QuerySnapshot snapshot = await consumersCollection.get();
      List<Map<String, dynamic>> consumers = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      return consumers;
    } catch (e) {
      print('Erro ao buscar consumidores: $e');
      rethrow;
    }
  }

  // Busca um documento na coleção 'consumers' por ID
  Future<Map<String, dynamic>?> getConsumerById(String id) async {
    try {
      // await _initializeFirebase();

      DocumentReference consumerDoc = _firestore.collection('consumers').doc(id);
      DocumentSnapshot snapshot = await consumerDoc.get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        print('Consumidor com ID $id não encontrado.');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar consumidor por ID: $e');
      rethrow;
    }
  }
}