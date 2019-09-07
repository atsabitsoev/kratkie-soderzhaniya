//
//  BookVC.swift
//  KSK
//
//  Created by Ацамаз on 19/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit
import SwiftSoup
import GoogleMobileAds


class BookVC: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    
    
    
    var selectedRowTitle = ""
    var urlOfText = ""
    var textOfBook = ""
    var addedToFav = false
    
    
    
    @IBOutlet weak var textView: UITextView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Реклама
        bannerView.adUnitID = "ca-app-pub-4230745985996569/8317372942"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        getTextFromUrl()
        
        //Название VC
        self.title = selectedRowTitle
        
        
        // Активити индикатор
        activityIndicator.startAnimating()
        activityView.layer.cornerRadius = 10
        
        // Проверяем, есть ли в избранном
        isAddedToFavortes()
        
        if UserDefaults.standard.integer(forKey: "Размер шрифта") != 0 {
            let fontSize = UserDefaults.standard.integer(forKey: "Размер шрифта")
            textView.font = textView.font?.withSize(CGFloat(fontSize))
            print(fontSize)
        }
        
    }
    
    
    
    
    
    //MARK: Мои функции
    
    
    
    
    // Функция, наполняющая массив картинками для каждого класса и ставящая эти картинки в нужные ячейки
    func getTextFromUrl () {
        
        
        let url = urlOfText
        let myUrl = URL(string: url)
        print(urlOfText)
        let URLTask = URLSession.shared.dataTask(with: myUrl!){
            myData, response, error in
            
            guard error == nil else { return }
            
            let myHTMLString = String(data: myData!, encoding: String.Encoding.utf8)
            
            
            do {
                
                let doc = try SwiftSoup.parse(myHTMLString!)
                
                do {
                    
                    // Что нам надо достать?
                    var element = try doc.select("p").array()
                    
                    
                    do{
                        
                        // Совершем все операции!
                        if nowBookFromWiki {
                            nowBookFromWiki = false
                        } else {
                            element.removeLast(2)
                        }
                        var isItFirst = true
                        for i in element {
                            
                            let string1 = try i.text()
                            
                            if isItFirst {
                                
                                self.textOfBook += "\t" + string1
                            
                            } else {
                                
                                self.textOfBook += "\n\t" + string1
                                
                                print(try i.text())
                                
                                isItFirst = false
                                
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.textView.text = self.textOfBook
                            
                            self.activityView.alpha = 0
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.alpha = 0
                            
                            
                        }
                        
                        
                    }catch {
                        
                    }
                    
                } catch {
                    
                }
                
            } catch {
                
            }
            
            
            
            
        }
        URLTask.resume()
        
    }
    
    
    
    
    // Кнопка "Добавить в избранное"
    @IBAction func butFavorites(_ sender: UIBarButtonItem) {
        
        print(addedToFav)
        
        if !addedToFav {
        // Добавить в избранное текст и название
        if var arrTitles = UserDefaults.standard.stringArray(forKey: "Массив названий") {
            arrTitles.append(self.title!)
            UserDefaults.standard.set(arrTitles, forKey: "Массив названий")
            print(arrTitles)
        } else {
            UserDefaults.standard.set([self.title], forKey: "Массив названий")
        }
        
        if var arrTexts = UserDefaults.standard.stringArray(forKey: "Массив текстов") {
            arrTexts.append(textView.text)
            UserDefaults.standard.set(arrTexts, forKey: "Массив текстов")
            print(arrTexts)
        } else {
            UserDefaults.standard.set([textView.text], forKey: "Массив текстов")
        }
        
        // Поменять картинку на "Сердце" и addedToFav = true
        self.navigationItem.rightBarButtonItem?.image = UIImage(named: "Сердце")
        addedToFav = true
        } else {
            // Удалить из избранного текст и название
            var arrTitles = UserDefaults.standard.stringArray(forKey: "Массив названий")
            let index = arrTitles?.firstIndex(of: self.title!)
            arrTitles?.remove(at: index!)
            
            var arrTexts = UserDefaults.standard.stringArray(forKey: "Массив текстов")
            arrTexts?.remove(at: index!)
            
            UserDefaults.standard.set(arrTitles, forKey: "Массив названий")
            UserDefaults.standard.set(arrTexts, forKey: "Массив текстов")
            
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "Пустое сердце")
            addedToFav = false
        }
        
    }
    
    
    
    
    // Определить если ли в избранном окрытая книга
    func isAddedToFavortes () {
        if let arrTitles = UserDefaults.standard.stringArray(forKey: "Массив названий") {
            if arrTitles.contains(self.title!) {
                self.navigationItem.rightBarButtonItem?.image = UIImage(named: "Сердце")
                addedToFav = true
            }
        }
    }
    
    
    


}
