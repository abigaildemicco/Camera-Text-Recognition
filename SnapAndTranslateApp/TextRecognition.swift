//
//  TextRecognition.swift
//  SnapAndTranslateApp
//
//  Created by Abigail De Micco on 15/12/21.
//

import SwiftUI


struct TextRecognition {
    
    @Binding var recognizedText: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(recognizedText: $recognizedText)
    }
    
    class Coordinator: NSObject {
        
        var recognizedText: Binding<String>
        private let textRecognizer: TextRecognizer
        
        init(recognizedText: Binding<String>) {
            self.recognizedText = recognizedText
            textRecognizer = TextRecognizer(recognizedText: recognizedText)
        }
                
        public func detectText(image: UIImage) {
            let cgImage = image.cgImage
            guard cgImage != nil else { return }
            textRecognizer.recognizeText(from: cgImage!)
        }
        
    }

}
