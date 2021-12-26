//
//  ContentView.swift
//  CameraTextRecognition
//
//  Created by Abigail De Micco on 15/12/21.
//

import SwiftUI
import NaturalLanguage

struct ContentView: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    
    //@ObservedObject var classifier: ImageClassifier = ImageClassifier()
    
    @ObservedObject var recognizedText: RecognizedText = RecognizedText()
    @State var recognizedLanguage: String = String()
    
    var body: some View {
        NavigationView {
            Group {
                if(!isPresenting) {
                            GeometryReader { geometry in
                                VStack{
                                    VStack{
                                        
                                        HStack(){
                                            Group {
                                                if uiImage != nil {
                                                    Image(uiImage: uiImage!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .cornerRadius(20)
                                                }
                                                else {
                                                    Image(uiImage: #imageLiteral(resourceName: "first-image.png"))
                                                        .resizable()
                                                        .frame(width: geometry.size.height * 0.33, height: geometry.size.height * 0.33)
                                                        .cornerRadius(20)
                                                }
                                            }
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.pink, lineWidth: 3)
                                            )
                                            .padding(.horizontal, 16)
                                            
                                            VStack(alignment: .center){
                                                Image(systemName: "camera")
                                                    .onTapGesture {
                                                        isPresenting = true
                                                    }
                                                    .font(.title)
                                                    .foregroundColor(.pink)
                                                    .padding(.vertical, 16)
                                                
                                                if(uiImage != nil) {
                                                    HStack{
                                                        Text("Italiano")
                                                            .foregroundColor(.white)
                                                        Spacer()
                                                        Image(systemName: "arrowtriangle.down.fill")
                                                            .foregroundColor(.white)
                                                    }
                                                    .padding(16)
                                                    .frame(width: 200, height: 40)
                                                    .background(RoundedRectangle(cornerRadius: 3, style: .continuous)
                                                                    .foregroundColor(.pink))
                                                }
                                                
                                            }
                                            .padding(.horizontal, 16)
                                        }
                                        .frame(height: geometry.size.height * 0.33)
                                        .padding(.vertical, 40)
                                        if (uiImage != nil) {
                                            HStack{
                                                HStack{
                                                    Text(recognizedLanguage)
                                                        .foregroundColor(.white)
                                                        .multilineTextAlignment(.center)
                                                        .padding()
                                                        .frame(width: 120, height: 40)
                                                        .background(RoundedRectangle(cornerRadius: 3, style: .continuous)
                                                                        .foregroundColor(.pink))
                                                    
                                                    Text("Italiano")
                                                        .foregroundColor(.white)
                                                        .multilineTextAlignment(.center)
                                                        .padding()
                                                        .frame(width: 120, height: 40)
                                                        .background(RoundedRectangle(cornerRadius: 3, style: .continuous)
                                                                        .foregroundColor(.black))
                                                }
                                                .padding(.horizontal, 40)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "speaker.wave.3")
                                                    .background(Circle()
                                                                    .foregroundColor(.pink)
                                                                    .frame(width: 40, height: 40)
                                                    )
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 40)
                                                
                                            }
                                            
                                            Spacer()
                                            
                                            
                                            
                                            
                                            
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
                                            
                                            ScrollView{
                                                Text(recognizedText.value)
                                                    .frame(width: geometry.size.width * 0.85, alignment: .leading)
                                                    .padding(20)
                                                    .lineLimit(nil)
                                                    .foregroundColor(.white)
                                                
                                            }
                                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                            .foregroundColor(.black)
                                            )
                                            .padding(.vertical, 20)
                                        }
                                        
                                        Spacer()
                                        
//                                        Divider()
//
//                                        HStack {
//                                            Button(action: {
//                                                //copy to clipboard
//                                            }, label: {
//                                                Image(systemName: "doc.on.doc")
//                                                    .font(.system(size: 20, weight: .medium, design: .default))
//                                            })
//                                                .accentColor(.pink)
//
//                                            Spacer()
//
//                                            Button(action: {
//                                                //share
//                                            }, label: {
//                                                Image(systemName: "square.and.arrow.up")
//                                                    .font(.system(size: 20, weight: .medium, design: .default))
//                                            })
//                                                .accentColor(.pink)
//
//                                        }
                                    }
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .background(Color.white)
                            }
                        }
                        else {
                            ZStack {
                                Color.black
                                    .ignoresSafeArea()
                            }
                            .sheet(isPresented: $isPresenting) {
                                CameraView(image: $uiImage)
                                    .onDisappear{
                                        if uiImage != nil {
                                            //classifier.detect(uiImage: uiImage!)
                                            let textRecognition: TextRecognition = TextRecognition(recognizedText: $recognizedText.value)
                                            let coordinator = textRecognition.makeCoordinator()
                                            coordinator.detectText(image: uiImage!)
                                            
                                            let textTranslation = TextTranslation(textTranslated: $recognizedText.value, textLanguage: $recognizedLanguage)
                                            textTranslation.language(of: recognizedText.value)
                                        }
                                    }
                            }
                            
                        }
            }
            .navigationTitle("Text Recognition")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar){
                                Button(action: {
                                    //copy to clipboard
                                }, label: {
                                    Image(systemName: "doc.on.doc")
                                })
                                    .accentColor(.pink)
                                
                                Spacer()
                                
                                Button(action: {
                                    //share
                                }, label: {
                                    Image(systemName: "square.and.arrow.up")
                                })
                                    .accentColor(.pink)
                            }
            }
            
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(classifier: ImageClassifier())
//    }
//}
