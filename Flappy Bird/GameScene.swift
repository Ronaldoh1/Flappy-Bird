//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Ronald Hernandez on 3/8/15.
//  Copyright (c) 2015 Ronald Hernandez. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{

    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var movingObjects = SKNode()

    let birdGroup:UInt32 = 1
     let objectGroup:UInt32 = 2
    let gapGroup:UInt32 = 0 << 3
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var labelHolder = SKSpriteNode()
    var gameOver = 0

    override func didMoveToView(view: SKView) {


        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        self.addChild(movingObjects)

        self.addChild(labelHolder)

        self.makeBackground()

        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 250)
        self.addChild(scoreLabel)

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

        bird.physicsBody?.categoryBitMask = birdGroup

        bird.physicsBody?.collisionBitMask = objectGroup
        bird.physicsBody?.contactTestBitMask = objectGroup
        bird.physicsBody?.collisionBitMask = gapGroup

        self.addChild(bird)




        var ground = SKNode()
        ground.position  = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = objectGroup
        self.addChild(ground)




        bird.zPosition = 10


        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        //gap 





    }
    func makeBackground(){
        var bgTexture = SKTexture(imageNamed: "bg.png")

        var movebg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9.0)
        var replacebg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var movebgForEver = SKAction.repeatActionForever(SKAction.sequence([movebg, replacebg]))

        for var i:CGFloat=0; i<3; i++ {

            bg = SKSpriteNode(texture: bgTexture)

            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height



            
            
            
            bg.runAction(movebgForEver)
            
            movingObjects.addChild(bg)
            
        }

    }
    func didBeginContact(contact: SKPhysicsContact) {


        if contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup {

                print("contact")
            score++
            scoreLabel.text = "\(score)"


        }else {

            if gameOver == 0 {

        gameOver = 1
        movingObjects.speed = 0

            gameOverLabel.fontName = "Helvetica"
            gameOverLabel.fontSize = 30
            gameOverLabel.text = "Game Over Tap To Play Again!!"
            gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            labelHolder.addChild(gameOverLabel)
            }

        }
    }

    func makePipes(){


        if (gameOver == 0){
        let gapHeight = bird.size.height * 4

        //movement

        var movementAmount = arc4random() % UInt32(self.frame.size.height/2)

        var pipeOffset = CGFloat(movementAmount) - self.frame.height / 4


        var movePipes = SKAction.moveByX(-self.frame.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
        //remove pipes

        var removePipes = SKAction.removeFromParent()
        var moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])



        var pipe1Texture = SKTexture(imageNamed: "pipe1.png")
        var pipe1 = SKSpriteNode(texture: pipe1Texture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.width, y: CGRectGetMidY(self.frame) + pipe1.size.height/2 + gapHeight/2 + pipeOffset)
        //bg.size.height = self.frame.height
        pipe1.physicsBody?.categoryBitMask = objectGroup
        pipe1.runAction(moveAndRemovePipes)
        //pipe1.position  = CGPointMake(0, 0)



        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
        pipe1.physicsBody?.dynamic = false

        movingObjects.addChild(pipe1)

        var pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        var pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.width, y: CGRectGetMidY(self.frame) - pipe2.size.height/2 - gapHeight/2 + pipeOffset)
        pipe2.physicsBody?.categoryBitMask = objectGroup
        //bg.size.height = self.frame.height
        //pipe2.position  = CGPointMake(0, 0)


        pipe2.runAction(moveAndRemovePipes)

        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false

        movingObjects.addChild(pipe2)

        var gap = SKNode()
            gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.width, y: CGRectGetMidY(self.frame) + pipeOffset)
            gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, gapHeight))
            gap.runAction(moveAndRemovePipes)
            gap.physicsBody?.categoryBitMask = gapGroup
            gap.physicsBody?.dynamic = false
            gap.physicsBody?.collisionBitMask = gapGroup
            gap.physicsBody?.contactTestBitMask = birdGroup
            movingObjects.addChild(gap)


        }
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */

        if (gameOver == 0){

        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        } else {

            score = 0
            scoreLabel.text = "0"

            movingObjects.removeAllChildren()
            self.makeBackground()
             bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            labelHolder.removeAllChildren()
            gameOver = 0
            movingObjects.speed = 1
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
