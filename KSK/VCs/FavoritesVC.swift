//
//  FavoritesVC.swift
//  KSK
//
//  Created by Ацамаз on 19/11/2018.
//  Copyright © 2018 a.s.bitsoev. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FavoritesVC: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    
    
    var arrTitles = [String]()
    var arrTexts = [String]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Реклама
        bannerView.adUnitID = "ca-app-pub-4230745985996569/2628688726"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToFavBook" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let destinationVC = segue.destination as! FavBookVC
                let currentCell = tableView.cellForRow(at: indexPath) as! FavoritesCell
                destinationVC.title = currentCell.labTitle.text!
                destinationVC.textForTextView = arrTexts[indexPath.row]
                
            }
            
        }
            
            
        
    }
    

   

}



extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFav") as! FavoritesCell
        if arrTitles.count != 0 {
            cell.labTitle.text = arrTitles[indexPath.row]
        }
        return cell
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let arrTitles = UserDefaults.standard.stringArray(forKey: "Массив названий") {
            self.arrTitles = arrTitles
            self.arrTexts = UserDefaults.standard.stringArray(forKey: "Массив текстов")!
            tableView.reloadData()
        }
    }
    
    
    
}
