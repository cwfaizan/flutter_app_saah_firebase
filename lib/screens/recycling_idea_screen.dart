import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saah/providers/recycling_idea_provider.dart';
import 'package:saah/screens/recycling_idea_detail_screen.dart';

class RecyclingIdeaScreen extends StatefulWidget {
  const RecyclingIdeaScreen({Key? key}) : super(key: key);

  @override
  State<RecyclingIdeaScreen> createState() => _RecyclingIdeaScreenState();
}

class _RecyclingIdeaScreenState extends State<RecyclingIdeaScreen> {
  @override
  Widget build(BuildContext context) {
    final type = ModalRoute.of(context)!.settings.arguments as String;
    Provider.of<RecyclingIdeaProvider>(context, listen: false)
        .getRecyclingIdeasByType(type);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Ideas for your Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<RecyclingIdeaProvider>(
          builder: (context, recyclingIdeaProvider, child) =>
              recyclingIdeaProvider.recyclingIdeas.isEmpty
                  ? const Center(
                      child: Text(
                        'No Item Found',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: recyclingIdeaProvider.recyclingIdeas.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RecyclingIdeaDetailScreen(
                                path: recyclingIdeaProvider
                                    .recyclingIdeas[index].path),
                          ),
                        ),
                        child: Image.asset(
                          recyclingIdeaProvider.recyclingIdeas[index].path,
                          fit: BoxFit.fill,
                        ),
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    ),
        ),
      ),
    );
  }
}
