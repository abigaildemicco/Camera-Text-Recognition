//
//  ContentView.swift
//  SnapAndTranslateApp
//
//  Created by Abigail De Micco on 15/12/21.
//

import SwiftUI
import NaturalLanguage

struct ContentView: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @ObservedObject var classifier: ImageClassifier = ImageClassifier()
    @ObservedObject var recognizedText: RecognizedText = RecognizedText()
    @State var recognizedLanguage: String = String()
    
    var body: some View {
        VStack{
            Button(action: {
                if uiImage != nil {
                    classifier.detect(uiImage: uiImage!)
                }
            }) {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.orange)
                    .font(.title)
            }
            VStack{
                
                
                
 

                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .frame(width: 200, height: 200)
                    .border(Color.orange, width: 4)
                    .overlay (
                        Group {
                            if uiImage != nil {
                                Image(uiImage: uiImage!)
                                    .resizable()
                                    .scaledToFit()
                                    }
                            else {
                                Text ("Take a snap!")
                            }
                        }
                        )

                Spacer()
                HStack{
                    Image(systemName: "photo.on.rectangle.angled")
                        .onTapGesture {
                            isPresenting = true
                            sourceType = .photoLibrary
                        }
                        .onAppear() {
                            
                        }
                    
                    Image(systemName: "camera")
                        .onTapGesture {
                            isPresenting = true
                            sourceType = .camera
                        }
                }
                .font(.title)
                .foregroundColor(.orange)
                
                
                
                
                //                Group {
                //                    if let imageClass = classifier.imageClass {
                //                        HStack{
                //                            Text("Image categories:")
                //                                .font(.caption)
                //                            Text(imageClass)
                //                                .bold()
                //                        }
                //                    } else {
                //                        HStack{
                //                            Text("Image categories: NA")
                //                                .font(.caption)
                //                        }
                //                    }
                //                }
                //                .font(.subheadline)
                //                .padding()
                VStack {
                    Text(recognizedLanguage)
                    Text(recognizedText.value)
                        .lineLimit(nil)
                    Spacer()
                    
                }
                
            }
        }
        
        .sheet(isPresented: $isPresenting){
            ImagePicker(uiImage: $uiImage, isPresenting:  $isPresenting, sourceType: $sourceType)
                .onDisappear{
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                        let textRecognition: TextRecognition = TextRecognition(recognizedText: $recognizedText.value)
                        let coordinator = textRecognition.makeCoordinator()
                        coordinator.detectText(image: uiImage!)
                        
                        let textTranslation = TextTranslation(textTranslated: $recognizedText.value, textLanguage: $recognizedLanguage)
                        textTranslation.language(of: recognizedText.value)
                    }
                }
            
        }
        
        .padding()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(classifier: ImageClassifier())
//    }
//}
