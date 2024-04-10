//
//  ViewModel.swift
//  2048
//
//  Created by Kenes Yerassyl on 4/10/24.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func updateGrid()
    func gameOver()
}

class ViewModel {
    var numberOfColumns: Int
    var gameMatrix: [[Int]]
    weak var delegate: ViewModelDelegate?
    
    init(numberOfColumns: Int) {
        self.numberOfColumns = numberOfColumns
        self.gameMatrix = Array(repeating: Array(repeating: 0, count: numberOfColumns), count: numberOfColumns)
        populateRandomly()
        populateRandomly()
    }
    
    func checkValidity() -> Bool {
        for row in 0..<numberOfColumns {
            for column in 0..<numberOfColumns {
                if (gameMatrix[row][column] == 0) {
                    return true;
                }
                if (row + 1 < numberOfColumns && gameMatrix[row + 1][column] == gameMatrix[row][column]) {
                    return true
                }
                if (row - 1 >= 0 && gameMatrix[row - 1][column] == gameMatrix[row][column]) {
                    return true
                }
                if (column + 1 < numberOfColumns && gameMatrix[row][column + 1] == gameMatrix[row][column]) {
                    return true
                }
                if (column - 1 >= 0 && gameMatrix[row][column - 1] == gameMatrix[row][column]) {
                    return true
                }
            }
        }
        return false
    }
    
    func populateRandomly() {
        
        if (checkValidity() == false) {
            delegate?.gameOver()
        }
        
        var freePositions: [(Int, Int)] = []
        for row in 0..<numberOfColumns {
            for column in 0..<numberOfColumns {
                if (gameMatrix[row][column] == 0) {
                    freePositions.append((row, column))
                }
            }
        }
        if (freePositions.isEmpty == false) {
            let randomPosition = freePositions[Int.random(in: 0..<freePositions.count)]
            gameMatrix[randomPosition.0][randomPosition.1] = 2
        }
        delegate?.updateGrid()
    }
    
    func push(to direction: Bool, on line: Bool) { 
        // direction 0-backward, 1-forward, line: 0-horizontal, 1-vertical
        // right: 1, 0
        for column in 0..<numberOfColumns {
            var newArray: [Int] = []
            var isMergable: Bool = true
            for row in stride(
                from: (direction == true ? numberOfColumns - 1 : 0),
                through: (direction == true ? 0 : numberOfColumns - 1),
                by: (direction == true ? -1 : 1)) {
                let element = line == true ? gameMatrix[row][column] : gameMatrix[column][row]
                if (element == 0) {
                    continue
                }
                if (newArray.isEmpty == false && newArray.last == element && isMergable == true) {
                    newArray[newArray.count - 1] += element
                    isMergable = false
                } else {
                    newArray.append(element)
                    isMergable = true
                }
            }
            while (newArray.count < numberOfColumns) {
                newArray.append(0)
            }
            if (direction == true) {
                newArray.reverse()
            }
            for row in 0..<numberOfColumns {
                if (line == true) {
                    gameMatrix[row][column] = newArray[row]
                } else {
                    gameMatrix[column][row] = newArray[row]
                }
            }
        }
        populateRandomly()
    }
}
