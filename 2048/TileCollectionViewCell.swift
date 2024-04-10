//
//  TileCollectionViewCell.swift
//  2048
//
//  Created by Kenes Yerassyl on 4/10/24.
//



import UIKit

class TileCollectionViewCell: UICollectionViewCell {
    static let identifier = "TileCollectionViewCell"
    private let tileColors: [Int: String] = [
        0: "#cac1b5",
        2: "#EEE4DA",
        4: "#EDE0C8",
        8: "#F2B179",
        16: "#F59563",
        32: "#F67C5F",
        64: "#F65E3B",
        128: "#EDCF72",
        256: "#EDCC61",
        512: "#EDC850",
        1024: "#EDC53F",
        2048: "#EDC22E",
        4096: "#EEC22E",
        8192: "#F5C400",
        16384: "#F7B801",
        32768: "#F6A101",
        65536: "#F58634",
        131072: "#F57336"
    ]

    private var tileNumberLabel = UILabel()
    
    public var tileNumber: Int = 0 {
        didSet {
            tileNumberLabel.text = (tileNumber != 0) ? String(tileNumber) : nil
            contentView.backgroundColor = UIColor(hexCode: tileColors[tileNumber] ?? "#ff00ff")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        configureLabel()
    }
    
    func configureLabel() {
        contentView.addSubview(tileNumberLabel)
        tileNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        tileNumberLabel.font = UIFont.systemFont(ofSize: 30)
        tileNumberLabel.textAlignment = .center
        tileNumberLabel.textColor = .black
        let constraints = [
            tileNumberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tileNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tileNumberLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            tileNumberLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
