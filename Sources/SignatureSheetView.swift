//
//  SignatureSheetView.swift
//  Signature
//
//  Created by ZhangLe on 2021/1/10.
//

import UIKit

class SignatureSheetView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        let lengths: [CGFloat] = [5, 5]
        ctx?.setStrokeColor(UIColor.init(red: 187/255.0, green: 37/255.0, blue: 62/255.0, alpha: 1).cgColor)
        ctx?.beginPath()
        
        let vertical_line_count = 12
        let vertical_bold_line = 4
        let vertical_spacing: CGFloat = rect.size.height / CGFloat(vertical_line_count)
        for i in 0...vertical_line_count {
            if i % vertical_bold_line == 0 {
                continue
            } else {
                ctx?.setLineDash(phase: 0, lengths: lengths)
            }
            ctx?.move(to: CGPoint(x: 0, y: CGFloat(i) * vertical_spacing))
            ctx?.addLine(to: CGPoint(x: rect.width, y: CGFloat(i) * vertical_spacing))
        }
        ctx?.strokePath()
        
        for i in 0...vertical_line_count {
            if i % vertical_bold_line == 0 {
                ctx?.setLineDash(phase: 0, lengths: [10, 0])
            } else {
                continue
            }
            ctx?.move(to: CGPoint(x: 0, y: CGFloat(i) * vertical_spacing))
            ctx?.addLine(to: CGPoint(x: rect.width, y: CGFloat(i) * vertical_spacing))
        }
        ctx?.strokePath()
        
        let horizontal_line_count = 20
        let horizontal_bold_line = 5
        let horizontal_spacing: CGFloat = rect.size.width / CGFloat(horizontal_line_count)
        for i in 0...horizontal_line_count {
            if i % horizontal_bold_line == 0 {
                continue
            } else {
                ctx?.setLineDash(phase: 0, lengths: lengths)
            }
            ctx?.move(to: CGPoint(x: CGFloat(i) * horizontal_spacing, y: 0))
            ctx?.addLine(to: CGPoint(x: CGFloat(i) * horizontal_spacing, y: rect.height))
        }
        ctx?.strokePath()
        
        for i in 0...horizontal_line_count {
            if i % horizontal_bold_line == 0 {
                ctx?.setLineDash(phase: 0, lengths: [10, 0])
            } else {
                continue
            }
            ctx?.move(to: CGPoint(x: CGFloat(i) * horizontal_spacing, y: 0))
            ctx?.addLine(to: CGPoint(x: CGFloat(i) * horizontal_spacing, y: rect.height))
        }
        ctx?.strokePath()
        
        ctx?.closePath()
    }

}
