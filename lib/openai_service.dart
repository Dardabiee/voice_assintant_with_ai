import 'dart:convert';

import 'package:chat_assistant_ai/secrets.dart';
import 'package:http/http.dart' as http;


class OpenaiService {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try{
     final response = await http.post(Uri.parse('https://api.openai.com/v1/engines/davinci/completions'),
     headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIAPIKEY'
     },
     body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [{
          'role': 'user',
          'content': 'does this message wants to generate an AI image, picture, or anything similar? $prompt . simply answer yes or no'
         }
        ]
       })
     );
     print(response.body);
     if(response.statusCode == 200){
      String content = jsonDecode(response.body)['choices'][0]['message']['content'];
      content = content.trim();

      switch(content){
        case 'YES':
        case 'yes':
        case 'Yes.':
        case 'yes.':
          final response = await dallEAPI(prompt);
          return response;
        default:
          final response = await chatGPTAPI(prompt);
          return response;
      }
     }
     return 'An error occured';
    }catch(e){
      return e.toString();
    }
  }
  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt
    });
     try{
     final response = await http.post(Uri.parse('https://api.openai.com/v1/engines/davinci/completions'),
     headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIAPIKEY'
     },
     body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": messages
       })
     );
     
     if(response.statusCode == 200){
      String content = jsonDecode(response.body)['choices'][0]['message']['content'];
      content = content.trim();

      messages.add({
        'role': 'assistant',
        'content': content
      });
      return content;
     }
     return 'An error occured';
    }catch(e){
      return e.toString();
    }
  }
  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt
    });
     try{
     final response = await http.post(Uri.parse('https://api.openai.com/v1/images/generations'),
     headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIAPIKEY'
     },
     body: jsonEncode({
        'prompt': prompt,
        'n': 1,
       })
     );
     
     if(response.statusCode == 200){
      String imageUrl = jsonDecode(response.body)['data'][0]['url'];
      imageUrl = imageUrl.trim();

      messages.add({
        'role': 'assistant',
        'content': imageUrl
      });
      return imageUrl;
     }
     return 'An error occured';
    }catch(e){
      return e.toString();
    }
  }
}