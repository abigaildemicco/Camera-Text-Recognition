//
//  Classifier.swift
//  CameraTextRecognition
//
//  Created by Abigail De Micco on 15/12/21.
//

import CoreML
import Vision
import CoreImage

struct Classifier {
    
    private(set) var results: String?
    
    mutating func detect(ciImage: CIImage) -> String {
        
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model)
        else {
            return ""
        }
        
        let request = VNCoreMLRequest(model: model)
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        try? handler.perform([request])
        
        guard let results = request.results as? [VNClassificationObservation] else {
            return "Error"
        }
        
        if let firstResult = results.first {
            self.results = firstResult.identifier
        }
        
        return self.results != nil ? self.results! : ""
    }
    
}

