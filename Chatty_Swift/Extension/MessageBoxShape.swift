//
//  MessageBoxShape.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/21.
//

import SwiftUI

struct MessageBoxShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.11111*width, y: 0))
        path.addCurve(to: CGPoint(x: 0, y: 0.17021*height), control1: CGPoint(x: 0.04975*width, y: 0), control2: CGPoint(x: 0, y: 0.07621*height))
        path.addLine(to: CGPoint(x: 0, y: 0.68085*height))
        path.addCurve(to: CGPoint(x: 0.11111*width, y: 0.85106*height), control1: CGPoint(x: 0, y: 0.77486*height), control2: CGPoint(x: 0.04975*width, y: 0.85106*height))
        path.addLine(to: CGPoint(x: 0.42089*width, y: 0.85106*height))
        path.addLine(to: CGPoint(x: 0.469*width, y: 0.97872*height))
        path.addCurve(to: CGPoint(x: 0.51711*width, y: 0.97872*height), control1: CGPoint(x: 0.47969*width, y: 1.00709*height), control2: CGPoint(x: 0.50642*width, y: 1.00709*height))
        path.addLine(to: CGPoint(x: 0.56522*width, y: 0.85106*height))
        path.addLine(to: CGPoint(x: 0.88889*width, y: 0.85106*height))
        path.addCurve(to: CGPoint(x: width, y: 0.68085*height), control1: CGPoint(x: 0.95025*width, y: 0.85106*height), control2: CGPoint(x: width, y: 0.77486*height))
        path.addLine(to: CGPoint(x: width, y: 0.17021*height))
        path.addCurve(to: CGPoint(x: 0.88889*width, y: 0), control1: CGPoint(x: width, y: 0.07621*height), control2: CGPoint(x: 0.95025*width, y: 0))
        path.addLine(to: CGPoint(x: 0.11111*width, y: 0))
        path.closeSubpath()
        return path
    }
}
