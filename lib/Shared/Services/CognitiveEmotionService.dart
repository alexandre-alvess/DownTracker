import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CognitiveEmotionService
{
  Future<String> _analise(String base64Image) async
  {
    final url = "https://appdown.cognitiveservices.azure.com/";
    final String key = '37bb87bcf8f04d23bb91420e95887f06';

    final Map<String, String> headers = {
      'Content-Type': 'application/octet-stream',
      'Ocp-Apim-Subscription-Key': key
    };
    
    final Map<String, dynamic> map = {
      'face': base64Image
    };

    String s = jsonEncode(map);

    final response = await http.post(url, body: s, headers: headers);

    final responseBody = jsonDecode(response.body);

    if (responseBody['error'] != null)
    {
      throw Exception(responseBody['error']['message']);
    }
    else // retorna emocao com maior probabilidade
    {
      var resultEmotion = '';
      double max = 0;

      final List<String> emotions = [
        'anger', 
        'contempt',
        'disgust',
        'fear',
        'happiness',
        'neutral',
        'sadness',
        'surprise'];

      for (var emot in emotions)
      {
        double scoreEmotion = responseBody['scores'][emot];

        if (scoreEmotion > max)
        {
          max = scoreEmotion;
          resultEmotion = emot;
        }
      }

      return resultEmotion;
    }
  }

  Future<String> getEmotion(String urlImage) async
  {
    var file = await _toFile(urlImage);
    var base64Image = await _toBase64(file);

    try
    {
      return await _analise(base64Image);
    }
    catch(error)
    {
      return '';
    }
  }
 
  Future<String> _toBase64(File file) async
  {
    final bytes = await file.readAsBytes();
    var base64Image = base64Encode(bytes);
    return base64Image;
  }

  Future<File> _toFile(String urlImage) async
  {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.jpg');

    var response = await http.get(urlImage);

    await file.writeAsBytes(response.bodyBytes);

    return file;
  }
}