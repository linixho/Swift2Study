//
//  GameScene.swift
//  Project11
//
//  Created by Linix on 2017/2/28.
//  Copyright © 2017年 Linix. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody!.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody!.isDynamic = false     // isDynamic 设置物体是否可被移动
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 10) // 10秒内旋转180度
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 490, y: 350)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: -432, y: 350)
        addChild(editLabel)
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 0, y: 0)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        makeSlot(at: CGPoint(x: 128, y: -384), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: -384), isGood: false)
        makeSlot(at: CGPoint(x: -384, y: -384), isGood: true)
        makeSlot(at: CGPoint(x: -128, y: -384), isGood: false)

        makeBouncer(at: CGPoint(x: 0, y: -384))
        makeBouncer(at: CGPoint(x: 256, y: -384))
        makeBouncer(at: CGPoint(x: 512, y: -384))
        makeBouncer(at: CGPoint(x: -256, y: -384))
        makeBouncer(at: CGPoint(x: -512, y: -384))
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 10
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 10
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
           // fireParticles.removeFromParent()
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ball" {
            collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "ball" {
            collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            
            let object = nodes(at: location)
            
            if object.contains(editLabel) {
                editingMode = !editingMode
            } else {
                if editingMode {
                    // create a box
                    
                    let size = CGSize(width: GKRandomDistribution(lowestValue: 32, highestValue: 128).nextInt(), height: 16)
                    let box = SKSpriteNode(color: RandomColor(), size: size)
                    box.zRotation = RandomCGFloat(min: 0, max: 3)
                    box.position = location
                    
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody!.isDynamic = false
                    
                    addChild(box)
                } else {
                    if location.y > 50 {
                        var ballColor = [String]()
                        ballColor = ["Blue", "Cyan", "Green", "Grey", "Purple", "Red", "Yellow"]
                        ballColor = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: ballColor) as! [String]

                        let ball = SKSpriteNode(imageNamed: "ball\(ballColor[0])")
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                        
                        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask // This line detects collision
                        
                        ball.physicsBody!.restitution = 0.4 // 回弹系数
                        ball.position = location
                        ball.name = "ball"
                        addChild(ball)
                    }
                }
            }
            
        }
    }
}
