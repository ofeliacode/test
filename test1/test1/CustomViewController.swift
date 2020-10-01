//  CustomViewController.swift
//  test1
//
//  Created by Офелия Баширова on 26.08.2020.
//  Copyright © 2020 Офелия Баширова. All rights reserved.

import UIKit
import Foundation

class CustomViewController: UICollectionViewController {
    
    // MARK: Layout
    
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        return layout
    }()
    
    // MARK: Private properties

    var dataArray = [Datas]()

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        collectionView.register(CustomViewCell.self, forCellWithReuseIdentifier: CustomViewCell.identifier)
        collectionView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        collectionView.collectionViewLayout = layout
        fetchProducts()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    // MARK: Private

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: 10)
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        layout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: 10)
        layout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }

    func fetchProducts() {
        let urlString = "https://gorest.co.in/public-api/products"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            guard let data = data else {return}
            guard error == nil else {return}
            do {
                let dataProp = try JSONDecoder().decode(Response.self, from: data)
                self.dataArray = dataProp.data
                print(dataProp.data[0])
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomViewCell.identifier, for: indexPath) as! CustomViewCell
        cell.setup(
            name: "name: \(dataArray[indexPath.item].name + dataArray[indexPath.item].name)",
            price: "price: \(dataArray[indexPath.item].price)",
            description: "description: \(dataArray[indexPath.item].description)"
        )
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.labelName = dataArray[indexPath.item].name
        vc.labelPrice = dataArray[indexPath.item].price
        vc.labelDescription = dataArray[indexPath.item].description
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CustomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CustomViewCell.calculateSize(
            fittingSize: CGSize(width: collectionView.frame.width, height: .greatestFiniteMagnitude),
            name: "name: \(dataArray[indexPath.item].name + dataArray[indexPath.item].name)",
            price: "price: \(dataArray[indexPath.item].price)",
            description: "description: \(dataArray[indexPath.item].description)"
        )
    }
}