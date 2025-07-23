//
//  ProductDetailsViewController.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation
import UIKit

class ProductDetailsViewController: BaseViewController {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var product: Product!
       
       override func viewDidLoad() {
           super.viewDidLoad()
           title = "Details"
           styleUI()
           configureProduct()
       }
    
    private func styleUI() {
        productImageView.layer.cornerRadius = 12
        productImageView.layer.masksToBounds = true
        productImageView.layer.shadowColor = UIColor.black.cgColor
        productImageView.layer.shadowOpacity = 0.2
        productImageView.layer.shadowRadius = 6
        productImageView.layer.shadowOffset = CGSize(width: 0, height: 4)

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 4
        descriptionLabel.attributedText = NSAttributedString(
            string: product.description,
            attributes: [.paragraphStyle: paragraph]
        )

        
    }
       
       private func configureProduct() {
           guard let product = product else { return }
           
           // Load image
           if let url = URL(string: product.image) {
               productImageView.kf.setImage(with: url)
           } else {
               productImageView.image = UIImage(named: "placeholder")
           }
           
           titleLabel.text = product.title
           categoryLabel.text = "Category: \(product.category.capitalized)"
           priceLabel.text = String(format: "$%.2f", product.price)
           
           let stars = String(repeating: "⭐️", count: Int(product.rating.rate.rounded()))
           ratingLabel.text = "\(stars) (\(product.rating.count))"
           
           descriptionLabel.text = product.description
       }
   }
    
