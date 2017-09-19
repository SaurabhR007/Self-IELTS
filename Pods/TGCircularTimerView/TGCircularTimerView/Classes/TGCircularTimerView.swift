//
//  TGTimerView.swift
//  Tudo Gostoso Receitas
//
//  Created by Mario Cecchi on 6/6/16.
//  Copyright © 2016 Tudo Gostoso Internet. All rights reserved.
//

import UIKit

@IBDesignable
public class TGCircularTimerView: UIView {
    weak public var delegate: TGCircularTimerViewDelegate?
    
    public private(set) var elapsedTime: TimeInterval = 0
    private var lastTick: Date!
    private var timer: Timer!
    public private(set) var counting: Bool = false
    public private(set) var progress: Double!
    public private(set) var remainingTime: TimeInterval!
    @IBInspectable public var duration: Double = 0 {
        didSet {
            reset()
        }
    }
    
    @IBInspectable public var inverted: Bool = false
    @IBInspectable public var textFont: UIFont! {
        didSet {
            label.font = textFont
        }
    }
    
    private let timeCircle = CAShapeLayer()
    private let backgroundCircle = CAShapeLayer()
    private let positionCircle = UIView()
    private let label = UILabel()
    
    private let positionCircleRadius: CGFloat = 10.0
    private let startAngle = CGFloat(-0.5*M_PI)
    private let endAngle = CGFloat(1.5*M_PI)
    private var circleOrigin: CGPoint!
    private var circleRadius: CGFloat!
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        circleOrigin = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        circleRadius = min(frame.size.width, frame.size.height)/2 - positionCircleRadius
        
        let circlePath = UIBezierPath(arcCenter: circleOrigin, radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        backgroundCircle.path = circlePath.cgPath
        timeCircle.path = circlePath.cgPath
        
        positionCircle.frame.size = CGSize(width: 2*positionCircleRadius, height: 2*positionCircleRadius)
        positionCircle.center = CGPoint(x: circleOrigin.x + circleRadius*cos(startAngle),
                                        y: circleOrigin.y + circleRadius*sin(startAngle))
        
        label.frame.size = CGSize(width: 2*circleRadius - 20.0, height: 100)
        label.center = circleOrigin
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.clear
        progress = inverted ? 1 : 0
        
        // Background circle
        backgroundCircle.fillColor = UIColor.clear.cgColor
        backgroundCircle.lineWidth = 5.0
        layer.addSublayer(backgroundCircle)
        
        // Time circle
        timeCircle.fillColor = UIColor.init(patternImage: UIImage.init(named:"umbrella")!).cgColor
        timeCircle.lineWidth = 5.0
        timeCircle.strokeColor = UIColor.clear.cgColor
        timeCircle.strokeEnd = inverted ? 1 : 0
        layer.addSublayer(timeCircle)
        
        // Position circle
        positionCircle.layer.cornerRadius = CGFloat(positionCircleRadius)+5
        positionCircle.backgroundColor = UIColor.red
        addSubview(positionCircle)
        
        // Label
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.font = UIFont(name: "Futura-Medium", size: 40.0)
        label.text = duration.formattedString
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        addSubview(label)
    }
    
    public override func tintColorDidChange() {
        timeCircle.strokeColor = tintColor.cgColor
        backgroundCircle.strokeColor = tintColor.withAlphaComponent(0.3).cgColor
        positionCircle.backgroundColor = tintColor
        label.textColor = tintColor
    }
    
    @objc
    private func updateView() {
        elapsedTime = elapsedTime + Date().timeIntervalSince(lastTick)
        remainingTime = 1 + duration - elapsedTime
        if remainingTime < 1 {
            remainingTime = 0
            invalidate()
            counting = false
            delegate?.timerHasFinished?(self)
        }
        
        lastTick = Date()
        
        // Update label
        label.text = remainingTime.formattedString
        
        // Update progress circles
        var totalCompleted = elapsedTime/duration
        if inverted {
            totalCompleted = 1 - totalCompleted
        }
        progress = totalCompleted
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        timeCircle.strokeEnd = CGFloat(totalCompleted)
        CATransaction.commit()
        
        // Update position circle
        let completedDegrees = startAngle + CGFloat(2*M_PI*totalCompleted)
        positionCircle.center = CGPoint(x: circleOrigin.x + circleRadius*cos(completedDegrees),
                                        y: circleOrigin.y + circleRadius*sin(completedDegrees))
        
        delegate?.timerTick?(self)
    }
    
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        lastTick = Date()
        counting = true
        delegate?.timerHasStarted?(self)
    }
    
    public func pause() {
        invalidate()
        counting = false
        delegate?.timerHasPaused?(self)
    }
    
    public func reset() {
        invalidate()
        elapsedTime = 0
        remainingTime = duration
        counting = false
        label.text = duration.formattedString
        
        timeCircle.strokeEnd = inverted ? 1 : 0
        
        if let radius = circleRadius, let origin = circleOrigin {
            positionCircle.center = CGPoint(x: origin.x + radius*cos(startAngle),
                                            y: origin.y + radius*sin(startAngle))
        }
        
        delegate?.timerHasBeenReset?(self)
    }
    
    public func invalidate() {
        timer?.invalidate()
    }
}

@objc
public protocol TGCircularTimerViewDelegate: class {
    @objc optional func timerHasFinished(_ timer: TGCircularTimerView)
    @objc optional func timerHasPaused(_ timer: TGCircularTimerView)
    @objc optional func timerHasStarted(_ timer: TGCircularTimerView)
    @objc optional func timerHasBeenReset(_ timer: TGCircularTimerView)
    @objc optional func timerTick(_ timer: TGCircularTimerView)
}

public extension TimeInterval {
    var seconds: Int {
        return Int(self) % 60
    }
    
    var minutes: Int {
        return Int(self / 60) % 60
    }
    
    var hours: Int {
        return Int(self / 3600)
    }
    
    var formattedString: String {
        return String(format: "%.2d:%.2d:%.2d", hours, minutes, seconds)
    }
}
