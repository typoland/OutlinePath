//
//  ContentView.swift
//  Shared
//
//  Created by Łukasz Dziedzic on 26/06/2021.
//

import SwiftUI
import BezierKit

extension PathComponent {
    var cgPath: CGPath {
        var lastPoint: CGPoint? = nil
        let p = CGMutablePath()
        for curve in curves {
            if lastPoint == nil {
                lastPoint = curve.startingPoint
                p.move(to: lastPoint!)
            }
            switch curve {
            case is LineSegment:
                p.addLine(to: curve.endingPoint)
                
            case is CubicCurve:
                let curve = curve as! CubicCurve
                p.addCurve(to: curve.endingPoint,
                              control1: curve.p1,
                              control2: curve.p2)
            default:
                print (curve)
            }
        }
        return p
    }
}

struct ContentView: View {
    
    @State var firstPoint = CGPoint(x:100, y:100)
    @State var secondPoint = CGPoint(x:100, y:100)
    @State var control1 = CGPoint(x:100 , y:100)
    @State var control2 = CGPoint(x:100, y:100)
    
    func bezier(p1:CGPoint, p2: CGPoint, c1: CGPoint, c2: CGPoint) -> SwiftUI.Path {
        let p = CGMutablePath()
        p.move(to: p1)
        p.addCurve(to: p2, control1: c1, control2: c2)
        return Path(p)
    }
    
    func bezierShape(p1:CGPoint, p2: CGPoint, c1: CGPoint, c2: CGPoint) -> SwiftUI.Path {
        let p = CubicCurve(p0: p1, p1: control1, p2: control2, p3: p2)
            .outline(distance: 5)
            .cgPath
        return Path(p)
    }
    
    
    
    var body: some View {
        ZStack {
            
            bezierShape(p1: firstPoint, p2: secondPoint, c1: control1, c2: control2).fill(Color.blue).opacity(0.2)
            
            Rectangle()
                .frame(width: 10, height: 10, alignment: .center)
                .position(firstPoint)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({drag in
                    firstPoint = drag.location
                }))
            Rectangle()
                .frame(width: 10, height: 10, alignment: .center)
                .position(secondPoint)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({drag in
                    secondPoint = drag.location
                }))
            Circle()
                .frame(width: 10, height: 10, alignment: .center)
                .position(control1)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({drag in
                    control1 = drag.location
                }))
            Circle()
                .frame(width: 10, height: 10, alignment: .center)
                .position(control2)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({drag in
                    control2 = drag.location
                }))
            
            
//
//
//            bezierShape(p1: firstPoint, p2: secondPoint, c1: control1, c2: control2).stroke(Color.blue, style: StrokeStyle(lineWidth: 0.5))
            
        bezier(p1: firstPoint, p2: secondPoint, c1: control1, c2: control2).stroke(lineWidth: 0.5)
            .contentShape( bezierShape(p1: firstPoint, p2: secondPoint, c1: control1, c2: control2))
            .onTapGesture {
                print ("HU")
                
            }
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
