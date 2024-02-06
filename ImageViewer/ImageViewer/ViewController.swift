//
//  ViewController.swift
//  ImageViewer
//
//  Created by Quang on 06/02/2024.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    // Declare the scrollView and imageView
    let scrollView = UIScrollView()
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the scrollView
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0 // You can adjust the maximum zoom level as needed
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // Set up the imageView
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_src") // Replace with the name of your image
        
        // Add the imageView to the scrollView
        scrollView.addSubview(imageView)
        
        // Add the scrollView to the view hierarchy
        view.addSubview(scrollView)
        
        // Set up double-tap gesture
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Set the frame of the scrollView to match the view's bounds
        scrollView.frame = view.bounds
        imageView.frame = .init(x: .zero, y: .zero, width: view.bounds.width, height: view.bounds.height)
        
        // Set the content size of the scrollView to match the imageView's size
        scrollView.contentSize = imageView.bounds.size
        
        // Set the initial zoom scale
        updateZoomScale()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func updateZoomScale() {
        // Calculate the initial zoom scale to fit the image in the scrollView
        let widthScale = scrollView.bounds.width / imageView.bounds.width
        let heightScale = scrollView.bounds.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    @objc func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        // Zoom in or out depending on the current zoom scale
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.zoom(to: zoomRectForScale(scrollView.maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.width = scrollView.frame.size.width / scale
        zoomRect.size.height = scrollView.frame.size.height / scale
        let newCenter = scrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}
