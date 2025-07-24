//
//  ProductCollectionViewCell.swift
//  StoreFront
//
//  Created by wafaa farrag on 26/04/2025.
//

import UIKit
import Kingfisher

final class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.kf.cancelDownloadTask()
        productImageView.image = LayoutMetrics.placeholderImage
        titleLabel.text = nil
        categoryLabel.text = nil
        priceLabel.text = nil
        ratingLabel.text = nil
    }
    
    private func setupUI() {
        layer.cornerRadius = LayoutMetrics.cornerRadius
        clipsToBounds = true
        
        productImageView.contentMode = .scaleAspectFit
        productImageView.layer.cornerRadius = LayoutMetrics.cornerRadius
        productImageView.clipsToBounds = true
        
        titleLabel.font = LayoutMetrics.Fonts.title
        categoryLabel.font = LayoutMetrics.Fonts.category
        priceLabel.font = LayoutMetrics.Fonts.price
        ratingLabel.font = LayoutMetrics.Fonts.rating
    }
    
    func configure(with product: Product, isGrid: Bool = true) {
        titleLabel.text = product.title
        categoryLabel.text = "Category: \(product.category.capitalized)"
        priceLabel.text = String(format: "$%.2f", product.price)
        
        let starsCount = Int(product.rating.rate.rounded())
        let stars = String(repeating: "⭐️", count: starsCount)
        ratingLabel.text = "\(stars) (\(product.rating.count))"
        
        if let url = URL(string: product.image) {
            productImageView.kf.setImage(
                with: url,
                placeholder: LayoutMetrics.placeholderImage,
                options: [.transition(.fade(0.25)), .cacheOriginalImage]
            )
        } else {
            productImageView.image = LayoutMetrics.placeholderImage
        }
        
        productImageView.contentMode = .scaleAspectFit
    }
}
