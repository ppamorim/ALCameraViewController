//
//  NConfirmViewController.swift
//  ALCameraViewController
//
//  Created by Pedro Paulo Amorim on 02/04/16.
//  Copyright © 2016 zero. All rights reserved.
//

import UIKit
import Photos

<<<<<<< HEAD
class ConfirmViewController: UIViewController {
  
    var didUpdateViews = false
    var allowsCropping = false
    
    var onComplete: CameraViewCompletion?
    var asset: PHAsset!
    
    var confirmButtonEdgeOneConstraint: NSLayoutConstraint?
    var confirmButtonGravityConstraint: NSLayoutConstraint?
    
    var cancelButtonEdgeOneConstraint: NSLayoutConstraint?
    var cancelButtonGravityConstraint: NSLayoutConstraint?
    
    var cameraOverlayEdgeOneConstraint: NSLayoutConstraint?
    var cameraOverlayEdgeTwoConstraint: NSLayoutConstraint?
    var cameraOverlayWidthConstraint: NSLayoutConstraint?
    var cameraOverlayCenterConstraint: NSLayoutConstraint?

    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let loaderView : UIActivityIndicatorView = {
       let loaderView = UIActivityIndicatorView()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        return loaderView
    }()

    let confirmButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "confirmButton",
            inBundle: CameraGlobals.shared.bundle,
            compatibleWithTraitCollection: nil),
                        forState: .Normal)
        return button
    }()

    let cancelButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "retakeButton",
            inBundle: CameraGlobals.shared.bundle,
            compatibleWithTraitCollection: nil),
                        forState: .Normal)
        return button
    }()
    
    let cameraOverlay : CropOverlay = {
        let cameraOverlay = CropOverlay()
        cameraOverlay.translatesAutoresizingMaskIntoConstraints = false
        cameraOverlay.hidden = false
        return cameraOverlay
    }()

    internal override func prefersStatusBarHidden() -> Bool {
        return true
    }

    internal override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
=======
public class ConfirmViewController: UIViewController, UIScrollViewDelegate {
    
    let imageView = UIImageView()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cropOverlay: CropOverlay!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var centeringView: UIView!
    
    var allowsCropping: Bool = false
    var verticalPadding: CGFloat = 30
    var horizontalPadding: CGFloat = 30
    
    public var onComplete: CameraViewCompletion?
    
    var asset: PHAsset!
    
    public init(asset: PHAsset, allowsCropping: Bool) {
        self.allowsCropping = allowsCropping
        self.asset = asset
        super.init(nibName: "ConfirmViewController", bundle: CameraGlobals.shared.bundle)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    public override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
>>>>>>> AlexLittlejohn/master

    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.blackColor()
        [scrollView,
            confirmButton,
            cancelButton,
            cameraOverlay,
            loaderView].forEach({ self.view.addSubview($0) })
        scrollView.addSubview(imageView)
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonActions()
        fetchImage()
    }

    override func updateViewConstraints() {

        if !didUpdateViews {
            configScrollViewConstraints()
            configImageViewConstraints()
            configLoadingViewConstraints()
            didUpdateViews = true
        }
        
        let padding : CGFloat = 16.0
        let portrait = UIApplication.sharedApplication().statusBarOrientation.isPortrait
        let paddingOverlay : CGFloat = portrait ? padding : -padding

        view.autoRemoveConstraint(confirmButtonGravityConstraint)
        view.autoRemoveConstraint(confirmButtonEdgeOneConstraint)
        
        view.autoRemoveConstraint(cancelButtonGravityConstraint)
        view.autoRemoveConstraint(cancelButtonEdgeOneConstraint)
        
        removeCameraOverlayEdgesConstraints()
        
        configCameraOverlayEdgeOneContraint(portrait, padding: paddingOverlay)
        configCameraOverlayEdgeTwoConstraint(portrait, padding: paddingOverlay)

        configCameraOverlayWidthConstraint(portrait)
        configCameraOverlayCenterConstraint(portrait)
        
        configButtonsEdgeConstraint(&confirmButtonEdgeOneConstraint,
                                    item: confirmButton,
                                    portrait: portrait,
                                    padding: paddingOverlay)
        configConfirmGravityButtonConstraint(portrait, padding: paddingOverlay)
        
        configButtonsEdgeConstraint(&cancelButtonEdgeOneConstraint,
                                    item: cancelButton,
                                    portrait: portrait,
                                    padding: paddingOverlay)
        configCancelGravityButtonConstraint(portrait, padding: paddingOverlay)
        
        super.updateViewConstraints()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let scale = calculateMinimumScale(view.frame.size)
        let frame = allowsCropping ? cameraOverlay.frame : view.bounds
        
        scrollView.contentInset = calculateScrollViewInsets(frame)
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
        centerScrollViewContents()
        centerImageViewOnRotate()
    }

