//
//  ViewController.swift
//  2048
//
//  Created by Kenes Yerassyl on 4/10/24.
//

import UIKit

class GameViewController: UIViewController {
    private var numberOfColumns: CGFloat
    private lazy var tileMargin = round((UIScreen.main.bounds.width * 0.8) / numberOfColumns)
    private var gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let viewModel: GameViewModel
    private var scoreLabel = UILabel()
    private var score = 0 {
        didSet {
            scoreLabel.text = "Current score: \(score)"
        }
    }
    
    init(boardSize: CGFloat = 4) {
        numberOfColumns = boardSize
        viewModel = GameViewModel(numberOfColumns: Int(boardSize))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 240/255, alpha: 1.0)
        configureCollectionView()
        configureLabel()
    }
    
    private func configureCollectionView() {
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
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightHandler(_:)))
        swipeRightGesture.direction = UISwipeGestureRecognizer.Direction.right
        gridCollectionView.addGestureRecognizer(swipeRightGesture)
    }
    
    private func configureLabel() {
        view.addSubview(scoreLabel)
        scoreLabel.text = "Current score: 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 24)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = .black
        scoreLabel.textAlignment = .center
        let constraints = [
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),
            scoreLabel.heightAnchor.constraint(equalToConstant: 50),
            scoreLabel.bottomAnchor.constraint(equalTo: gridCollectionView.topAnchor, constant: -40)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func resetGame() {
        viewModel.reset()
    }
    
    @objc private func swipeRightHandler(_ gesture: UISwipeGestureRecognizer) {
        score += 1
        viewModel.modifyGameMatrix(.right)
    }
    @objc private func swipeLeftHandler(_ gesture: UISwipeGestureRecognizer) {
        score += 1
        viewModel.modifyGameMatrix(.left)
    }
    @objc private func swipeDownHandler(_ gesture: UISwipeGestureRecognizer) {
        score += 1
        viewModel.modifyGameMatrix(.down)
    }
    @objc private func swipeUpHandler(_ gesture: UISwipeGestureRecognizer) {
        score += 1
        viewModel.modifyGameMatrix(.up)
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
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

extension GameViewController: GameViewModelDelegate {
    func updateGrid() {
        gridCollectionView.reloadData()
    }
    
    func gameOver() {
        let alert = UIAlertController(title: "You have lost :((", message: "Can't do any move", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Try again?", style: .cancel) { (_) in self.resetGame() }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
}
extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(numberOfColumns * numberOfColumns)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridCollectionView.dequeueReusableCell(withReuseIdentifier: TileCollectionViewCell.identifier, for: indexPath) as! TileCollectionViewCell
        cell.tileNumber = viewModel.gameMatrix[indexPath.row / Int(numberOfColumns)][indexPath.row % Int(numberOfColumns)]
        return cell
    }
}

