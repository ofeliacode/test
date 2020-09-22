//  ViewController.swift
//  test1
//
//  Created by Офелия Баширова on 26.08.2020.
//  Copyright © 2020 Офелия Баширова. All rights reserved.

import UIKit
import SnapKit

class CustomViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView?
    var dataArray = [Datas]()
    override func viewDidLoad() {
        title = "Products"
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 15.0, left: 0.0, bottom: 0.0, right: 0.0)
        //layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.register(CustomViewCell.self, forCellWithReuseIdentifier: CustomViewCell.identifier)
        collectionView?.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        view.addSubview(collectionView!)
        
        //data
        let urlString = "https://gorest.co.in/public-api/products"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            do {
                let dataProp = try JSONDecoder().decode(Response.self, from: data)
                self.dataArray = dataProp.data
                print(dataProp.data[0])
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } catch let error {
                print(error)
            }
            
        }.resume()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomViewCell.identifier, for: indexPath) as! CustomViewCell
        cell.
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width)-17, height: 50)
    }
    
}
