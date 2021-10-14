//
//  ViewController.swift
//  CameraFilter
//
//  Created by daffolapmac-190 on 05/10/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    // MARK:  Private Data Members
    private let disposeBag = DisposeBag()
    
    // MARK:  IBOutlets
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    // MARK:  IBActions
    @IBAction func applyFilterButtonPressed(_ sender: UIButton) {
        
        guard let sourceImage = self.photoImageView.image else { return }
        
        //Use the filter service to apply the filter
        FilterService().applyFilter(to: sourceImage) { theFilteredImage in
            DispatchQueue.main.async {
                self.photoImageView.image = theFilteredImage
            }
        }
    }
    
    
}

// MARK:  Lifecycle Methods
extension ViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else{
            fatalError("Segue destination is not found")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] theImage in
            
            DispatchQueue.main.async {
                self?.updateUI(with: theImage)
            }
            
        }).disposed(by: disposeBag)
    }
}

// MARK:  Priavte Methods
private extension ViewController{
    func updateUI(with image : UIImage){
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }
}



