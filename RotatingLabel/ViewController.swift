//
//  ViewController.swift
//  RotatingLabel
//
//  Created by 김정민 on 7/2/24.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var rotatingLabelsStackView1: UIStackView = {
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
    
    private lazy var rotatingLabelsStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.layer.borderColor = UIColor.blue.cgColor
        stackView.layer.borderWidth = 1
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setup()
        
        self.rotatingLabelsStackView1.makeRotatingTextLabel(
            string: "$1,234,567,890",
            font: .systemFont(ofSize: 24, weight: .bold),
            textColor: .label
        )
        
        self.rotatingLabelsStackView2.makeRotatingTextLabel3(
            string: "$1,234,567,890",
            font: .systemFont(ofSize: 24, weight: .bold),
            textColor: .systemPink
        )
    }
    
    private func setup() {
        self.view.addSubview(self.rotatingLabelsStackView1)
        NSLayoutConstraint.activate([
            self.rotatingLabelsStackView1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.rotatingLabelsStackView1.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100)
        ])
        
        self.view.addSubview(self.rotatingLabelsStackView2)
        NSLayoutConstraint.activate([
            self.rotatingLabelsStackView2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100),
            self.rotatingLabelsStackView2.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 100)
        ])
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
            
            animation.repeatCount = 1
//            animation.repeatCount = .infinity
            
            label.layer.add(animation, forKey: "rotation")
        }
    }
    
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
    
    // Use this
    func makeRotatingTextLabel3(string: String, font: UIFont, textColor: UIColor) {
        let labels: [CountPushLabel] = string.map { character in
            let label = CountPushLabel()
            label.text = String(character)
            label.font = font
            label.textColor = textColor
            return label
        }
        
        labels.forEach { label in
            self.addArrangedSubview(label)
        }
        
        for (index, label) in labels.enumerated() {
            guard let labelNumber = Int(label.text ?? "") else { continue }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(index * 100)) {
                label.config(num: labelNumber, rotationCount: 2, duration: 0.05) // use it
//                label.config(num: labelNumber, cycle: 0, duration: 1)
                label.animate()
            }
        }
    }
}

class CountPushLabel: UILabel, CAAnimationDelegate {
    var originalRotationCount: Int!
    var rotationCount: Int!
    var originalLabelNumber: Int = 0
    var currentLabelNumber: Int = 0 {
        didSet {
            if self.currentLabelNumber > 9 {
                self.rotationCount -= 1
                self.currentLabelNumber = 0
            }
        }
    }
    var duration: TimeInterval!
    
    func config(num: Int, rotationCount: Int = 1, duration: TimeInterval = 1) {
        self.originalRotationCount = rotationCount
        self.rotationCount = rotationCount
        self.originalLabelNumber = num
        self.currentLabelNumber = num
        self.duration = duration
        self.text = "\(num)"
    }
    
    func animate() {
        self.currentLabelNumber += 1
        self.text = "\(self.currentLabelNumber)"
        self.pushAnimate()
    }
    
    private func pushAnimate() {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = .init(name: .easeInEaseOut)
        transition.type = .push
//        transition.subtype = .fromTop // 숫자가 아래에서 위로
        transition.subtype = .fromBottom // 숫자가 위에서 아래로
        transition.delegate = self
        self.layer.add(transition, forKey: CATransitionType.push.rawValue)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.currentLabelNumber == self.originalLabelNumber && self.rotationCount <= 0 {
            self.layer.removeAllAnimations()
            return
        }
        self.animate()
    }
    
    func clean() {
        self.config(
            num: self.originalLabelNumber,
            rotationCount: self.originalRotationCount
        )
    }
}
