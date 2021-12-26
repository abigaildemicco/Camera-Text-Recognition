//
//  TextTranslation.swift
//  CameraTextRecognition
//
//  Created by Abigail De Micco on 15/12/21.
//

import SwiftUI
import NaturalLanguage

struct TextTranslation{
    @Binding var textTranslated: String
    @Binding var textLanguage: String
    
    func language(of text: String){
        if let language = NLLanguageRecognizer.dominantLanguage(for: text) {
            textLanguage = language.rawValue
        } else {
            textLanguage = "NA"
        }
    }
    
    func translate(text: String) {
        //code to translate textTranslated = ....
    }
}

