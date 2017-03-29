//
//  ViewController.swift
//  Silly Song
//
//  Created by linlinno on 2017/3/9.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lyricsView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func reset(_ sender: Any) {
        nameField.text = ""
        lyricsView.text = ""
    }
    

    @IBAction func displayLyrics(_ sender: Any) {
        if let fullName = nameField.text{
            if(fullName.characters.count > 0){
                lyricsView.text = lyricsForName(lyricsTemplate: bananaFanaTemplate, fullName: fullName)
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

func shortNameFromName(fullName: String) -> String{
    let lowercaseName = fullName.lowercased()
    let vowelSet = CharacterSet.init(charactersIn: "aeiou")
    
    if let firstVowelIndex = lowercaseName.rangeOfCharacter(from: vowelSet)?.lowerBound {
        return fullName.substring(from: firstVowelIndex)
    }
    return fullName
}

let bananaFanaTemplate = [
    "<FULL_NAME>, <FULL_NAME>, Bo B<SHORT_NAME>",
    "Banana Fana Fo F<SHORT_NAME>",
    "Me My Mo M<SHORT_NAME>",
    "<FULL_NAME>"].joined(separator: "\n")

func lyricsForName(lyricsTemplate: String, fullName: String) -> String {
    let shortName = shortNameFromName(fullName: fullName)
    let lyrics = bananaFanaTemplate
        .replacingOccurrences(of: "<FULL_NAME>",with:fullName)
        .replacingOccurrences(of: "<SHORT_NAME>",with:shortName)
    
    return lyrics
}


