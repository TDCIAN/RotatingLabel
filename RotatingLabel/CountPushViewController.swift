//
//  CountPushViewController.swift
//  RotatingLabel
//
//  Created by 김정민 on 7/6/24.
//

import UIKit

class CountPushViewController: UIViewController {
    
    private lazy var countPushLabel: CountPushLabel = {
        let label = CountPushLabel()
        label.layer.borderColor = UIColor.green.cgColor
        label.layer.borderWidth = 1
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var animationButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.configuration?.cornerStyle = .capsule
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Animate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(self.animateButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setup()
        
        self.countPushLabel.config(num: 8, rotationCount: 0, duration: 0.1)
    }
    
    private func setup() {
        self.view.addSubview(self.countPushLabel)
        NSLayoutConstraint.activate([
            self.countPushLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.countPushLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.view.addSubview(self.animationButton)
        NSLayoutConstraint.activate([
            self.animationButton.topAnchor.constraint(equalTo: self.countPushLabel.bottomAnchor, constant: 50),
            self.animationButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.animationButton.widthAnchor.constraint(equalToConstant: 100),
            self.animationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func animateButton() {
        print("### 애니메이트 버튼 눌렀다")
        self.countPushLabel.animate()
    }
}


