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
    
    override func didMove(to view: SKView) {
        print("Drawing...")
        //createSun()
        createPlanets()
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
        
        drawPlanets(date: Date.now)
        print("DM done")
    }
    
//    func createSun() {
//        let sun = SKSpriteNode(imageNamed: "the Sun")
//        sun.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        sun.setScale(PlanetData.planets[0].drawScale) // Adjust the scale as needed
//        sun.zPosition+=2;
//        addChild(sun)
//    }
    
    private func drawPlanet(planetData: Planet, planetNode: SKNode, label: SKLabelNode, date: Date, orbitalElements: OrbitalElements) {
//        let planetSize = CGFloat(planetData.drawScale)
//        let ratio = (daysSinceVernalEq/365)
//        let angle = (ratio/planetData.orbitalPeriodYears)*(2*CGFloat.pi)
//        let adjustedAngle = (angle
//                             + (planetData.name != "Earth" ? 1.57-(ratio*(2*CGFloat.pi)) : 0)
//                             - planetData.ascendingNodeOffset
//                             + deg2rad(daysSinceAstroEpoch*planetData.aNOMultiplier))
        var computedPosition = Astronomy.planetPosition(date: date, planet: orbitalElements)
        var x = cos(computedPosition.0) * planetData.drawDistance + planetData.drawScale
        var y = sin(computedPosition.1) * planetData.drawDistance + planetData.drawScale
        switch planetData.name {
        case "Mercury", "Venus", "Earth", "Saturn":
            x *= -1
        case "Jupiter":
            x *= -1
            y *= -1
        case "Neptune", "Uranus":
            y *= -1
        default:
            break
        }
        //invert both, its upside down
        
        planetNode.position = CGPoint(x: size.width / 2 + x, y: size.height / 2 + y)
        label.position = CGPoint(x: size.width / 2 + x + (planetNode.frame.width/2) + (label.frame.width/2), y: size.height / 2 + y)
    }
    
    func createSpaceObj(data: Planet, node: SKNode, label: SKLabelNode) {
        let angle = (Double.random(in: 0.0..<1.0))*(2*CGFloat.pi)
        let x = cos(angle) * Constants.SpaceObjDistance + CGFloat(data.drawScale)
        let y = sin(angle) * Constants.SpaceObjDistance + CGFloat(data.drawScale)
        print(x)
        print(y)
        node.position = CGPoint(x: size.width / 2 + x, y: size.height / 2 + y)
        label.position = CGPoint(x: size.width / 2 + x + (node.frame.width/2), y: size.height / 2 + y)
        label.fontSize *= data.drawScale
    }
    
    func createPlanets() {
        var i = 0
        for planetData in PlanetData.planets {
            let imageName = planetData.name
            let planetSize = CGFloat(planetData.drawScale)
            let planetNode = SKSpriteNode(imageNamed: imageName)
            planetNode.setScale(planetSize)
            if planetData.name == "the Sun" {
                planetNode.zPosition += -1;
            }
            
            let label = SKLabelNode(fontNamed: "AlNile-Bold")
            label.text = imageName
            label.fontSize = 20
            label.fontColor = SKColor.white
            label.zPosition+=1;
            label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            
            if planetData.inSS {
                print(planetData.name)
                print(i)
                drawPlanet(planetData: planetData, planetNode: planetNode, label: label, date: Date.now, orbitalElements: PlanetData.orbitalElementsOfPlanets[i])
                
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
            i+=1
        }
    }
    
    func drawPlanets(date: Date) {
        //TODO: Dont forget to calculate the angle of earth first then use it as an offset bc the line from earth to sun is VE line x axis
        var i = 0
        for planetNode in currentPlanetNodes {
            if !PlanetData.planets[i].inSS {continue}
            drawPlanet(planetData: PlanetData.planets[i], planetNode: planetNode, label: currentLabelNodes[i], date: date, orbitalElements: PlanetData.orbitalElementsOfPlanets[i])
            i+=1;
        }
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