    /**
     * Pin all edges of ScrollView on superview edges.
     */
    func configScrollViewConstraints() {
        [.Left, .Right, .Top, .Bottom].forEach({
            view.addConstraint(NSLayoutConstraint(
                item: scrollView,
                attribute: $0,
                relatedBy: .Equal,
                toItem: view,
                attribute: $0,
                multiplier: 1.0,
                constant: 0))
        })
    }

    /**
     * Pin all edges of ImageView on ScrollView edges.
     */
    func configImageViewConstraints() {
        [.Left, .Right, .Top, .Bottom].forEach({
            view.addConstraint(NSLayoutConstraint(
                item: imageView,
                attribute: $0,
                relatedBy: .Equal,
                toItem: scrollView,
                attribute: $0,
                multiplier: 1.0,
                constant: 0))
        })
    }

    func configLoadingViewConstraints() {
        [.CenterX, .CenterY].forEach({
            view.addConstraint(NSLayoutConstraint(
                item: loaderView,
                attribute: $0,
                relatedBy: .Equal,
                toItem: view,
                attribute: $0,
                multiplier: 1.0,
                constant: 0))
        })
    }
    
<<<<<<< HEAD
    /**
     * Define the position of the ConfirmButton on the
     * left side of superview, this method will try to
     * center the view to the center of superview and
     * move to the left if necessary.
     */
    func configConfirmGravityButtonConstraint(portrait: Bool, padding: CGFloat) {
        confirmButtonGravityConstraint = NSLayoutConstraint(
            item: confirmButton,
            attribute: portrait ? .Right : .Top,
            relatedBy: .LessThanOrEqual,
            toItem: view,
            attribute: portrait ? .CenterX : .CenterY,
            multiplier: 1.0,
            constant: -padding)
        view.addConstraint(confirmButtonGravityConstraint!)
=======
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        let scale = calculateMinimumScale(size)
        var frame = view.bounds
        
        if allowsCropping {
            frame = cropOverlay.frame
            let centeringFrame = centeringView.frame
            var origin: CGPoint
            
            if size.width > size.height { // landscape
                let offset = (size.width - centeringFrame.height)
                let expectedX = (centeringFrame.height/2 - frame.height/2) + offset
                origin = CGPoint(x: expectedX, y: frame.origin.x)
            } else {
                let expectedY = (centeringFrame.width/2 - frame.width/2)
                origin = CGPoint(x: frame.origin.y, y: expectedY)
            }
            
            frame.origin = origin
        } else {
            frame.size = size
        }
        
        coordinator.animateAlongsideTransition({ context in
            self.scrollView.contentInset = self.calculateScrollViewInsets(frame)
            self.scrollView.minimumZoomScale = scale
            self.scrollView.zoomScale = scale
            self.centerScrollViewContents()
            self.centerImageViewOnRotate()
            }, completion: nil)
>>>>>>> AlexLittlejohn/master
    }
    
    /**
     * Define the position of the CancelButton on the
     * right side of superview, this method will try to
     * center the view to the center of superview and
     * move to the right if necessary.
     */
    func configCancelGravityButtonConstraint(portrait: Bool, padding: CGFloat) {
        cancelButtonGravityConstraint = NSLayoutConstraint(
            item: cancelButton,
            attribute: portrait ? .Left : .Bottom,
            relatedBy: .LessThanOrEqual,
            toItem: view,
            attribute: portrait ? .CenterX : .CenterY,
            multiplier: 1.0,
            constant: padding)
        view.addConstraint(cancelButtonGravityConstraint!)
        
    }
    
