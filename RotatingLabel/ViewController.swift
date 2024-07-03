//
//  ViewController.swift
//  RotatingLabel
//
//  Created by 김정민 on 7/2/24.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var rotatingLabelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.layer.borderColor = UIColor.red.cgColor
        stackView.layer.borderWidth = 1
        return stackView
    }()
    
    private lazy var rotatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemPink
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        label.text = "$7,777,777"
        label.layer.borderColor = UIColor.green.cgColor
        label.layer.borderWidth = 1
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setup()
        
//        self.rotatingLabel.makeRotatingNumber()
        
        self.setStackViewLabelRotation(with: "$1,000,000,000")
    }
    
    private func setup() {
        self.view.addSubview(self.rotatingLabelsStackView)
        NSLayoutConstraint.activate([
            self.rotatingLabelsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.rotatingLabelsStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
//        self.view.addSubview(self.rotatingLabel)
//        NSLayoutConstraint.activate([
//            self.rotatingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            self.rotatingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//        ])
    }
    
    private func setStackViewLabelRotation(with string: String) {
        self.rotatingLabelsStackView.makeRotatingTextLabel(
            string: string,
            font: .systemFont(ofSize: 16, weight: .bold),
            textColor: .systemBlue
        )
    }
}

extension UIStackView {
    func makeRotatingTextLabel(string: String, font: UIFont, textColor: UIColor) {
        let labels: [UILabel] = string.map { character in
            let label = UILabel()
            label.text = String(character)
            label.font = font
            label.textColor = textColor
            return label
        }
        
        labels.forEach { label in
            self.addArrangedSubview(label)
        }
        
        for (index, label) in labels.enumerated() {
            guard Int(label.text ?? "") != nil else { continue } // With this guard state, only integer character can be rotated.
            let animation = CABasicAnimation(keyPath: "transform.rotation.x")
            
            animation.fromValue = 0
            animation.toValue = Double.pi * 2
            
            // MARK: (1) Rotation speed of a single character
            // Determines the rotation speed of a single character. The smaller the number, the faster it rotates.
            
            // (1-1) faster rotation
//            animation.duration = 0.1
            
            // (1-2) slower rotation
            animation.duration = 1
            
            
            // MARK: (2) Rotation speed of whole string
            // Determines the rotation speed of whole string. The smaller the number, the faster it rotates.
            
            // (2-1) faster rotation
            animation.beginTime = CACurrentMediaTime() + Double(index) * 0.1
            
            // (2-2) slower rotation
//            animation.beginTime = CACurrentMediaTime() + Double(index) * 1


            // MARK: (3) Repeat Count
            // If you set repeatCount as .infinity, it will rotate again and again.
            
//            animation.repeatCount = 1
            animation.repeatCount = .infinity
            
            label.layer.add(animation, forKey: "rotation")
        }
    }
}

extension UILabel {
    func makeRotatingNumber() {
        
        guard let labelText = self.text else { return }
        
        let characters = Array(labelText)
        let labelWidth: CGFloat = 20
        let spacing: CGFloat = 0
        let totalWidth = CGFloat(characters.count) * (labelWidth + spacing)
        
        for (index, character) in characters.enumerated() {
            let label = UILabel()
            label.layer.borderColor = UIColor.yellow.cgColor
            label.layer.borderWidth = 1
            label.text = String(character)
            label.font = self.font
            label.textAlignment = .center
            label.textColor = self.textColor
            label.frame = CGRect(
                x: ((self.superview?.bounds.width ?? 0) - totalWidth) / 2 + CGFloat(index) * (labelWidth + spacing),
                y: (self.superview?.bounds.height ?? 0) / 2,
                width: labelWidth,
                height: self.intrinsicContentSize.height
            )
            self.superview?.addSubview(label)
            
            if Int(label.text ?? "") != nil {
                let animation = CABasicAnimation(keyPath: "transform.rotation.x")
                animation.fromValue = 0
                animation.toValue = Double.pi * 2
                animation.duration = 1
                animation.repeatCount = .infinity
                animation.beginTime = CACurrentMediaTime() + Double(index) * 0.5
                
                label.layer.add(animation, forKey: "rotation")
            }
        }
    }
}
