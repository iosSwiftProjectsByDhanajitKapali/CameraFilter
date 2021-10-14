//
//  PhotosCollectionViewController.swift
//  CameraFilter
//
//  Created by daffolapmac-190 on 05/10/21.
//

import UIKit
import Photos
import RxSwift


class PhotosCollectionViewController: UICollectionViewController {
    
    // MARK: Private Data Members
    private var images = [PHAsset]()
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    
    // MARK: Public Data Members
    public var selectedPhoto : Observable<UIImage>{
        return selectedPhotoSubject.asObservable()
    }
}

// MARK: LifeCycle Methods
extension PhotosCollectionViewController{
    override func viewDidLoad() {
        super.viewDidLoad()

        populatePhotos()
    }
}

// MARK: Private Methods
private extension PhotosCollectionViewController{
    func populatePhotos(){
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized{
                //access the photos library
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                //Moving through the image assets returned
                assets.enumerateObjects { (theImage, theCount, stop) in
                    self?.images.append(theImage)
                    //reversing the images[], to keep the most recent image in the Photos library at index 0
                    self?.images.reverse()
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
            }
        }
    }

}


// MARK: UICollectionView DataSource Methods
extension PhotosCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else{
            fatalError("PhotoCollectionViewCell is not found")
        }
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
                
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { theImage, info in
            
            DispatchQueue.main.async {
                cell.photoImageView.image = theImage
            }
        }
        
        return cell
    }
    
}


// MARK: UICollectionView Delegate Methods
extension PhotosCollectionViewController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] theImage, theInfo in
            
            guard let info = theInfo else { return }
            
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            if !isDegradedImage{
                if let image = theImage{
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
