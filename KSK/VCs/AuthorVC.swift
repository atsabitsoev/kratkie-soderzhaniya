//
//  AuthorVC.swift
//  KSK
//
//  Created by Ацамаз on 22/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit
import SwiftSoup
import GoogleMobileAds

class AuthorVC: UIViewController {
    
    @objc func goToBook () {
        if arrayOfLinks[(tableView.indexPathForSelectedRow?.row)!].hasPrefix("https://w") {
            nowBookFromWiki = true
        }
        
        let bookVC: BookVC = self.storyboard?.instantiateViewController(withIdentifier: "Книги") as! BookVC
        
        print("переходим")
        print(arrayOfLinks.count)
        print(arrayOfLinks[(tableView.indexPathForSelectedRow?.row)!])
        bookVC.selectedRowTitle = arrayOfBooks[(tableView.indexPathForSelectedRow?.row)!]
        bookVC.urlOfText = arrayOfLinks[(tableView.indexPathForSelectedRow?.row)!]
        
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
    
    
    var selectedRowTitle = ""
    var selectedRowLink = ""
    
    
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    var mode: Mode = Mode.neZadano
    var arrayOfAuthors = [String]()
    var arrayOfBooks = [String]()
    var arrayOfLinks = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // Реклама
        bannerView.adUnitID = "ca-app-pub-4230745985996569/4924922844"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        activityView.layer.cornerRadius = 10
        
        
        print("Зешел в AuthorVC")
        self.title = selectedRowTitle
        getArrayOfThings()
        
    } // Конец viewDidLoad
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! BookVC
        destination.urlOfText = arrayOfLinks[(tableView.indexPathForSelectedRow?.row)!]
        print(arrayOfLinks[(tableView.indexPathForSelectedRow?.row)!] + "))))l")
    }
    
    
    
    
    //MARK: Мои функции
    
    
    // Функция, наполняющая массив букв и массив имен авторов
    
    func getArrayOfThings () {
        self.tableView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        self.activityIndicator.alpha = 1
        self.activityView.alpha = 1
        
        
        let url = selectedRowLink
        print(url)
        
        
        
        
        let myUrl = URL(string: url)
        print("главная ссылка \(selectedRowLink)")
        let URLTask = URLSession.shared.dataTask(with: myUrl!){
            myData, response, error in
            
            guard error == nil else { return }
            
            let myHTMLString = String(data: myData!, encoding: String.Encoding.utf8)
            
            do {
                
                let doc = try SwiftSoup.parse(myHTMLString!)
                do {
                    
                    
                    // Что нам надо достать?
                    let element1 = try doc.select("div").array()
                    let element2 = try doc.select("h4").array()
                    let element3 = try doc.select("a").array()


                    do{
                        
                        
                    // Все операции тут!!
                        self.mode = Mode.normal
                        
                    // Проверяем на отсутствие книг у автора
                        for i in element1 {
                            if try i.attr("class") == "noworks" {
                                self.mode = Mode.empty
                                print("Режим отсутствия книг данного автора")
                            } 
                        }
                        
                    // Проверяем на наличие нескоих авторов
                        if element2.count > 0 {
                            self.mode = Mode.multiAuthor
                            print("Режим нескольких авторов")
                        }
                        
                    // Действия при различных значениях mode
                        if self.mode == Mode.empty {
                            // Пусто
                        } else if self.mode == Mode.multiAuthor {
                            
                            var arr = [String]()
                            for i in element2 {
                                arr.append(try i.text())
                                let halfLink = try i.select("a").attr("href")
                                self.arrayOfLinks.append("https://briefly.ru" + halfLink)
                            }
                            self.arrayOfAuthors = arr
                            
                        } else {
                            
                            var arr = [String]()
                            for i in element3 {
                                if try i.attr("class") == "title" {
                                    arr.append(try i.text())
                                    let halfLink = try i.attr("href")
                                    if try i.attr("target") != "_blank" {
                                        self.arrayOfLinks.append("https://briefly.ru" + halfLink)
                                    } else {
                                        self.arrayOfLinks.append(halfLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                                        
                                    }
                                }
                                
                            }
                            if arr.count != 0 {
                                self.arrayOfBooks = arr
                            } else {
                                for i in element3 {
                                    for j in try i.select("div").array(){
                                        if try j.attr("class") == "w-title" {
                                            arr.append(try i.text())
                                            let halfLink = try i.attr("href")
                                            
                                            if try i.attr("target") != "_blank" {
                                                self.arrayOfLinks.append("https://briefly.ru" + halfLink)
                                            } else { self.arrayOfLinks.append(halfLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                self.arrayOfBooks = arr
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            switch self.mode {
                            case .multiAuthor, .normal:
                                self.tableView.isUserInteractionEnabled = true
                            default:
                                print("what???")
                            }
                            print(self.arrayOfBooks)
                            print(self.arrayOfLinks)
                            print("законяили")
                            
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.alpha = 0
                            self.activityView.alpha = 0
                            self.tableView.isUserInteractionEnabled = true
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
    
    
    
    
}


//MARK: Работаем с tableView

extension AuthorVC: UITableViewDelegate {
    
}

extension AuthorVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .empty:
            return 1
        case .multiAuthor:
            return arrayOfAuthors.count
        case .normal:
            return arrayOfBooks.count
        default:
            print("Ошибка в табл вью")
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAuthorVC") as! AuthorCell
        
        switch mode {
        case .empty:
            cell.labMain.text = "У нас пока нет книг этого автора ;("
        case .multiAuthor:
            if arrayOfAuthors.count != 0 {
                cell.labMain.text = arrayOfAuthors[indexPath.row]
            }
        case .normal:
            if arrayOfBooks.count != 0 {
                cell.labMain.text = arrayOfBooks[indexPath.row]
            }
        default:
            cell.labMain.text = "Подождите..."
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowLink = arrayOfLinks[indexPath.row]
        
        if mode == .multiAuthor {
            mode = .normal
            arrayOfLinks = []
            getArrayOfThings()
            
        } else if mode == .normal {
            
            
           
            goToBook()
            
            
            
        }
        
    }
    
    
    
}




enum Mode {
    case empty
    case normal
    case multiAuthor
    case neZadano
}



