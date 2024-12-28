import 'package:chat_assistant_ai/features_box.dart';
import 'package:chat_assistant_ai/openai_service.dart';
import 'package:chat_assistant_ai/pallete.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:animate_do/animate_do.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final OpenaiService openaiService = OpenaiService();
  final FlutterTts flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImageUrl;
  String lastWords = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }
  Future<void> initTextToSpeech()async{
    await flutterTts.setSharedInstance(true);
    setState(() {
      
    });
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {
      
    });
  }
  /// Each time to start a speech recognition session
  Future <void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future <void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }
  Future<void> systemSpeak(String content) async{
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          child: const Text('allen assistant')),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // virtual assistant picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top:4),
                      decoration: BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle
                      ),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage('assets/images/virtualAssistant.png'))
                    ),
                  )
                ]
              ),
            ),
            SlideInUp(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Pallete.borderColor
                    ),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.zero
                    )
                  ),
                  child:  Padding(
                    padding:  const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(generatedContent == null 
                    ? "Hello, I'm Allen. How can I help you today?" 
                    : generatedContent!, 
                    style: 
                    TextStyle(
                      fontSize: generatedContent == null ? 25 : 18, 
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if(generatedImageUrl!= null) Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(borderRadius: BorderRadius.circular(18),child: Image.network(generatedImageUrl!)),
            ),
            SlideInUp(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  alignment: Alignment.centerLeft,
                  child: const Text("Here are some features", style: TextStyle(
                    fontSize: 20,
                    color: Pallete.mainFontColor,
                    fontFamily: 'Cera Pro',
                    fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            // features list
            SlideInUp(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: const Column(
                  children: [
                    FeaturesBox(color: Pallete.firstSuggestionBoxColor,headerText: 'ChatGPT',descriptionText: 'A smarter way to recognized and informed with ChatGPT',),
                    FeaturesBox(color: Pallete.secondSuggestionBoxColor,headerText: 'Dall-E',descriptionText: 'Get inspired and stay creative with your personal assistant powered by Dall-E',),
                    FeaturesBox(color: Pallete.thirdSuggestionBoxColor,headerText: 'Smart Voice Assistant',descriptionText: 'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FadeIn(
        child: FloatingActionButton(
          onPressed: () async{
            if(await speechToText.hasPermission && speechToText.isNotListening){
              await startListening();
            }else if(speechToText.isListening){
              final speech = await openaiService.isArtPromptAPI(lastWords);
              if(speech.contains('https')){
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              }else{
                 generatedImageUrl = null;
                 generatedContent = speech;
                 await systemSpeak(speech);
                setState(() {});
        
              }
              await systemSpeak(speech);
              await stopListening();
            }else{
              initSpeechToText();
            }
        
          },
          child:  Icon(speechToText.isListening 
          ? Icons.stop 
          : Icons.mic),
          backgroundColor: Pallete.secondSuggestionBoxColor,
        ),
      ),
    );
  }
}