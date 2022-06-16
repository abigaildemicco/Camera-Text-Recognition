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
    @State var textMode: Bool = true
    
    @ObservedObject var classifier: ImageClassifier = ImageClassifier()
    
    @State var textToShow: String = ""
    @State var recognizedLanguage: String = String()
    
    var body: some View {
        
            Group {
                if(!isPresenting) {
                    GeometryReader { geometry in
                        VStack(alignment: .center, spacing: 10){
                                Spacer()
                                HStack{
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
                                                .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9)
                                                .cornerRadius(20)
                                        }
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.pink, lineWidth: 3)
                                    )
                                    .padding(.horizontal, 16)
                                
                                    
//                                    VStack(alignment: .center){
                                        
                                        //                                                if(uiImage != nil) {
                                        //                                                    HStack{
                                        //                                                        Text("Italiano")
                                        //                                                            .foregroundColor(.white)
                                        //                                                        Spacer()
                                        //                                                        Image(systemName: "arrowtriangle.down.fill")
                                        //                                                            .foregroundColor(.white)
                                        //                                                    }
                                        //                                                    .padding(16)
                                        //                                                    .frame(width: 200, height: 40)
                                        //                                                    .background(RoundedRectangle(cornerRadius: 3, style: .continuous)
                                        //                                                                    .foregroundColor(.pink))
                                        //                                                }
                                        
//                                    }
//                                    .padding(.horizontal, 16)
                                }
                            
                            if(uiImage == nil) {
                                Spacer()
                            }
                                
                                HStack(alignment: .center, spacing: 20){
                                    if (uiImage != nil) {
                                        HStack{
                                            Text(recognizedLanguage)
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .padding()
                                                .frame(width: 120, height: 40)
                                                .background(RoundedRectangle(cornerRadius: 3, style: .continuous)
                                                    .foregroundColor(.pink))
                                            
                                            //                                                    Text("Italiano")
                                            //                                                        .foregroundColor(.white)
                                            //                                                        .multilineTextAlignment(.center)
                                            //                                                        .padding()
                                            //                                                        .frame(width: 120, height: 40)
                                            //                                                        .background(RoundedRectangle(cornerRadius: 3, style: .continuous)
                                            //                                                                        .foregroundColor(.black))
                                        }
                                    }
                                    
                                    Image(systemName: "camera")
                                        .onTapGesture {
                                            isPresenting = true
                                        }
                                        .font(.title)
                                        .foregroundColor(.pink)
                                    
                                    
                                    //                                                Image(systemName: "speaker.wave.3")
                                    //                                                    .background(Circle()
                                    //                                                                    .foregroundColor(.pink)
                                    //                                                                    .frame(width: 40, height: 40)
                                    //                                                    )
                                    //                                                    .foregroundColor(.white)
                                    //                                                    .padding(.horizontal, 40)
                                    
                                }
                                .padding(16)
                                
                                
                                
                                if (uiImage != nil) {
                                    
                                    
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
                                        Text(textToShow)
                                            .frame(width: geometry.size.width * 0.85, alignment: .leading)
                                            .padding(20)
                                            .lineLimit(nil)
                                            .foregroundColor(.white)
                                        
                                    }
                                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .foregroundColor(Color(red: 0.125, green: 0.125, blue: 0.14))
                                    )
                                    .toolbar {
                                        ToolbarItemGroup(placement: .bottomBar){
                                            Button(action: {
                                                UIPasteboard.general.string = textToShow
                                            }, label: {
                                                Image(systemName: "doc.on.doc")
                                            })
                                            .accentColor(.pink)
                                            .disabled(textToShow == "")
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                let textToPass = textToShow+" - Recognized using Aby recognizer"
                                                print(uiImage!.description)
                                                let activityController = UIActivityViewController(activityItems: [uiImage!, textToPass], applicationActivities: nil)
                                                
                                                UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
                                            }, label: {
                                                Image(systemName: "square.and.arrow.up")
                                            })
                                            .accentColor(.pink)
                                            .disabled(textToShow == "")
                                        }
                                    }
                                    
                                    
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
                        CameraView(image: $uiImage, textMode: $textMode)
                            .onDisappear{
                                if uiImage != nil {
                                    if textMode {
                                        let textRecognition: TextRecognition = TextRecognition(recognizedText: $textToShow)
                                        let coordinator = textRecognition.makeCoordinator()
                                        coordinator.detectText(image: uiImage!)
                                        
                                        let textTranslation = TextTranslation(textTranslated: $textToShow, textLanguage: $recognizedLanguage)
                                        textTranslation.language(of: textToShow)
                                    }
                                    else {
                                        self.textToShow = classifier.detect(uiImage: uiImage!)
                                        self.recognizedLanguage = "English"
                                    }
                                }
                            }
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
