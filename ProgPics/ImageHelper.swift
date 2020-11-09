//
//  ImageHelper.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-10-19.
//

import Foundation
import UIKit

class ImageHelper
{
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func cropTo43(image: UIImage) -> UIImage
    {
        let cgimage = image.cgImage!
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.width*1.33333)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
    }
    
}
