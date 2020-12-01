//
//  ImageCollectionViewCell.swift
//  Chat
//
//  Created by Anastasia Shmakova on 18.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell, ConfigurableView {

    @IBOutlet weak var imageView: UIImageView!
    
    var representedIdentifier: UUID?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "PlaceholderIcon")
    }
    
    func configure(with model: UIImage?) {
        imageView.image = model
    }
}
