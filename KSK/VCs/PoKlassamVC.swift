//
//  PoKlassamVC.swift
//  KSK
//
//  Created by Ацамаз on 19/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit
import SwiftSoup
import GoogleMobileAds

class PoKlassamVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    // Массив картинок для "классов
    var arrayOfPicturesOfClasses: [URL] = []
    
    
    
    
    // Количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    
    
    // Содержание ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PoKlassamCell
        
        //Делаем надписи "11 класс", "10 класс", "9 класс" и т.д.
        cell.labClass.text = "\(11 - indexPath.row) класс"
        
        //Скругляем углы у картинок под "классами"
        cell.imClass.layer.cornerRadius = 20
        
        //Ставим картинки с массива на свое место
        if arrayOfPicturesOfClasses.count - 1 >= indexPath.row {
            
                cell.imClass.sd_setImage(with: arrayOfPicturesOfClasses[indexPath.row],
                                         completed: nil)
            
        }
        
        return cell
        
    }
    
    
    
    
    // Высота каждой ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Реклама
        bannerView.adUnitID = "ca-app-pub-4230745985996569/8407381595"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        //Ставим картинки на нужные места
        getArrayOfPicturesOfClasses()
        
        
        
        
        
        
    } // Конец viewDidLoad
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Убираем выделение со всех ячеек
        for row in 0...6 {
            tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
        }
        
    }
    
    
    
    // Передаем номер ячейки при нажатии на ячейку
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "segue" {
            
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                
                let destinationVC = segue.destination as! SelecedClassVC
                destinationVC.selectedRowTitle = "\(11 - indexPath.row) класс"
                
                
            }
            
            
        }
        
        
    }
    
    
    
    
    //MARK: Мои функции
    
    
    
    
    // Функция, наполняющая массив картинками для каждого класса и ставящая эти картинки в нужные ячейки
    func getArrayOfPicturesOfClasses () {
        let url = "https://briefly.ru/school"
        let myUrl = URL(string: url)
        
        let URLTask = URLSession.shared.dataTask(with: myUrl!){
            myData, response, error in
            
            guard error == nil else { return }
            
            let myHTMLString = String(data: myData!, encoding: String.Encoding.utf8)
            
            
            do {
                
                let doc = try SwiftSoup.parse(myHTMLString!)
                
                do {
                    
                    // Что нам надо достать?
                    let element = try doc.select("img").attr("class", "picture").array()
                    
                    
                    do{
                        
                        // Совершем все операции!
                        
                        
                        
                        
                        
                        
                        for i in element {
                            
                            if try i.attr("width") == "514" {
                                let halfLinkToCurrentPicture = try i.attr("src")
                                let string1 = "https://briefly.ru" + halfLinkToCurrentPicture
                                if let linkToCurrentPicture = URL(string: string1) {
                                    self.arrayOfPicturesOfClasses.append(linkToCurrentPicture)
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
