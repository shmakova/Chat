//
//  ImagesViewController.swift
//  Chat
//
//  Created by Anastasia Shmakova on 18.11.2020.
//  Copyright © 2020 Shmakova Anastasia. All rights reserved.
//

import UIKit

class ImagesViewController: BaseViewController {
    private let cellIdentifier = String(describing: ImageCollectionViewCell.self)
    private let sectionInsets = UIEdgeInsets(
        top: 8,
        left: 8,
        bottom: 8,
        right: 8
    )
    private let itemsPerRow: CGFloat = 3
    private var images: [ImageCellModel] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model: ImagesModelProtocol!
    var onImagePicked: ((ImageCellModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            UINib(nibName: String(describing: ImageCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: cellIdentifier
        )
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
        applyTheme(model.currentTheme)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        collectionView.isHidden = true
        model.loadImages()
    }
    
    @IBAction func onCloseTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        model.clearCache()
    }
}

extension ImagesViewController: ThemeableView {
    func applyTheme(_ theme: Theme) {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = theme.userInterfaceStyle
        }
        view.backgroundColor = theme.colors.backgroundColor
        navigationBar?.barTintColor = theme.colors.navigationBarColor
        navigationBar?.titleTextAttributes = [.foregroundColor: theme.colors.primaryTextColor]
        activityIndicator.style = theme.activityIndicatorStyle
    }
}

extension ImagesViewController: ImagesViewControllerDelegate {
    func handleLoadImagesResult(_ result: Result<[ImageCellModel], Error>) {
        assert(Thread.isMainThread)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        collectionView.isHidden = false
        switch result {
        case let .success(images):
            self.images = images
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
        case let .failure(error):
            log("Load images error: \(error)")
        }
    }
}

extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        ) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let imageCellModel = images[indexPath.row]
        let identifier = imageCellModel.identifier
        cell.representedIdentifier = identifier
        cell.configure(with: nil)
        let placeholderImage = UIImage(named: "PlaceholderIcon")
        cell.configure(with: placeholderImage)
        model.loadImage(model: imageCellModel, completion: {
            guard cell.representedIdentifier == identifier else { return }
            switch $0 {
            case let .success(image):
                cell.configure(with: image)
            case let .failure(error):
                log("Load image error \(error)")
                cell.configure(with: placeholderImage)
            }
        })
        return cell
    }
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = sectionInsets.left * itemsPerRow + sectionInsets.right
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        onImagePicked?(images[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
