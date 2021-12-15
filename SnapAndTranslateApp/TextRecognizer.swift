//
//  TextRecognizer.swift
//  SnapAndTranslateApp
//
//  Created by Abigail De Micco on 15/12/21.
//

import Vision
import SwiftUI
import Combine

public struct TextRecognizer {
    
    @Binding var recognizedText: String
    
    private let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue",
                                                         qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    func recognizeText(from image: CGImage) {
        self.recognizedText = ""
        var tmp = ""
        let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("The observations are of an unexpected type.")
                return
            }
            // Concatenate the recognised text from all the observations.
            let maximumCandidates = 1
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                tmp += candidate.string + "\n"
            }
        }
        textRecognitionRequest.recognitionLevel = .accurate
        let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
            
        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
        tmp += "\n\n"
        
        self.recognizedText = tmp
    }
    
}

final class RecognizedText: ObservableObject, Identifiable {
    
    let willChange = PassthroughSubject<RecognizedText, Never>()
    
    var value: String = "" {
        willSet {
            willChange.send(self)
        }
    }
    
}

