//
//  ImageClassifier.swift
//  CameraTextRecognition
//
//  Created by Abigail De Micco on 15/12/21.
//

import SwiftUI

class ImageClassifier: ObservableObject {
    
    @Published private var classifier = Classifier()
    
    var imageClass: String? {
        classifier.results
    }
        
    // Intent(s)
    func detect(uiImage: UIImage) -> String {
        guard let ciImage = CIImage (image: uiImage) else { return "" }
        return classifier.detect(ciImage: ciImage)
    }
        
}
