//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Ronald Hernandez on 3/8/15.
//  Copyright (c) 2015 Ronald Hernandez. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var bird = SKSpriteNode()
    var bg = SKSpriteNode()

    override func didMoveToView(view: SKView) {

        var bgTexture = SKTexture(imageNamed: "bg.png")

      var movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9.0)
          var replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
          var movebgForEver = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))

        for var i:CGFloat=0; i<3; i++ {

        bg = SKSpriteNode(texture: bgTexture)

        bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
        bg.size.height = self.frame.height






        bg.runAction(movebgForEver)

        self.addChild(bg)

        }


        var birdTexture = SKTexture(imageNamed:  "flappy1.png")
         var birdTexture2 = SKTexture(imageNamed:  "flappy2.png")

      var animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        var makeBirdFlap = SKAction.repeatActionForever(animation)

        bird = SKSpriteNode(texture: birdTexture)

        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)

        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false

        self.addChild(bird)




        var ground = SKNode()
        ground.position  = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        self.addChild(ground)


        //gap 

        let gapHeight = bird.size.height * 4

        //movement 

        var movementAmount = arc4random() % UInt32(self.frame.size.height/2)

        var pipeOffset = CGFloat(movementAmount) - self.frame.height / 4

        var pipe1Texture = SKTexture(imageNamed: "pipe1.png")
        var pipe1 = SKSpriteNode(texture: pipe1Texture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + pipe1.size.height/2 + gapHeight/2 + pipeOffset)
        //bg.size.height = self.frame.height

        self.addChild(pipe1)

        var pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        var pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - pipe2.size.height/2 - gapHeight/2 + pipeOffset)
        //bg.size.height = self.frame.height

        self.addChild(pipe2)



    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */

        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))


    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
