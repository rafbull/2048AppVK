//
//  TileView.swift
//  2048AppVK
//
//  Created by Rafis on 05.04.2024.
//

import UIKit

final class TileView: UIView {
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let tileViewCornerRadius: CGFloat = 5
    }
    
    // MARK: - Private Properties
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.tileLabel
        label.textColor = AppColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Methods
    func setTileValue(_ value: Int) {
        valueLabel.text = String(value)
        
        setbackgroundColor(for: value)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(valueLabel)
        layer.cornerRadius = UIConstants.tileViewCornerRadius
    }
    
    private func setbackgroundColor(for tileValue: Int) {
        switch tileValue {
        case 2:
            backgroundColor = AppColor.tile1
        case 4:
            backgroundColor = AppColor.tile2
        case 8:
            backgroundColor = AppColor.tile3
        case 16:
            backgroundColor = AppColor.tile4
        case 32:
            backgroundColor = AppColor.tile5
        case 64:
            backgroundColor = AppColor.tile6
        default:
            backgroundColor = AppColor.tile7
        }
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
