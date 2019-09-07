//
//  TopVC.swift
//  KSK
//
//  Created by Ацамаз on 19/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit
import SwiftSoup
import GoogleMobileAds

var nowBookFromWiki = false



class TopVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    // Содержание ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTop") as! TopCell
        cell.imBook.layer.cornerRadius = 20
        
        //Картинка
        if arrayOfPicturesData.count - 1 >= indexPath.row {
            
            cell.imBook.image = UIImage(data: arrayOfPicturesData[indexPath.row])
            
        }
        
        //Первый текст
        if arrayOfText1.count - 1 >= indexPath.row {
            
            cell.labBookName.text = arrayOfText1[indexPath.row]
            
        }
        
        
        
        
        
        
        return cell
        
        
    }
    
    
    // Высота каждой ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 261
        
        
    }
    
    
    
    
    
    

    var arrayOfPicturesData: [Data] = []
    var arrayOfText1: [String] = []
    var arrayOfLinks: [String] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Реклама
        bannerView.adUnitID = "ca-app-pub-4230745985996569/8524422354"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        changeColorOfUnselectedTabBarItems(to: UIColor.white)

        // Ставим картинки и текст на свои места
        getArrayOfBooksImagesAndText()
        
        
        // Активити индикатор
        activityIndicator.startAnimating()
        activityView.layer.cornerRadius = 10
        
    }
    
    
    //Функция, меняющая цвет невыбранных items таббара
    func changeColorOfUnselectedTabBarItems(to color:UIColor) {
        self.tabBarController?.tabBar.unselectedItemTintColor = color
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        // Убираем выделение со всех ячеек
        for row in 0...23 {
            tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
        }
        
        
    }
    
    
    
    
    // Передаем название книги при нажатии на ячейку
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "segueFromTop" {
            
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                
                let destinationVC = segue.destination as! BookVC
                let currentCell = tableView.cellForRow(at: indexPath) as! TopCell
                destinationVC.selectedRowTitle = currentCell.labBookName.text!
                
                destinationVC.urlOfText = "https://briefly.ru" + arrayOfLinks[indexPath.row]
                print(arrayOfLinks[indexPath.row])
            }
            
            
        }
        
        
    }
    
    
    
    
    
    
    func getArrayOfBooksImagesAndText () {
        
        
        let url = "https://briefly.ru/toprated/"
        
        
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
