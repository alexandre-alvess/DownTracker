import 'package:DownTracker/Shared/Services/CognitiveEmotionService.dart';
import 'package:flutter/material.dart';

class DetailImageAnswerScreen extends StatefulWidget 
{
  final imageUrl;

  DetailImageAnswerScreen(this.imageUrl);

  @override
  _DetailImageAnswerScreenState createState() => _DetailImageAnswerScreenState();
}

class _DetailImageAnswerScreenState extends State<DetailImageAnswerScreen> 
{
  bool _isLoading = true;
  String _resultProcessed = 'SEM CLASSIFICAÇÃO DE EMOÇÃO';

  Future<void> _processImageRecognition() async
  {
    CognitiveEmotionService service = new CognitiveEmotionService();
    var result = await service.getEmotion(widget.imageUrl);

	setState(() {
		_resultProcessed = result;
	});
    

    return Future.value();
  }

  @override
  void initState() 
  {
    super.initState();
    _processImageRecognition().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IMAGEM CAPTURADA'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Image.network(widget.imageUrl), // carregar imagem aqui
            SizedBox(height: 10),
            _isLoading 
            ? Center(
              child: CircularProgressIndicator(),
            )
            : Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: Colors.black
                  ),
                ),
                child: Text(
                  _resultProcessed,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}