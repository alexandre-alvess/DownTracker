import 'package:AppDown/DataAccess/AnswerDAO.dart';
import 'package:AppDown/Shared/Models/AnswerModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnswerProvider with ChangeNotifier
{
  final serviceDAO = new AnswerDAO();

  List<AnswerModel> _items = [];

  List<AnswerModel> get items
  {
    return [..._items];
  }

  int get count
  {
    return _items.length;
  }

  Future<void> loadAnswers() async
  {
    _items.clear();

    var query = FirebaseFirestore.instance.collection('answers').get();

    await query.then((snapshot) async {
      snapshot.docs.forEach((element) { 
        
        var data = element.data();

        AnswerModel model = AnswerModel();
        model.id = element.id;
        model.answer = data['answer'];
        model.dataInclusao = data['dataInclusao'];
        model.question = data['question'];
        model.monitored = data['monitored'];
        model.imageUrl = data['imageUrl'];

        _items.add(model);
      });
    });
  }

  Future<bool> addAnswers(AnswerModel model) async
  {
    try
    {
      await FirebaseFirestore.instance.collection('answers').add({
        'answer': model.answer,
        'dataInclusao': model.dataInclusao,
        'question': model.question,
        'monitored': model.monitored,
        'imageUrl': model.imageUrl
      });

      return true;  
      
    }
    catch (error)
    {
      return false;
    }
  }

  AnswerModel itemByIndex(int index)
  {
    return _items[index];
  }
}