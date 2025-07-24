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

class HomeViewController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<HomeSectionModel>!
    var viewModel: HomeViewModel!
    
    private var isGridLayout = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupDataSource()
        bindViewModel()
        setupLayoutToggleButton()
        
        if viewModel.products.value.isEmpty {
            viewModel.loadInitialProducts()
        }
    }
    
    func configure(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Setup Toggle Button
    private func setupLayoutToggleButton() {
        let toggleButton = UIBarButtonItem(
            title: "List",
            style: .plain,
            target: self,
            action: #selector(toggleLayout)
        )
        navigationItem.rightBarButtonItem = toggleButton
    }
    
    // MARK: - Setup Collection View
    private func setupCollectionView() {
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        collectionView.setCollectionViewLayout(pinterestLayout, animated: false)
        
        collectionView.register(
            UINib(nibName: "ProductCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ProductCollectionViewCell"
        )
        
        collectionView.delegate = self
        
        // Infinite scroll trigger (safe)
        collectionView.rx.contentOffset
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance) // prevent spam
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                // Don’t trigger while already loading
                if self.viewModel.isLoading.value { return }
                
                let contentHeight = self.collectionView.contentSize.height
                let scrollHeight = self.collectionView.frame.size.height
                
                // Trigger when 1.5 screens before bottom
                let threshold = contentHeight - scrollHeight * 1.5
                
                if offset.y > threshold {
                    self.viewModel.loadMoreProducts()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup Rx DataSource
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
    
    
    
    // MARK: - Bind ViewModel
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
    
    // MARK: - Layout Toggle Action
    
    @objc private func toggleLayout() {
        isGridLayout.toggle()
        
        if isGridLayout {
            let pinterestLayout = PinterestLayout()
            pinterestLayout.delegate = self
            collectionView.setCollectionViewLayout(pinterestLayout, animated: true)
            navigationItem.rightBarButtonItem?.title = "List"
        } else {
            let listLayout = UICollectionViewFlowLayout()
            listLayout.scrollDirection = .vertical
            listLayout.itemSize = CGSize(
                width: collectionView.frame.width - 20,
                height: 240
            )
            listLayout.minimumLineSpacing = 12
            listLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            collectionView.setCollectionViewLayout(listLayout, animated: true)
            navigationItem.rightBarButtonItem?.title = "Grid"
        }
        
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        
        
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
    
    
    // MARK: - Navigation
    private func showProductDetails(_ product: Product) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController {
            detailsVC.product = product
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

// MARK: - Pinterest Masonry Layout
extension HomeViewController: PinterestLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.sectionModels[indexPath.section]
        switch section {
        case .productsSection(let products):
            let product = products[indexPath.item]
            
            let columnWidth = (UIScreen.main.bounds.width / 3) - 24
            
          
            let imageHeight: CGFloat = columnWidth
            
            
            let titleFont = UIFont(name: "Nunito-Bold", size: 14) ?? .systemFont(ofSize: 14)
            let titleHeight = product.title.heightWithConstrainedWidth(width: columnWidth, font: titleFont)
            
            let categoryFont = UIFont(name: "Nunito-Regular", size: 12) ?? .systemFont(ofSize: 12)
            let categoryHeight = "Category: \(product.category.capitalized)"
                .heightWithConstrainedWidth(width: columnWidth, font: categoryFont)
            
            let priceFont = UIFont(name: "Nunito-ExtraBold", size: 16) ?? .systemFont(ofSize: 16)
            let priceHeight = String(format: "$%.2f", product.price)
                .heightWithConstrainedWidth(width: columnWidth, font: priceFont)
            
            let ratingFont = UIFont(name: "Nunito-Regular", size: 12) ?? .systemFont(ofSize: 12)
            let stars = String(repeating: "⭐️", count: Int(product.rating.rate.rounded()))
            let ratingHeight = "\(stars) (\(product.rating.count))"
                .heightWithConstrainedWidth(width: columnWidth, font: ratingFont)
            
            let verticalSpacing: CGFloat = 8 * 4
            
         
            return imageHeight + titleHeight + categoryHeight + priceHeight + ratingHeight + verticalSpacing
        }
    }

    
    func tagName(for indexPath: IndexPath) -> String { return "" }
}

