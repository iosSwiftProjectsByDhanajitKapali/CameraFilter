//
//  FilterService.swift
//  CameraFilter
//
//  Created by daffolapmac-190 on 12/10/21.
//

import UIKit
import CoreImage

class FilterService{
    private var context : CIContext
    
    init(){
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ()) ){
        //get the required filter
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        //conver the UIImage to CIIMage
        if let sourceImage = CIImage(image: inputImage){
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent){
                
                let ptocessedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(ptocessedImage)
            }
        }
    }
}
