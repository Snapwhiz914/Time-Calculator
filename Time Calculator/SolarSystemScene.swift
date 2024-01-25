//
//  SolarSystemScene.swift
//  Time Calculator
//
//  Created by Liam Loughead on 1/8/24.
//

import SpriteKit

class SolarSystemScene: SKScene {
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {
            // ignore
        }
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    //Scale constants
    let maxScale = 25.0
    let minScale = 0.5
    let startScale = 5.0
    
    var daysSinceVernalEq = 0.0
    
    let cameraNode = SKCameraNode()
    var initalCam = CGPoint()
    var initalCamScaleX = CGFloat()
    var initalCamScaleY = CGFloat()
    var currentPlanetNodes: [SKNode] = []
    var currentLabelNodes: [SKLabelNode] = []
    let horizons: Horizons =  Horizons()
    
    override func didMove(to view: SKView) {
        print("Drawing...")
        createSun()
        createPlanets()
        drawPlanets(date: Date.now)
        scene?.anchorPoint = CGPoint(x: 0, y: 0)
        scene?.backgroundColor = .black
        
        print("Camera setup")
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        scene?.addChild(cameraNode)
        scene?.camera = cameraNode
        camera?.xScale = startScale
        camera?.yScale = startScale
        
        print("Callbacks")
        scene?.view?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinch)))
        scene?.view?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
        print("DM done")
    }
    
    func createSun() {
        let sun = SKSpriteNode(imageNamed: "the Sun")
        sun.position = CGPoint(x: size.width / 2, y: size.height / 2)
        sun.setScale(PlanetData.planets[0].drawScale) // Adjust the scale as needed
        sun.zPosition+=2;
        addChild(sun)
    }
    
    private func drawPlanet(planetData: Planet, planetNode: SKNode, label: SKLabelNode, date: Date) {
        horizons.getXYInAU(startDate: date, endDate: Calendar.current.date(byAdding: .day, value: 1, to: date)!, planet: planetData) { position in
            print(planetData.name)
            print("     " + String(format: "%f", position[0][0]) + ", " + String(format: "%f", position[0][1]))
            let x = position[0][0] * planetData.drawDistance + planetData.drawScale
            let y = position[0][1] * planetData.drawDistance + planetData.drawScale
            print("     " + String(format: "%f", x) + ", " + String(format: "%f", y))
            
            planetNode.position = CGPoint(x: self.size.width / 2 + x, y: self.size.height / 2 + y)
            label.position = CGPoint(x: self.size.width / 2 + x + (planetNode.frame.width/2) + (label.frame.width/2), y: self.size.height / 2 + y)
        }
    }
    
    func createSpaceObj(data: Planet, node: SKNode, label: SKLabelNode) {
        let angle = (Double.random(in: 0.0..<1.0))*(2*CGFloat.pi)
        let x = cos(angle) * Constants.SpaceObjDistance + CGFloat(data.drawScale)
        let y = sin(angle) * Constants.SpaceObjDistance + CGFloat(data.drawScale)
        node.position = CGPoint(x: size.width / 2 + x, y: size.height / 2 + y)
        label.position = CGPoint(x: size.width / 2 + x + (node.frame.width/2), y: size.height / 2 + y)
        label.fontSize *= data.drawScale
    }
    
    func createPlanets() {
        for planetData in PlanetData.planets {
            if planetData.name == "the Sun" {continue}
            let imageName = planetData.name
            let planetSize = CGFloat(planetData.drawScale)
            let planetNode = SKSpriteNode(imageNamed: imageName)
            planetNode.setScale(planetSize)
            
            let label = SKLabelNode(fontNamed: "AlNile-Bold")
            label.text = imageName
            label.fontSize = 20
            label.fontColor = SKColor.white
            label.zPosition+=1;
            label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            
            if planetData.inSS {
                //drawPlanet(planetData: planetData, planetNode: planetNode, label: label, date: Date.now)
                
//                let circlePath = CGMutablePath()
//                circlePath.addArc(center: CGPoint(x: size.width / 2, y: size.height / 2), radius: planetData.drawDistance, startAngle: 0, endAngle: 0.001, clockwise: true)
//                let circleNode = SKShapeNode(path: circlePath)
//                circleNode.lineWidth = 2
//                circleNode.strokeColor = .white
//                circleNode.zPosition-=1
//                circleNode.lineJoin = .miter
//
//                addChild(circleNode)
            } else {
                createSpaceObj(data: planetData, node: planetNode, label: label)
            }
            
            addChild(planetNode)
            addChild(label)
            currentPlanetNodes.append(planetNode)
            currentLabelNodes.append(label)
        }
    }
    
    func drawPlanetsRecursiveHelper(date: Date, i: Int) {
        if i > PlanetData.planets.count-1 {return}
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            if PlanetData.planets[i].inSS {
                self.drawPlanet(planetData: PlanetData.planets[i], planetNode: self.currentPlanetNodes[i], label: self.currentLabelNodes[i], date: date)
            }
            self.drawPlanetsRecursiveHelper(date: date, i: i + 1)
        })
    }
    
    func drawPlanets(date: Date) {
        drawPlanetsRecursiveHelper(date: date, i: 1)
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let newX = cameraNode.xScale/sender.scale
            let newY = cameraNode.yScale/sender.scale
            if (newX < minScale || newY < minScale) {
                return
            }
            if (newX > maxScale || newY > maxScale) {
                return
            }
            
//            var i = 0
//            for label in currentLabelNodes {
//                label.fontSize = label.fontSize/sender.scale
//                label.position = CGPoint(x: size.width / 2 + currentPlanetNodes[i].frame.midX + (currentPlanetNodes[i].frame.width/2) + (label.frame.width/2), y: size.height / 2 + currentPlanetNodes[i].frame.midY)
//                i+=1
//            }
            
            cameraNode.xScale = newX
            cameraNode.yScale = newY
            sender.scale = 1.0
        }
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = sender.translation(in: self.view)
        if sender.state == .began {
            // Save the view's original position.
            initalCam = cameraNode.position
        }
        if sender.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: initalCam.x - (translation.x*cameraNode.xScale), y: initalCam.y + (translation.y*cameraNode.yScale))
            cameraNode.position = newCenter
        }
        else {
            // On cancellation, return the piece to its original location.
            cameraNode.position = initalCam
        }
    }
 }
