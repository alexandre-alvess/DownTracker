import 'package:DownTracker/DataAccess/QuestionDAO.dart';
import 'package:DownTracker/Shared/Models/QuestionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class QuestionProvider with ChangeNotifier
{
  final serviceDAO = new QuestionDAO();
  
  List<QuestionModel> _items = [];

  List<QuestionModel> get items 
  {
    return [..._items];
  }

  int get count
  {
    return _items.length;
  }

  Future<void> loadQuestions() async
  {
    _items.clear();

    var query = FirebaseFirestore.instance.collection('question').get();

    await query.then((snapshot) async {
      snapshot.docs.forEach((element) {

        var data = element.data();

        QuestionModel model = new QuestionModel();
        model.id = element.id;
        model.question = data['question'];
        model.title = data['title'];
        
        _items.add(model);
      });
    });
    
    notifyListeners();
  }

  Future<bool> addQuestion(QuestionModel model) async
  {
    try
    {
      await FirebaseFirestore.instance.collection('question').add({
        'question': model.question,
        'title': model.title
      });

      _updateQuestions();

      return true;
    }
    catch (error)
    {
      return false;
    }
  }

  Future<bool> updateQuestion(QuestionModel model) async
  {
    try
    { 
      final questionData = {
        'question': model.question,
        'title': model.title
      };

      await FirebaseFirestore.instance.collection('question').doc(model.id).set(questionData);

      _updateQuestions();

      return true;
    }
    catch (error)
    {
      return false;
    }
  }

  void _updateQuestions() async
  {
    loadQuestions();    
  }

  QuestionModel itemByIndex(int index)
  {
    return _items[index];
  }
}