    /**
     * Define the constraint for the edge of the view,
     * this method will try to pin the buttons on bottom
     * of the superview, when portrait. When landscape,
     * pin it on the left side of superview.
     */
    func configButtonsEdgeConstraint(inout contraint: NSLayoutConstraint?,
                                           item: UIView, portrait: Bool, padding: CGFloat) {
        let attribute : NSLayoutAttribute = portrait ? .Bottom : .Left
        contraint = NSLayoutConstraint(
            item: item,
            attribute: attribute,
            relatedBy: .Equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: -padding)
        view.addConstraint(contraint!)
    }
    
    /**
     * Used to create a perfect square for CameraOverlay.
     * This method will determinate the size of CameraOverlay,
     * if portrait, it will use the width of superview to
     * determinate the height of the view. Else if landscape,
     * it uses the height of the superview to create the width
     * of the CameraOverlay.
     */
    func configCameraOverlayWidthConstraint(portrait: Bool) {
        view.autoRemoveConstraint(cameraOverlayWidthConstraint)
        cameraOverlayWidthConstraint = NSLayoutConstraint(
            item: cameraOverlay,
            attribute: portrait ? .Height : .Width,
            relatedBy: .Equal,
            toItem: cameraOverlay,
            attribute: portrait ? .Width : .Height,
            multiplier: 1.0,
            constant: 0)
        view.addConstraint(cameraOverlayWidthConstraint!)
    }
    
    /**
     * This method will center the relative position of
     * CameraOverlay, based on the biggest size of the
     * superview.
     */
    func configCameraOverlayCenterConstraint(portrait: Bool) {
        view.autoRemoveConstraint(cameraOverlayCenterConstraint)
        let attribute : NSLayoutAttribute = portrait ? .CenterY : .CenterX
        cameraOverlayCenterConstraint = NSLayoutConstraint(
            item: cameraOverlay,
            attribute: attribute,
            relatedBy: .Equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: 0)
        view.addConstraint(cameraOverlayCenterConstraint!)
    }
    
    /**
     * Remove the CameraOverlay constraints to be updated when
     * the device was rotated.
     */
    func removeCameraOverlayEdgesConstraints() {
        view.autoRemoveConstraint(cameraOverlayEdgeOneConstraint)
        view.autoRemoveConstraint(cameraOverlayEdgeTwoConstraint)
    }
    
    /**
     * It needs to get a determined smallest size of the screen
     to create the smallest size to be used on CameraOverlay.
     It uses the orientation of the screen to determinate where
     the view will be pinned.
     */
    func configCameraOverlayEdgeOneContraint(portrait: Bool, padding: CGFloat) {
        let attribute : NSLayoutAttribute = portrait ? .Left : .Bottom
        cameraOverlayEdgeOneConstraint = NSLayoutConstraint(
            item: cameraOverlay,
            attribute: attribute,
            relatedBy: .Equal,
            toItem: view,
            attribute: attribute,
            multiplier: 1.0,
            constant: padding)
        view.addConstraint(cameraOverlayEdgeOneConstraint!)
    }
    
    /**
     * It needs to get a determined smallest size of the screen
     to create the smallest size to be used on CameraOverlay.
     It uses the orientation of the screen to determinate where
     the view will be pinned.
     */
    func configCameraOverlayEdgeTwoConstraint(portrait: Bool, padding: CGFloat) {
        let attributeTwo : NSLayoutAttribute = portrait ? .Right : .Top
        cameraOverlayEdgeTwoConstraint = NSLayoutConstraint(
            item: cameraOverlay,
            attribute: attributeTwo,
            relatedBy: .Equal,
            toItem: view,
            attribute: attributeTwo,
            multiplier: 1.0,
            constant: -padding)
        view.addConstraint(cameraOverlayEdgeTwoConstraint!)
    }
    
    private func calculateMinimumScale(size: CGSize) -> CGFloat {
        var _size = size
        
        if allowsCropping {
            _size = cameraOverlay.frame.size
        }
        
        guard let image = imageView.image else {
            return 1
        }
        
        let scaleWidth = _size.width / image.size.width
        let scaleHeight = _size.height / image.size.height
        
        var scale: CGFloat
        
        if allowsCropping {
            scale = max(scaleWidth, scaleHeight)
        } else {
            scale = min(scaleWidth, scaleHeight)
        }
        
        return scale
    }
    
