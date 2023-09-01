import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getCollection(String collectionName) async 
{
  List data = [];

  CollectionReference collectionReference = db.collection(collectionName);

  QuerySnapshot querySnapshot = await collectionReference.get();

  for (var doc in querySnapshot.docs) 
  {
    final Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
    final String uid = doc.id;

    final docDataWithId = {
       'uid': uid, ...docData
    };

    data.add(docDataWithId);
  }

  return data;
}

Future<List> getSingleConditionQueriedCollection(String collectionName, String field, String relationalOperator, String value) async
{
  List data = [];

  CollectionReference collectionReference = db.collection(collectionName);

  Query<Object?> query;

  switch(relationalOperator)
  {
    case '==':
      query = collectionReference.where(field, isEqualTo: value);
    
    case "!=":
      query = collectionReference.where(field, isNotEqualTo: value);

    default:
      throw const FormatException('Invalid relational operator');
  }
   
  QuerySnapshot querySnapshot = await query.get();

  for (var doc in querySnapshot.docs) 
  {
    final Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
    final String uid = doc.id;

    final docDataWithId = {
       'uid': uid, ...docData
    };

    data.add(docDataWithId);
  }

  return data;
}

Future<List> getMultipleEqualToQueriedCollection(String collectionName, List<String> fields, List<String> values) async
{
  if(fields.length != values.length)
  {
    throw FormatException('Expected same numbers of fields and values, but intesead recived ${fields.length} fields and ${values.length} values');
  }

  if(fields.isEmpty || values.isEmpty)
  {
    throw const FormatException('Nor fileds or values must be empty');
  }

  List data = [];

  CollectionReference collectionReference = db.collection(collectionName);

  Query<Object?> query = collectionReference.where(fields[0], isEqualTo: values[0]);

  for (var i = 1; i < fields.length; i++) 
  {
    query = query.where(fields[i], isEqualTo: values[i]); 
  }
  
  QuerySnapshot querySnapshot = await query.get();

  for (var doc in querySnapshot.docs) 
  {
    final Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
    final String uid = doc.id;

    final docDataWithId = {
       'uid': uid, ...docData
    };

    data.add(docDataWithId);
  }

  return data;
}

Future<void> uploadDocument(String collectionName, Map<String, dynamic> data) async 
{
  await db.collection(collectionName).add(data);
}

Future<void> updateDocument(String collectionName, String documentId, Map<String, dynamic> newData) async 
{
  await db.collection(collectionName).doc(documentId).set(newData);
}

Future<void> deleteDocument(String collectionName, String documentId) async
{
  await db.collection(collectionName).doc(documentId).delete();
}
//await Future.delayed(const Duration(seconds: 5));