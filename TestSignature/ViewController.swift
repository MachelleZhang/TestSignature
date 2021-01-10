//
//  ViewController.swift
//  TestSignature
//
//  Created by ZhangLe on 2021/1/5.
//

import UIKit

class ViewController: UIViewController, SignatureDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            confirmButton.heightAnchor.constraint(equalToConstant: 30),
            confirmButton.widthAnchor.constraint(equalToConstant: 60),
        ])

        view.addSubview(signImage)
        NSLayoutConstraint.activate([
            signImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            signImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signImage.heightAnchor.constraint(equalTo: signImage.widthAnchor, multiplier: 0.6),
        ])
    }

    func signatureFinish(sigImage: UIImage) {
        //关闭
        dismiss(animated: true, completion: nil)
        //存储文件
        let data = sigImage.jpegData(compressionQuality: 0.5)
        let path = NSHomeDirectory() + "/Documents/test.jpg"
        let url = URL(fileURLWithPath: path)
        debugPrint(path)
        do {
            try data?.write(to: url)
        } catch {
            debugPrint(error.localizedDescription)
        }
        //展示
        signImage.image = sigImage
    }

    // MARK: - Actions

    @objc func confirm() {
        let signatureController = SignatureCreateController()
        signatureController.modalPresentationStyle = .fullScreen
        signatureController.delegate = self
        signatureController.composeBackground = true
        present(signatureController, animated: true, completion: nil)
    }

    lazy var confirmButton: UIButton = {
        let confirmButton = UIButton(type: .custom)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("弹出", for: .normal)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.lightGray.cgColor
        return confirmButton
    }()

    lazy var signImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
