//
//  ViewController.swift
//  2048
//
//  Created by Kenes Yerassyl on 4/10/24.
//

import UIKit

class ViewController: UIViewController {
    private let numberOfColumns:CGFloat = 4
    private lazy var tileMargin = round((UIScreen.main.bounds.width * 0.8) / numberOfColumns)
    private var gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let viewModel = ViewModel(numberOfColumns: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureCollectionView()
    }
    
    func configureCollectionView() {
        view.addSubview(gridCollectionView)
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        gridCollectionView.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionViewCell.identifier)
        gridCollectionView.backgroundColor = UIColor(red: 185/255, green: 173/255, blue: 161/255, alpha: 1.0)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        gridCollectionView.layer.cornerRadius = 10
        let constraints = [
            gridCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gridCollectionView.widthAnchor.constraint(equalToConstant: tileMargin * numberOfColumns + (numberOfColumns + 1) * 3),
            gridCollectionView.heightAnchor.constraint(equalToConstant: tileMargin * numberOfColumns + (numberOfColumns + 1) * 3)
        ]
        NSLayoutConstraint.activate(constraints)
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpHandler(_:)))
        swipeUpGesture.direction = UISwipeGestureRecognizer.Direction.up
        gridCollectionView.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownHandler(_:)))
        swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
        gridCollectionView.addGestureRecognizer(swipeDownGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftHandler(_:)))
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        gridCollectionView.addGestureRecognizer(swipeLeftGesture)
//        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightHandler(_:)))
        swipeRightGesture.direction = UISwipeGestureRecognizer.Direction.right
        gridCollectionView.addGestureRecognizer(swipeRightGesture)
    }
    
    @objc func swipeRightHandler(_ gesture: UISwipeGestureRecognizer) {
        viewModel.push(to: true, on: false)
    }
    @objc func swipeLeftHandler(_ gesture: UISwipeGestureRecognizer) {
        viewModel.push(to: false, on: false)
    }
    @objc func swipeDownHandler(_ gesture: UISwipeGestureRecognizer) {
        viewModel.push(to: true, on: true)
    }
    @objc func swipeUpHandler(_ gesture: UISwipeGestureRecognizer) {
        viewModel.push(to: false, on: true)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: tileMargin, height: tileMargin)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
}

extension ViewController: ViewModelDelegate {
    func updateGrid() {
        gridCollectionView.reloadData()
    }
    
    func gameOver() {
        // TODO
    }
    
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(numberOfColumns * numberOfColumns)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridCollectionView.dequeueReusableCell(withReuseIdentifier: TileCollectionViewCell.identifier, for: indexPath) as! TileCollectionViewCell
        cell.tileNumber = viewModel.gameMatrix[indexPath.row / 4][indexPath.row % 4]
        return cell
    }
}