    private func calculateScrollViewInsets(frame: CGRect) -> UIEdgeInsets {
        let bottom = view.frame.height - (frame.origin.y + frame.height)
        let right = view.frame.width - (frame.origin.x + frame.width)
        let insets = UIEdgeInsets(top: frame.origin.y, left: frame.origin.x, bottom: bottom, right: right)
        return insets
    }
    
    private func centerImageViewOnRotate() {
        if allowsCropping {
            let size = allowsCropping ? cameraOverlay.frame.size : scrollView.frame.size
            let scrollInsets = scrollView.contentInset
            let imageSize = imageView.frame.size
            var contentOffset = CGPoint(x: -scrollInsets.left, y: -scrollInsets.top)
            contentOffset.x -= (size.width - imageSize.width) / 2
            contentOffset.y -= (size.height - imageSize.height) / 2
            scrollView.contentOffset = contentOffset
        }
    }
    
    private func centerScrollViewContents() {
        let size = allowsCropping ? cameraOverlay.frame.size : scrollView.frame.size
        let imageSize = imageView.frame.size
        var imageOrigin = CGPoint.zero
        
        if imageSize.width < size.width {
            imageOrigin.x = (size.width - imageSize.width) / 2
        }
        
        if imageSize.height < size.height {
            imageOrigin.y = (size.height - imageSize.height) / 2
        }
        
        imageView.frame.origin = imageOrigin
    }
    
    func configScrollView() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 1
    }
  
    func fetchImage() {
        
        guard asset != nil else {
            return
        }
        
        showSpinner()
        SingleImageFetcher()
            .setAsset(asset)
            .setTargetSize(largestPhotoSize())
            .onSuccess { image in
                self.configureWithImage(image)
                self.hideSpinner()
                self.toggleButton(true)
            }
            .onFailure { error in
                self.hideSpinner()
            }
            .fetch()
    }
    
    func showSpinner() {
        loaderView.hidden = false
        loaderView.startAnimating()
    }
    
    func hideSpinner() {
        loaderView.hidden = true
        loaderView.stopAnimating()
    }
    
    func toggleButton(enabled: Bool) {
        confirmButton.enabled = enabled
    }
    
    private func configureWithImage(image: UIImage) {
        cameraOverlay.hidden = !allowsCropping
        imageView.image = image
    }
    
    private func buttonActions() {
        confirmButton.action = { [weak self] in self?.confirmPhoto() }
        cancelButton.action = { [weak self] in self?.cancel() }
    }
    
    internal func cancel() {
        onComplete?(nil, nil)
    }
    
    internal func confirmPhoto() {
        
        toggleButton(false)
        
        imageView.hidden = true
        
        showSpinner()
        
        let fetcher = SingleImageFetcher()
            .onSuccess { image in
                self.onComplete?(image, self.asset)
                self.hideSpinner()
                self.toggleButton(true)
            }
            .onFailure { error in
                self.hideSpinner()
//                self.showNoImageScreen(error)
            }
            .setAsset(asset)
        
        if allowsCropping {
            
            var cropRect = cameraOverlay.frame
            cropRect.origin.x += scrollView.contentOffset.x
            cropRect.origin.y += scrollView.contentOffset.y
            
            let normalizedX = cropRect.origin.x / imageView.frame.width
            let normalizedY = cropRect.origin.y / imageView.frame.height
            
            let normalizedWidth = cropRect.width / imageView.frame.width
            let normalizedHeight = cropRect.height / imageView.frame.height
            
            let rect = normalizedRect(CGRect(x: normalizedX, y: normalizedY, width: normalizedWidth, height: normalizedHeight), orientation: imageView.image!.imageOrientation)
            
            fetcher.setCropRect(rect)
        }
        
        fetcher.fetch()
    }
    
<<<<<<< HEAD
}

extension ConfirmViewController : UIScrollViewDelegate {
    
    internal func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
=======
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
>>>>>>> AlexLittlejohn/master
        return imageView
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
}
