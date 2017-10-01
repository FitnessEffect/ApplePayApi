//
//  ViewController.swift
//  ApplePayApi
//
//  Created by Stefan Auvergne on 9/16/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var itemsList = [Item]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            if let file = Bundle.main.url(forResource: "items", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let decoder = JSONDecoder()
                do{
                    itemsList = try decoder.decode([Item].self, from: data)
                }catch{
                    print(error.localizedDescription)
                }
                
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ItemCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.itemLabel.text = self.itemsList[indexPath.row].name
        cell.priceLabel.text = String(self.itemsList[indexPath.row].price)
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "itemVC") as! ItemViewController
        controller.setItem(item: itemsList[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

