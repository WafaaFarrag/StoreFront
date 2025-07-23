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
    @IBOutlet weak var descriptionLabel: UILabel!
    
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
        descriptionLabel.text = ""
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        clipsToBounds = true
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        
        categoryLabel.font = UIFont.systemFont(ofSize: 12)
        categoryLabel.textColor = .gray
        
        priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        priceLabel.textColor = .red
        
        ratingLabel.font = UIFont.systemFont(ofSize: 12)
        ratingLabel.textColor = .darkGray
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 2
    }
    
    func configure(with product: Product) {
        
        if let url = URL(string: product.image) {
            productImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"),
                options: [.transition(.fade(0.3)), .cacheOriginalImage]
            )
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
        
        titleLabel.text = product.title
        
        categoryLabel.text = "Category: \(product.category.capitalized)"
        
        priceLabel.text = String(format: "$%.2f", product.price)
        
        let starsCount = Int(product.rating.rate.rounded())
        let stars = String(repeating: "⭐️", count: starsCount)
        ratingLabel.text = "\(stars) (\(product.rating.count))"
        
        let truncated = product.description.count > 60
            ? String(product.description.prefix(60)) + "…"
            : product.description
        descriptionLabel.text = truncated
    }
}
