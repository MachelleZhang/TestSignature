//
//  SignatureCreateController.swift
//  TestSignature
//
//  Created by ZhangLe on 2021/1/5.
//

import UIKit

public protocol SignatureDelegate: class {
    func signatureFinish(sigImage: UIImage)
}

public class SignatureCreateController: UIViewController, SignatureDrawingViewControllerDelegate {
    private var signatureController: SignatureDrawingViewController?

    public weak var delegate: SignatureDelegate?
    public var composeBackground = false // 合成背景图片

    private let hor_margin: CGFloat = 30 // 水平边距
    private let ver_margin: CGFloat = 10 // 垂直边距
    private let buttonWidth: CGFloat = 60 // 按钮宽度
    private let buttonHeight: CGFloat = 30 // 按钮高度
    private let buttonSpace: CGFloat = 100 // 按钮间距

    private var imgLeftCon: NSLayoutConstraint?
    private var imgRightCon: NSLayoutConstraint?
    private var drawLeftCon: NSLayoutConstraint?
    private var drawRightCon: NSLayoutConstraint?

    // MARK: - View life circle

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = []

//        view.addSubview(imgView)
//        imgLeftCon = imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hor_margin)
//        imgRightCon = imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hor_margin)
//        NSLayoutConstraint.activate([
//            imgLeftCon!,
//            imgView.topAnchor.constraint(equalTo: view.topAnchor, constant: ver_margin),
//            imgRightCon!,
//            imgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(ver_margin * 4 + buttonHeight)),
//        ])

        view.addSubview(sheetView)
        imgLeftCon = sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hor_margin)
        imgRightCon = sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hor_margin)
        NSLayoutConstraint.activate([
            imgLeftCon!,
            sheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: ver_margin),
            imgRightCon!,
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(ver_margin * 4 + buttonHeight)),
        ])

        signatureController = SignatureDrawingViewController()
        signatureController?.view.translatesAutoresizingMaskIntoConstraints = false
        signatureController?.delegate = self
        addChild(signatureController!)
        view.addSubview(signatureController!.view)
        signatureController?.didMove(toParent: self)

        view.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -buttonSpace),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -ver_margin * 2),
            confirmButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            confirmButton.widthAnchor.constraint(equalToConstant: buttonWidth),
        ])

        view.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -ver_margin * 2),
            clearButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            clearButton.widthAnchor.constraint(equalToConstant: buttonWidth),
        ])

        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: buttonSpace),
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -ver_margin * 2),
            closeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            closeButton.widthAnchor.constraint(equalToConstant: buttonWidth),
        ])

        drawLeftCon = signatureController!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hor_margin)
        drawRightCon = signatureController!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hor_margin)
        NSLayoutConstraint.activate([
            drawLeftCon!,
            signatureController!.view.topAnchor.constraint(equalTo: view.topAnchor, constant: ver_margin),
            drawRightCon!,
            signatureController!.view.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -ver_margin * 2),
        ])
    }

    override public func viewSafeAreaInsetsDidChange() {
        var leftSafeArea: CGFloat = 20
        var rightSafeArea: CGFloat = 20
        if #available(iOS 11.0, *) {
            leftSafeArea = view.safeAreaInsets.left
            rightSafeArea = view.safeAreaInsets.right
        }
        leftSafeArea = leftSafeArea < 20 ? 20 : leftSafeArea
        rightSafeArea = rightSafeArea < 20 ? 20 : rightSafeArea

        imgLeftCon?.isActive = false
        imgRightCon?.isActive = false
        imgLeftCon = sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftSafeArea)
        imgRightCon = sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightSafeArea)
        imgLeftCon?.isActive = true
        imgRightCon?.isActive = true

        drawLeftCon?.isActive = false
        drawRightCon?.isActive = false
        drawLeftCon = signatureController!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftSafeArea)
        drawRightCon = signatureController!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightSafeArea)
        drawLeftCon?.isActive = true
        drawRightCon?.isActive = true
    }

    override public var shouldAutorotate: Bool {
        return false
    }

    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }

    // MARK: - SignatureDrawingViewControllerDelegate

    public func signatureDrawingViewControllerIsEmptyDidChange(controller: SignatureDrawingViewController, isEmpty: Bool) {
        clearButton.isEnabled = !isEmpty
        confirmButton.isEnabled = !isEmpty
    }

    // MARK: - Methods

    private func imageFromBundle(name: String) -> UIImage? {
        let bundle = Bundle(for: SignatureCreateController.self)
        let path = bundle.path(forResource: name, ofType: "png")
        if let path = path {
            let img = UIImage(contentsOfFile: path)
            return img
        }
        return nil
    }

//    public func setBackgroundImage(_ image: UIImage) {
//        imgView.image = image
//    }

    private func composeImage(img1: UIView, img2: UIImage) -> UIImage {
        let cgimg2 = img2.cgImage
        let w2 = cgimg2?.width
        let h2 = cgimg2?.height

        UIGraphicsBeginImageContext(CGSize(width: w2!, height: h2!))
        img1.draw(CGRect(x: 0, y: 0, width: w2!, height: h2!))
        img2.draw(in: CGRect(x: 0, y: 0, width: w2!, height: h2!))
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImg!
    }

//    private func generateBackground(_ rect: CGRect) -> UIImage {
//        UIGraphicsBeginImageContext(CGSize(width: rect.size.width, height: rect.size.height))
//        let ctx = UIGraphicsGetCurrentContext()
//
//        let vertical_line_count = 50
//        let vertical_spacing: CGFloat = rect.size.height / CGFloat(vertical_line_count)
//        let lengths: [CGFloat] = [5, 5]
//        ctx?.setStrokeColor(UIColor.green.cgColor)
//        ctx?.setLineDash(phase: 0, lengths: lengths)
//        ctx?.strokePath()
//        for i in 0 ... vertical_line_count {
//            ctx?.move(to: CGPoint(x: 0, y: CGFloat(i) * vertical_spacing))
//            ctx?.addLine(to: CGPoint(x: rect.width, y: CGFloat(i) * vertical_spacing))
//        }
//
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
//    }

    // MARK: - Actions

    @objc private func confirm() {
        let img = signatureController?.fullSignatureImage
        if composeBackground {
            let resultImg = composeImage(img1: sheetView, img2: img!)
            delegate?.signatureFinish(sigImage: resultImg)
        } else {
            delegate?.signatureFinish(sigImage: img!)
        }
    }

    @objc private func clear() {
        signatureController?.reset()
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Lazy loading

    private lazy var confirmButton: UIButton = {
        let confirmButton = UIButton(type: .custom)
        confirmButton.isEnabled = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.setTitleColor(.gray, for: .disabled)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.lightGray.cgColor
        return confirmButton
    }()

    private lazy var clearButton: UIButton = {
        let clearButton = UIButton(type: .custom)
        clearButton.isEnabled = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("清除", for: .normal)
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.setTitleColor(.gray, for: .disabled)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        clearButton.layer.cornerRadius = 5
        clearButton.layer.borderWidth = 1
        clearButton.layer.borderColor = UIColor.lightGray.cgColor
        return clearButton
    }()

    private lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("关闭", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.lightGray.cgColor
        return closeButton
    }()

    lazy var sheetView: SignatureSheetView = {
        let view = SignatureSheetView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

//    private lazy var imgView: UIImageView = {
//        let imgView = UIImageView()
//        imgView.image = imageFromBundle(name: "Signature.bundle/tianzi2")
//        imgView.translatesAutoresizingMaskIntoConstraints = false
//        return imgView
//    }()
}
