//
//  HomeViewController.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SkeletonView

final class HomeViewController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource: RxCollectionViewSectionedAnimatedDataSource<HomeSectionModel>!
    var viewModel: HomeViewModel!
    
    private var isGridLayout = true
    private var layoutToggleButton: UIButton!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupDataSource()
        bindViewModel()
        setupLayoutToggleButton()
        if viewModel.products.value.isEmpty {
            collectionView.showAnimatedGradientSkeleton()
            viewModel.loadInitialProducts()
        }
    }
    
    func configure(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupUI() {
        collectionView.isSkeletonable = true
    }
    
    private func setupLayoutToggleButton() {
        layoutToggleButton = UIButton(type: .system)
        layoutToggleButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        layoutToggleButton.setTitle(" " + "listToggleTitle".localized(), for: .normal)
        layoutToggleButton.semanticContentAttribute = .forceLeftToRight
        layoutToggleButton.tintColor = .systemRed
        layoutToggleButton.setTitleColor(.systemRed, for: .normal)
        layoutToggleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        layoutToggleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        layoutToggleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        layoutToggleButton.addTarget(self, action: #selector(toggleLayout), for: .touchUpInside)
        layoutToggleButton.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: layoutToggleButton)
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
        refreshControl.tintColor = .systemRed
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupDataSource() {
        dataSource = RxCollectionViewSectionedAnimatedDataSource<HomeSectionModel>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                            reloadAnimation: .fade,
                                                            deleteAnimation: .fade),
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
        bindLoading(viewModel.isLoading, on: collectionView)
        
        viewModel.products
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
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
    
    @objc private func refreshData() {
        refreshControl.beginRefreshing()
        
        
        let status = ReachabilityManager.shared.monitor.currentPath.status
        guard status == .satisfied else {
            refreshControl.endRefreshing()
            SwiftMessagesService.show(message: "errorNoInternet".localized(), theme: .error)
            return
        }
        
        
        ReachabilityManager.shared.verifyInternetAccess { hasInternet in
            if hasInternet {
                self.viewModel.loadInitialProducts()
            } else {
                self.refreshControl.endRefreshing()
                SwiftMessagesService.show(
                    message: "No actual internet connection".localized(),
                    theme: .error
                )
            }
        }
    }


    
    @objc private func toggleLayout() {
        isGridLayout.toggle()
        
        if isGridLayout {
            let pinterestLayout = PinterestLayout()
            pinterestLayout.delegate = self
            collectionView.setCollectionViewLayout(pinterestLayout, animated: true)
            layoutToggleButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            layoutToggleButton.setTitle(" " + "listToggleTitle".localized(), for: .normal)
        } else {
            let listLayout = UICollectionViewFlowLayout()
            listLayout.scrollDirection = .vertical
            let availableWidth = collectionView.bounds.width - LayoutMetrics.sectionInset.left - LayoutMetrics.sectionInset.right
            listLayout.itemSize = CGSize(width: availableWidth, height: LayoutMetrics.listCellHeight)
            listLayout.minimumLineSpacing = LayoutMetrics.gridSpacing
            listLayout.sectionInset = LayoutMetrics.sectionInset
            collectionView.setCollectionViewLayout(listLayout, animated: true)
            layoutToggleButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
            layoutToggleButton.setTitle(" " + "gridToggleTitle".localized(), for: .normal)
        }
        
        layoutToggleButton.sizeToFit()
        collectionView.collectionViewLayout.invalidateLayout()
        
        for cell in collectionView.visibleCells {
            if let indexPath = collectionView.indexPath(for: cell),
               let productCell = cell as? ProductCollectionViewCell {
                let section = dataSource.sectionModels[indexPath.section]
                if case .productsSection(let products) = section {
                    let product = products[indexPath.item]
                    productCell.configure(with: product, isGrid: isGridLayout)
                }
            }
        }
    }
    
    private func showProductDetails(_ product: Product) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController {
            detailsVC.product = product
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension HomeViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.sectionModels[indexPath.section]
        switch section {
        case .productsSection(let products):
            let product = products[indexPath.item]
            let availableWidth = collectionView.bounds.width - LayoutMetrics.sectionInset.left - LayoutMetrics.sectionInset.right - (LayoutMetrics.gridSpacing * (LayoutMetrics.gridColumns - 1))
            let columnWidth = availableWidth / LayoutMetrics.gridColumns
            let imageHeight = columnWidth
            let titleHeight = product.title.heightWithConstrainedWidth(width: columnWidth, font: LayoutMetrics.Fonts.title)
            let categoryHeight = "Category: \(product.category.capitalized)".heightWithConstrainedWidth(width: columnWidth, font: LayoutMetrics.Fonts.category)
            let priceHeight = String(format: "$%.2f", product.price).heightWithConstrainedWidth(width: columnWidth, font: LayoutMetrics.Fonts.price)
            let stars = String(repeating: "⭐️", count: Int(product.rating.rate.rounded()))
            let ratingHeight = "\(stars) (\(product.rating.count))".heightWithConstrainedWidth(width: columnWidth, font: LayoutMetrics.Fonts.rating)
            let verticalSpacing = LayoutMetrics.gridSpacing * 4
            return imageHeight + titleHeight + categoryHeight + priceHeight + ratingHeight + verticalSpacing
        }
    }
    
    func tagName(for indexPath: IndexPath) -> String { return "" }
}
