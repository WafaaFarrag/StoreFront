//
//  ProductsViewController.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//
// ProductsViewController.swift
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ProductsViewController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<HomeSectionModel>!
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupDataSource()
        bindViewModel()
        
        
        if viewModel.products.value.isEmpty {
            viewModel.loadInitialProducts()
        }
    }
    
    private func setupCollectionView() {
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        collectionView.setCollectionViewLayout(pinterestLayout, animated: false)
        
        collectionView.register(
            UINib(nibName: "ProductCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ProductCollectionViewCell"
        )
        
        collectionView.delegate = self
        
        
        collectionView.rx.contentOffset
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                let contentHeight = self.collectionView.contentSize.height
                let scrollHeight = self.collectionView.frame.size.height
                if offset.y > contentHeight - scrollHeight * 2 {
                    self.viewModel.loadMoreProducts()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ProductCollectionViewCell",
                    for: indexPath
                ) as! ProductCollectionViewCell
                cell.configure(with: item)
                return cell
            }
        )
    }
    
    private func bindViewModel() {
        bindLoading(viewModel.isLoading)
        
        
        viewModel.products
            .map { [HomeSectionModel.productsSection(items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        collectionView.rx.modelSelected(Product.self)
            .subscribe(onNext: { [weak self] product in
                self?.showProductDetails(product)
            })
            .disposed(by: disposeBag)
    }
    
    private func showProductDetails(_ product: Product) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController {
            // detailsVC.product = product
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

// MARK: - Pinterest Masonry Layout
extension ProductsViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.sectionModels[indexPath.section]
        switch section {
        case .productsSection(let products):
            let product = products[indexPath.item]
            
            let baseHeight: CGFloat = 180 // image
            let titleHeight = product.title.heightWithConstrainedWidth(
                width: (UIScreen.main.bounds.width / 3) - 24,
                font: UIFont.systemFont(ofSize: 14)
            )
            
            return baseHeight + titleHeight + 40 // space for category + price + rating
        }
    }
    
    func tagName(for indexPath: IndexPath) -> String { return "" }
}
