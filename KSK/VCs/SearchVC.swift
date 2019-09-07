//
//  SearchVC.swift
//  KSK
//
//  Created by Ацамаз on 19/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit
import TextFieldEffects
import SwiftSoup
import GoogleMobileAds

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    
    var searched = false
    var arrayOfLinks: [String] = []
    var arrayOfAuthorsNames: [[String]] = []
    var arrayOfLetters: [String] = []
    
    
    
    
    // Количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        if arrayOfLetters.count != 0 {
            
            
            return arrayOfLetters.count
            
            
        } else {
            
            
            return 1
            
            
        }
        
        
    }
    
    
    
    
    // Названия секций
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        
        if arrayOfLetters.count != 0 {
            
            
            return arrayOfLetters
            
            
        } else {
            
            
            return ["А"]
            
            
        }
    
        
    }
    
    
    
    
    // Количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if arrayOfAuthorsNames.count != 0 {
            
        
            return arrayOfAuthorsNames[section].count
            
            
        } else {
            
            
            return 1
            
            
        }
        
        
    }
    
    
    
    
    // Содержане ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSearch") as! SearchCell
        if arrayOfAuthorsNames.count != 0 {
            
            
            cell.labName.text = arrayOfAuthorsNames[indexPath.section][indexPath.row]
            
            
        }
        
        
        return cell
        
        
    }
    
    
    
    
    // Высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
    
    
    
    

    @IBOutlet weak var textFieldSearch: HoshiTextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Реклама
        bannerView.adUnitID = "ca-app-pub-4230745985996569/4186556247"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        textFieldSearch.delegate = self
        getArrayOfAuthors()
        activityIndicator.startAnimating()
        activityView.layer.cornerRadius = 10
        
        
    } // Конец viewDidLoad
    


    
    // Убрать клавиатуру при нажатии return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textFieldSearch.resignFirstResponder()
        return true
        
        
    }
    
    
    // Поиск
    @IBAction func poisk(_ sender: Any) {
        
        
        if textFieldSearch!.text! != "" && textFieldSearch!.text! != " " {
        
            
            for k in 0...arrayOfAuthorsNames.count - 1 {
                
            
                for i in arrayOfAuthorsNames[k] {
                    
                
                    print(i)
                    print(textFieldSearch!.text!)
                    
                
                    if i.hasPrefix(textFieldSearch!.text!) {
                        
                        
                        print("нашел")
                        print(textFieldSearch!.text!)
                        tableView.scrollToRow(
                            at: IndexPath(
                                row:arrayOfAuthorsNames[k].firstIndex(of: i)!,
                                section: k),
                            at: UITableView.ScrollPosition.top,
                            animated: false)
                        
                    
                        break
                    
                        
                    }
                
            
                }
            
                
            }
        
            
        } else {
            
        
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        
    
        }
    
        
    }
    
    
    
    
    // Передаем имя автора и ссылку при нажатии на ячейку
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "segue3" {
            
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                
                let destinationVC = segue.destination as! AuthorVC
                let currentCell = tableView.cellForRow(at: indexPath) as! SearchCell
                // Имя автора
                destinationVC.selectedRowTitle = currentCell.labName.text!
                // Ссылка
                var ind = 0
                for i in arrayOfAuthorsNames {
                    
                    for j in i {
                        
                        if j == currentCell.labName.text {
                            
                            destinationVC.selectedRowLink = arrayOfLinks[ind]
                            break
                            
                        }
                        
                        ind += 1
                        
                    }
                    
                }
                
                
                
                
                
                
            }
            
            
        }
        
        
    }
    
    
    
    
    //MARK: Мои функции
    
    
    
    
    // Функция, наполняющая массив букв и массив имен авторов
    func getArrayOfAuthors () {
        
        let url = "https://briefly.ru/authors"
        print(url)
        
       
        
        
        let myUrl = URL(string: url)
        
        let URLTask = URLSession.shared.dataTask(with: myUrl!){
            myData, response, error in
            
            guard error == nil else { return }
            
            let myHTMLString = String(data: myData!, encoding: String.Encoding.utf8)
            
            
            do {
                
                let doc = try SwiftSoup.parse(myHTMLString!)
                
                do {
                    
                    // Что нам надо достать?
                    let element = try doc.select("h3").array()
                    let element1 = try doc.select("a").array()
                    
                    
                    do{
                        
                       
                        // Все операции тут!!
                        
                        
                        // Буквы
                        for i in element {
                            
                            self.arrayOfLetters.append(try i.text())
                            self.arrayOfAuthorsNames.append([])
                            
                        }
                        
                        // Имена авторов
                        var arr1: [String] = []
                        // Ссылки
                        var arr2: [String] = []
                        
                        
                        for i in element1 {
                            
                            arr1.append(try i.text())
                            arr2.append(try i.attr("href"))
                           
                        }
                        
                        
                        arr1.removeFirst(9)
                        arr1.removeLast(5)
                        var k = 0
                        print(arr1)
                        
                        for i in arr1 {
                            
                            if i.first == Character(self.arrayOfLetters[k]) || i.first == "Й" || i.first == "Щ"{
                            
                                
                                self.arrayOfAuthorsNames[k].append(i)
                                
                                
                            } else {
                                
                                k += 1
                                self.arrayOfAuthorsNames[k].append(i)
                                
                                print(i.first ?? "Ошибка")
                            }
                            
                        }
                        
                        for i in self.arrayOfAuthorsNames {
                            
                            
                            print(i)
                            
                            
                        }
                        
                        
                        // Ссылки
                        
                        arr2.removeLast(5)
                        arr2.removeFirst(9)
                        
                        
                        for i in arr2 {
                            
                            
                            self.arrayOfLinks.append("https://briefly.ru" + i)
                            print("https://briefly.ru" + i)
                            
                            
                        }
                        
                        
                        DispatchQueue.main.async {
                            
                            
                            self.tableView.reloadData()
                            self.textFieldSearch.isUserInteractionEnabled = true
                            self.tableView.isUserInteractionEnabled = true
                            self.activityView.alpha = 0
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.alpha = 0
                                
                            
                        }
                        
                        
                    } catch {
                    }
                } catch {
                }
            } catch {
            }
        }
        
        
        URLTask.resume()
        
        
    }
    
    
    
    
    // Функция, заменяющая пробелы в строке на "плюсы"
    func probeliToPlusi (vStroke str: String) -> String {
        
        
        var s = str
        for i in s {
            
            
            if i == " " {
                
                
                let ind = str.firstIndex(of: i)
                s.remove(at: ind!)
                s.insert("+", at: ind!)
                
                
            }
            
            
        }
        
        
        return s
        
        
    }
    
    
    
    
}
