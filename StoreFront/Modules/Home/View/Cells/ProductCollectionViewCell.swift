//
//  ProductCollectionViewCell.swift
//  StoreFront
//
//  Created by wafaa farrag on 26/04/2025.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.kf.cancelDownloadTask()
        productImageView.image = UIImage(named: "placeholder")
        titleLabel.text = ""
        categoryLabel.text = ""
        priceLabel.text = ""
        ratingLabel.text = ""
        
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        clipsToBounds = true
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        
    }
    
    func configure(with product: Product, isGrid: Bool = true) {
        titleLabel.text = product.title
        categoryLabel.text = "Category: \(product.category.capitalized)"
        priceLabel.text = String(format: "$%.2f", product.price)
        
        let starsCount = Int(product.rating.rate.rounded())
        let stars = String(repeating: "⭐️", count: starsCount)
        ratingLabel.text = "\(stars) (\(product.rating.count))"
        
        if let url = URL(string: product.image) {
            productImageView.kf.setImage(with: url)
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
        
        productImageView.contentMode = isGrid ? .scaleAspectFill : .scaleAspectFit
    }
    
}
