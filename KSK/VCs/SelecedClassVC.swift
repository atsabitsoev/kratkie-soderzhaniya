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
    
    
    
    var arrayOfPicturesData: [URL] = []
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
            
            cell.imBook.sd_setImage(with: arrayOfPicturesData[indexPath.row],
                                    completed: nil)
            
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
        
        
        let url = "https://briefly.ru/school/11class"
        
        
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
                    let element3 = try doc.select("small").array()
                    let element4 = try doc.select("h3").array()
                    
                    do{
                        
                        // Совершем все операции!
                        
                        
                        // Первый текст
                        for i in element2 {
                            
                            if try i.attr("class") == "work__title" {
                                
                                self.arrayOfText1.append(try i.text())
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        
                        // Второй текст
                        for i in element3 {
                            
                            if try i.attr("class") == "work__meta" {
                                
                                self.arrayOfText2.append(try i.text())
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                            }
                            
                        }
                        
                        // Ссылки
                        for i in element4 {
                            
                            if try i.attr("class") == "work__title" {
                                
                                let child = i.childNode(0)
                                
                                let link = try child.attr("href")
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
                            
                            if try i.attr("width") == "240" || i.attr("width") == "320" {
                                
                                let string = try i.attr("src")
                                let string1 = "https://briefly.ru" + string
                                print(string1)
                                if let url1 = URL(string: string1) {
                                    self.arrayOfPicturesData.append(url1)
                                }
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
