//
//  SelecedClassVC.swift
//  KSK
//
//  Created by Ацамаз on 19/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit
import SwiftSoup
import GoogleMobileAds

class SelecedClassVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var arrayOfPicturesData: [Data] = []
    var arrayOfText1: [String] = []
    var arrayOfText2: [String] = []
    var arrayOfLinks: [String] = []
    
    
    @IBOutlet weak var tableView: UITableView!
 
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    
    // Количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    
    
    
    // Содержание ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SelectedClassCell
        cell.imBook.layer.cornerRadius = 20
        
        //Картинка
        if arrayOfPicturesData.count - 1 >= indexPath.row {
            
            cell.imBook.image = UIImage(data: arrayOfPicturesData[indexPath.row])
            
        }
        
        //Первый текст
        if arrayOfText1.count - 1 >= indexPath.row {
            
            cell.labBookName.text = arrayOfText1[indexPath.row]
            
        }
        
        //Первый текст
        if arrayOfText2.count - 1 >= indexPath.row {
            
            cell.labBookDescription.text = arrayOfText2[indexPath.row]
            
        }
        
        
        
        
        return cell
        
        
    }
    
    
   
    
    // Высота каждой ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 261
        
        
    }
    
    
    
    
    var selectedRowTitle = ""

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Реклама
        bannerView.adUnitID = "ca-app-pub-4230745985996569/6074352987"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

        // Заголовок в соответствии с выбранной ячейкой
        self.title = selectedRowTitle
        
        
        // Ставим картинки и текст на свои места
        getArrayOfBooksImagesAndText()
        
       
        // Активити индикатор
        activityIndicator.startAnimating()
        activityView.layer.cornerRadius = 10
        
        
        
    } // Конец viewDidLoad
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        // Убираем выделение со всех ячеек
        for row in 0...23 {
            tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
        }
        
        
    }
    
    
    
    
    // Передаем название книги при нажатии на ячейку
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "segue2" {
            
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                
                let destinationVC = segue.destination as! BookVC
                let currentCell = tableView.cellForRow(at: indexPath) as! SelectedClassCell
                destinationVC.selectedRowTitle = currentCell.labBookName.text!
                
                destinationVC.urlOfText = "https://briefly.ru" + arrayOfLinks[indexPath.row]
                print(arrayOfLinks[indexPath.row])
            }
            
            
        }
        
        
    }
    
    
    
    
    
    
    //MARK: Мои функции
    
    
    
    
    // Функция, наполняющая массив картинками для каждого класса и ставящая эти картинки в нужные ячейки
    func getArrayOfBooksImagesAndText () {
        
        
        var url = ""
        
        
        switch selectedRowTitle {
        case "11 класс":
            url = "https://briefly.ru/school/11class/"
        case "10 класс":
            url = "https://briefly.ru/school/10class/"
        case "9 класс":
            url = "https://briefly.ru/school/9class/"
        case "8 класс":
            url = "https://briefly.ru/school/8class/"
        case "7 класс":
            url = "https://briefly.ru/school/7class/"
        case "6 класс":
            url = "https://briefly.ru/school/6class/"
        case "5 класс":
            url = "https://briefly.ru/school/5class/"
        default:
            print("ошибка")
        }
        
        
        
        let myUrl = URL(string: url)
        
        let URLTask = URLSession.shared.dataTask(with: myUrl!){
            myData, response, error in
            
            guard error == nil else { return }
            
            let myHTMLString = String(data: myData!, encoding: String.Encoding.utf8)
            
            
            do {
                
                let doc = try SwiftSoup.parse(myHTMLString!)
                
                do {
                    
                    // Что нам надо достать?
                    let element = try doc.select("img").array()
                    let element2 = try doc.select("h3").array()
                    let element3 = try doc.select("div").array()
                    let element4 = try doc.select("a").array()
                    
                    do{
                        
                        // Совершем все операции!
                        
                        
                        // Первый текст
                        for i in element2 {
                            
                            if try i.attr("class") == "w-title" {
                                
                                self.arrayOfText1.append(try i.text())
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        
                        // Второй текст
                        for i in element3 {
                            
                            if try i.attr("class") == "w-cat" {
                                
                                self.arrayOfText2.append(try i.text())
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                            }
                            
                        }
                        
                        // Ссылки
                        for i in element4 {
                            
                            if try i.attr("class") == "work__cover work__cover_type_landscape" || i.attr("class") == "work__cover work__cover_type_portrait"{
                        
                                let link = try i.attr("href")
                                self.arrayOfLinks.append(link)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.isUserInteractionEnabled = true
                            self.activityView.alpha = 0
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.alpha = 0
                            
                        }
                        
                        
                        // Картинка и ссылки
                        for i in element {
                            
                            if try i.attr("width") == "320" {
                                
                                let string = try i.attr("src")
                                let string1 = "https://briefly.ru" + string
                                print(string1)
                                let url1 = URL(string: string1)
                                let data = try Data(contentsOf: url1!)
                                
                                self.arrayOfPicturesData.append(data)
                                
                                
                                
                                
                                
                                
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
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
    
    

    

    
}
