//
//  FavBookVC.swift
//  KSK
//
//  Created by Ацамаз on 29/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit

class FavBookVC: UIViewController {
    
    
    

    @IBOutlet weak var textView: UITextView!
    var textForTextView = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = textForTextView
        if UserDefaults.standard.integer(forKey: "Размер шрифта") != 0 {
            let fontSize = UserDefaults.standard.integer(forKey: "Размер шрифта")
            textView.font = textView.font?.withSize(CGFloat(fontSize))
            print(fontSize)
        }
            
        
        
    }
    
    
    
    @IBAction func removeFavorite(_ sender: UIBarButtonItem) {
        
        // Удалить из избранного текст и название
        var arrTitles = UserDefaults.standard.stringArray(forKey: "Массив названий")
        let index = arrTitles?.firstIndex(of: self.title!)
        arrTitles?.remove(at: index!)
        
        var arrTexts = UserDefaults.standard.stringArray(forKey: "Массив текстов")
        arrTexts?.remove(at: index!)
        
        UserDefaults.standard.set(arrTitles, forKey: "Массив названий")
        UserDefaults.standard.set(arrTexts, forKey: "Массив текстов")
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    


}
