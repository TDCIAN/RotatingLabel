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
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.layer.borderColor = UIColor.red.cgColor
        stackView.layer.borderWidth = 1
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setup()
        
        self.setStackViewLabelRotation(with: "$1,234,567,890")
    }
    
    private func setup() {
        self.view.addSubview(self.rotatingLabelsStackView)
        NSLayoutConstraint.activate([
            self.rotatingLabelsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.rotatingLabelsStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func setStackViewLabelRotation(with string: String) {
//        self.rotatingLabelsStackView.makeRotatingTextLabel(
//            string: string,
//            font: .systemFont(ofSize: 16, weight: .bold),
//            textColor: .systemBlue
//        )
        self.rotatingLabelsStackView.makeRotatingTextLabel2(
            string: string,
            font: .systemFont(ofSize: 32, weight: .bold),
            textColor: .systemBlue
        )
    }
}

extension UIStackView {
    func makeRotatingTextLabel2(string: String, font: UIFont, textColor: UIColor) {
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

            let originalText = label.text
            label.text = "\(Int.random(in: 1...10))"
            label.alpha = 0.0
            label.frame.origin.y = -40
            UIView.animate(
                withDuration: 1,
                delay: Double(index) * 0.02,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 2,
                options: .curveEaseIn,
                animations: {
                    label.text = originalText
                    label.alpha = 1.0
                    label.frame.origin.y = 0
                })
        }
    }
    
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
