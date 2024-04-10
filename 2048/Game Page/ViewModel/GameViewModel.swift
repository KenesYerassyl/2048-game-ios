//
//  ViewModel.swift
//  2048
//
//  Created by Kenes Yerassyl on 4/10/24.
//

import Foundation

enum Direction {
    case left
    case right
    case up
    case down
    
    func values() -> (x: Int, y: Int){
        switch self {
        case .left:
            return (0, -1)
        case .right:
            return (0, 1)
        case .up:
            return (-1, 0)
        case .down:
            return (1, 0)
        }
    }
}


protocol GameViewModelDelegate: AnyObject {
    func updateGrid()
    func gameOver()
}

class GameViewModel {
    var numberOfColumns: Int
    var gameMatrix: [[Int]]
    weak var delegate: GameViewModelDelegate?
    
    init(numberOfColumns: Int) {
        self.numberOfColumns = numberOfColumns
        self.gameMatrix = Array(repeating: Array(repeating: 0, count: numberOfColumns), count: numberOfColumns)
        populateRandomly()
        populateRandomly()
    }
    
    func reset() {
        self.gameMatrix = Array(repeating: Array(repeating: 0, count: numberOfColumns), count: numberOfColumns)
        populateRandomly()
        populateRandomly()
    }
    
    private func checkAdjacentTiles(_ row: Int, _ col: Int) -> Bool {
        let adjacentTiles = [(row + 1, col), (row - 1, col), (row, col + 1), (row, col - 1)]
        for (adjRow, adjCol) in adjacentTiles {
            if adjRow >= 0 && adjRow < numberOfColumns && adjCol >= 0 && adjCol < numberOfColumns {
                if gameMatrix[adjRow][adjCol] == gameMatrix[row][col] {
                    return true
                }
            }
        }
        return false
    }
    
    func isPlayable() -> Bool {
        for row in 0..<numberOfColumns {
            for col in 0..<numberOfColumns {
                if (checkAdjacentTiles(row, col) == true) {
                    return true
                }
            }
        }
        return false
    }
    
    func populateRandomly() {
        
        if (isPlayable() == false) {
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
    
    func modifyGameMatrix(_ direction: Direction) {
        let flag = direction == .down || direction == .up ? true : false
        for val in 0..<numberOfColumns {
            getModifiedRowOrColumn(val, flag, direction)
        }
        populateRandomly()
    }
    private func getModifiedRowOrColumn(_ val: Int, _ flag: Bool, _ direction: Direction) {
        // 0 -> row, 1 -> column
        var newArray: [Int] = []
        var isMergable: Bool = true
        var row = flag == false ? val : direction == .down ? 0 : numberOfColumns-1
        var col = flag == true ? val : direction == .right ? 0 : numberOfColumns-1
        while ((0..<numberOfColumns).contains(row) && (0..<numberOfColumns).contains(col)) {
            if (gameMatrix[row][col] != 0) {
                if (newArray.isEmpty == false && newArray.last == gameMatrix[row][col] && isMergable == true) {
                    newArray[newArray.count - 1] += gameMatrix[row][col]
                    isMergable = false
                } else {
                    newArray.append(gameMatrix[row][col])
                    isMergable = true
                }
            }
            row += direction.values().x
            col += direction.values().y
        }
        while (newArray.count < numberOfColumns) {
            newArray.append(0)
        }
        if (direction == .right || direction == .down) {
            newArray.reverse()
        }
        for index in 0..<numberOfColumns {
            if (flag == true) {
                gameMatrix[index][val] = newArray[index]
            } else {
                gameMatrix[val][index] = newArray[index]
            }
        }
    }
}
