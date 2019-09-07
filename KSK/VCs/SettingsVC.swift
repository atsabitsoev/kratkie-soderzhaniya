//
//  SettingsVC.swift
//  KSK
//
//  Created by Ацамаз on 19/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    
    
    
    @IBOutlet weak var sliderSize: UISlider!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var butFeedback: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.cornerRadius = 10
        butFeedback.layer.cornerRadius = 20
        sliderSize.detectCurrentFontSize()
        
    }
    

    
    @IBAction func sliderAction(_ sender: UISlider) {
        sliderSize.value = roundf(sliderSize.value)
        
        var sizeOfFont = 0
        switch sliderSize.value {
        case 1:
            sizeOfFont = 18
        case 2:
            sizeOfFont = 20
        case 3:
            sizeOfFont = 23
        case 4:
            sizeOfFont = 26
        case 5:
            sizeOfFont = 29
        default:
            sizeOfFont = 23
        }
        
        UserDefaults.standard.set(sizeOfFont, forKey: "Размер шрифта")
        
        textView.font = textView.font?.withSize(CGFloat(sizeOfFont))
    }
    
    
    
    
  
    
    
    
    
    
    @IBAction func feedbackAction(_ sender: UIButton) {
        guard let url = URL(string: "https://www.instagram.com/a.s.bitsoev/") else {return}
        UIApplication.shared.open(url)
    }
    
    
    

}



extension UISlider {
    func detectCurrentFontSize() {
        let fontSize = UserDefaults.standard.integer(forKey: "Размер шрифта")
        switch fontSize {
        case 18:
            self.value = 1
        case 20:
            self.value = 2
        case 23:
            self.value = 3
        case 26:
            self.value = 4
        case 29:
            self.value = 5
        default:
            self.value = 3
        }
    }
    
    
}
