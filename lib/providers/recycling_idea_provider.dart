import 'package:flutter/material.dart';
import 'package:saah/models/recycling_idea.dart';

class RecyclingIdeaProvider with ChangeNotifier {
  final _recyclingIdeas = <RecyclingIdea>[
    RecyclingIdea(path: 'assets/chairs/c1.jpg', type: 'chair'),
    RecyclingIdea(path: 'assets/chairs/c2.jpg', type: 'chair'),
    RecyclingIdea(path: 'assets/chairs/c3.jpg', type: 'chair'),
    RecyclingIdea(path: 'assets/chairs/c4.jpg', type: 'chair'),
    RecyclingIdea(path: 'assets/chairs/c5.jpg', type: 'chair'),
    RecyclingIdea(path: 'assets/chairs/c6.jpg', type: 'chair'),
    RecyclingIdea(path: 'assets/tables/t1.jpg', type: 'table'),
    RecyclingIdea(path: 'assets/tables/t2.jpg', type: 'table'),
    RecyclingIdea(path: 'assets/tables/t3.jpg', type: 'table'),
    RecyclingIdea(path: 'assets/tables/t4.jpg', type: 'table'),
    RecyclingIdea(path: 'assets/tables/t5.jpg', type: 'table'),
    RecyclingIdea(path: 'assets/tables/t6.jpg', type: 'table'),
    RecyclingIdea(path: 'assets/tables/t7.jpg', type: 'table'),
    RecyclingIdea(path: 'assets/bottles/b1.jpg', type: 'bottle'),
    RecyclingIdea(path: 'assets/bottles/b2.jpg', type: 'bottle'),
    RecyclingIdea(path: 'assets/bottles/b3.jpg', type: 'bottle'),
    RecyclingIdea(path: 'assets/bottles/b4.jpg', type: 'bottle'),
    RecyclingIdea(path: 'assets/bottles/b5.jpg', type: 'bottle'),
    RecyclingIdea(path: 'assets/bottles/b6.jpg', type: 'bottle'),
  ];

  var lst = <RecyclingIdea>[];

  List<RecyclingIdea> get recyclingIdeas {
    return lst;
  }

  void getRecyclingIdeasByType(String type) {
    print('notifyListeners getRecyclingIdeasByType $type');
    lst = _recyclingIdeas.where((e) => e.type == type).toList();
    notifyListeners();
    print('notifyListeners getRecyclingIdeasByType $type');
  }
}
