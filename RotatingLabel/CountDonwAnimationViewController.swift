//
//  CountDonwAnimationViewController.swift
//  RotatingLabel
//
//  Created by 김정민 on 7/6/24.
//

import UIKit

class CountScrollViewController: UIViewController {
    
    private lazy var countDownAnimationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.borderColor = UIColor.red.cgColor
        stackView.layer.borderWidth = 1
        return stackView
    }()
    
    private lazy var animateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Animate", for: .normal)
        button.addTarget(self, action: #selector(self.animateCountScrollLabel), for: .touchUpInside)
        return button
    }()
    
    private lazy var countingLabel: CountingLabel = {
        let label = CountingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.green.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.setup()
        
        self.countDownAnimationStackView.makeCountDownAnimationStackView(
            string: "1,234,567",
            font: .systemFont(ofSize: 18, weight: .bold),
            textColor: .systemBlue
        )

//        self.countingLabel.count(
//            fromValue: 0,
//            toValue: 9,
//            duration: 5,
//            animationType: .EaseOut,
//            counterType: .Int
//        )
    }
    
    private func setup() {
        self.view.addSubview(self.countDownAnimationStackView)
        
        NSLayoutConstraint.activate([
            self.countDownAnimationStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.countDownAnimationStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.view.addSubview(self.animateButton)

        NSLayoutConstraint.activate([
            self.animateButton.topAnchor.constraint(equalTo: self.countDownAnimationStackView.bottomAnchor, constant: 20),
            self.animateButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        self.view.addSubview(self.countingLabel)
        
        NSLayoutConstraint.activate([
            self.countingLabel.topAnchor.constraint(equalTo: self.animateButton.bottomAnchor, constant: 50),
            self.countingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc private func animateCountScrollLabel() {
        
    }
}

extension UIStackView {
    func makeCountDownAnimationStackView(string: String, font: UIFont, textColor: UIColor) {
        let labels: [CountingLabel] = string.map { character in
            let label = CountingLabel()
            label.text = String(character)
            label.font = font
            label.textColor = textColor
            return label
        }
        
        labels.forEach { label in
            self.addArrangedSubview(label)
        }
        
        for (index, label) in labels.enumerated() {
            guard let labelNumber = Float(label.text ?? "") else { continue }
            let fromValue: Float = Float(Int.random(in: 0...9))
            
            label.count(
                fromValue: fromValue,
                toValue: labelNumber,
                duration: 1,
                animationType: .Linear,
                counterType: .Int
            )
        }
    }
}

// refrence: https://www.youtube.com/watch?v=Wz6-IQV_qDw
class CountingLabel: UILabel {
    
    let counterVelocity: Float = 3.0
    
    enum CounterAnimationType {
        case Linear // f(x) = x
        case EaseIn // f(x) = x^3
        case EaseOut // f(x) = (1-x)^3
    }
    
    enum CounterType {
        case Int
        case Float
    }
    
    var startNumber: Float = 0.0
    var endNumber: Float = 0.0
    
    var progress: TimeInterval!
    var duration: TimeInterval!
    var lastUpdate: TimeInterval!
    
    var timer: Timer?
    
    var counterAnimationType: CounterAnimationType!
    var counterType: CounterType!
    
    var currentCounterValue: Float {
        if self.progress >= self.duration {
            return self.endNumber
        }
        
        let precentage = Float(self.progress / self.duration)
        let update = self.updateCounter(counterValue: precentage)
        
        return self.startNumber + (update * (self.endNumber - self.startNumber))
    }
    
    func count(
        fromValue: Float,
        toValue: Float,
        duration: TimeInterval,
        animationType: CounterAnimationType,
        counterType: CounterType
    ) {
        self.startNumber = fromValue
        self.endNumber = toValue
        self.duration = duration
        self.counterAnimationType = animationType
        self.counterType = counterType
        self.progress = 0
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        
        self.invalidateTimer()
        
        if duration == 0 {
            self.updateText(value: toValue)
        }
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.01, 
            target: self,
            selector: #selector(CountingLabel.updateValue),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func updateValue() {
        let now = Date.timeIntervalSinceReferenceDate
        self.progress += (now - self.lastUpdate)
        self.lastUpdate = now
        
        if self.progress >= self.duration {
            self.invalidateTimer()
            self.progress = self.duration
        }
        
        self.updateText(value: self.currentCounterValue)
    }
    
    func updateText(value: Float) {
        switch self.counterType! {
        case .Int:
            self.text = "\(Int(value))"
        case .Float:
            self.text = String(format: "%.2f", value)
        }
    }
    
    func updateCounter(counterValue: Float) -> Float {
        switch self.counterAnimationType! {
        case .Linear:
            return counterValue
        case .EaseIn:
            return powf(counterValue, self.counterVelocity)
        case .EaseOut:
            return powf(1.0 - counterValue, self.counterVelocity)
        }
    }
    
    func invalidateTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
