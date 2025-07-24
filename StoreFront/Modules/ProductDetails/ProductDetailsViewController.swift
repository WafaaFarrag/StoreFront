//
//  ProductDetailsViewController.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//
import UIKit
import Kingfisher

final class ProductDetailsViewController: BaseViewController {
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "productDetailsTitle".localized()
        setupUI()
        configureProduct()
    }
    
    private func setupUI() {
        productImageView.layer.cornerRadius = LayoutMetrics.cornerRadius
        productImageView.layer.masksToBounds = true
        productImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = LayoutMetrics.Fonts.title
        categoryLabel.font = LayoutMetrics.Fonts.category
        priceLabel.font = LayoutMetrics.Fonts.price
        ratingLabel.font = LayoutMetrics.Fonts.rating
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
    }
    
    private func configureProduct() {
        guard let product = product else { return }
        
        if let url = URL(string: product.image) {
            productImageView.kf.setImage(
                with: url,
                placeholder: LayoutMetrics.placeholderImage,
                options: [.transition(.fade(0.25)), .cacheOriginalImage]
            )
        } else {
            productImageView.image = LayoutMetrics.placeholderImage
        }
        
        titleLabel.text = product.title
        categoryLabel.text = "categoryLabelPrefix".localized() + product.category.capitalized
        priceLabel.text = String(format: "priceFormat".localized(), product.price)
  
        let starsCount = Int(product.rating.rate.rounded())
        let stars = String(repeating: "⭐️", count: starsCount)
        ratingLabel.text = "\(stars) (\(product.rating.count))"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 4
        descriptionLabel.attributedText = NSAttributedString(
            string: product.description,
            attributes: [.paragraphStyle: paragraph]
        )
    }
}
