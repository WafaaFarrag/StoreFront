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

final class ProductsViewController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<HomeSectionModel>!
    var viewModel: HomeViewModel!
    
    private var isGridLayout = true
    
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
    }
    
    private func setupDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell: { [weak self] _, collectionView, indexPath, item in
                guard let self = self else { return UICollectionViewCell() }
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ProductCollectionViewCell",
                    for: indexPath
                ) as! ProductCollectionViewCell
                cell.configure(with: item, isGrid: self.isGridLayout)
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
        
        collectionView.rx.contentOffset
            .map { [weak self] offset -> CGFloat in
                guard let self = self else { return 0 }
                let contentHeight = self.collectionView.contentSize.height
                let scrollHeight = self.collectionView.bounds.height
                return contentHeight - (offset.y + scrollHeight)
            }
            .bind(to: viewModel.scrollOffset)
            .disposed(by: disposeBag)
    }
    
    private func showProductDetails(_ product: Product) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController {
            detailsVC.product = product
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension ProductsViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.sectionModels[indexPath.section]
        
        switch section {
        case .productsSection(let products):
            let product = products[indexPath.item]
            
            let availableWidth = collectionView.bounds.width
            - LayoutMetrics.sectionInset.left
            - LayoutMetrics.sectionInset.right
            - (LayoutMetrics.gridSpacing * (LayoutMetrics.gridColumns - 1))
            let columnWidth = availableWidth / LayoutMetrics.gridColumns
            
            let imageHeight = columnWidth
            
            let titleHeight = product.title.heightWithConstrainedWidth(width: columnWidth, font: LayoutMetrics.Fonts.title)
            let categoryHeight = "Category: \(product.category.capitalized)"
                .heightWithConstrainedWidth(width: columnWidth, font: LayoutMetrics.Fonts.category)
            let priceHeight = String(format: "$%.2f", product.price)
                .heightWithConstrainedWidth(width: columnWidth, font: LayoutMetrics.Fonts.price)
            let stars = String(repeating: "⭐️", count: Int(product.rating.rate.rounded()))
            let ratingHeight = "\(stars) (\(product.rating.count))"
                .heightWithConstrainedWidth(width: columnWidth, font: LayoutMetrics.Fonts.rating)
            
            let verticalSpacing = LayoutMetrics.gridSpacing * 4
            
            return imageHeight + titleHeight + categoryHeight + priceHeight + ratingHeight + verticalSpacing
        }
    }
    
    func tagName(for indexPath: IndexPath) -> String { return "" }
}
