import SpriteKit

protocol PigeonSceneDelegate{
    func level(_ level: Int, completed: Bool)
}

class GameScene: SKScene, PigeonDelegate {
    
    var pigeonSceneDelegate: PigeonSceneDelegate?
    
    var seedInterval = 1.0
    var levelDuration = 10
    var level = 1
    
    private var pigeonCount = 0
    private var score = 0
    private var hits = 0
    private var seedTimer = Timer()
    private var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    private var levelLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    
    override func didMove(to view: SKView) {
 
        backgroundColor = UIColor.black
        
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        let scaleFactor = background.size.width / frame.size.width
        background.size.width = frame.size.width
        background.size.height = background.size.height / scaleFactor
        background.zPosition = -10
        addChild(background)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 12
        scoreLabel.position = CGPoint(x: 10, y: 10)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        levelLabel.text = "Level: \(level)"
        levelLabel.fontSize = 12
        levelLabel.position = CGPoint(x: frame.width-10, y: 10)
        levelLabel.horizontalAlignmentMode = .right
        addChild(levelLabel)
    
        seedInterval = 1.0 - Double(level)/100.0
        
        startGame()
    }
    
    @objc private func seedPigeon(){
        pigeonCount += 1
        
        //randomly descide to fly the other way (1 in 2)
        let flyRightToLeft = Bool.random() //for <Swift 4.2 use (1 == arc4random_uniform(2))
        
        let sprite = Pigeon()
        
        //define possible starting positions
        let leftStartPosition = -sprite.frame.size.width
        let rightStartPosition = frame.size.width + (0.5 * sprite.frame.size.width)
        
        //set the starting position (either offset all the way to the right, or the sprite's width offset to thelft)
        //this line of code is essentially a compact form of an 'if' statement known as a ternary operator
        let xPosition = flyRightToLeft ? rightStartPosition : leftStartPosition
        
        //if flying the pother way, we can get a -1 value to modify the flying direction
        let directionModifier = flyRightToLeft ? -1.0 : +1.0
        
        //get a position between 100 pixels high and 400 to start the pigeon
        var yPosition = CGFloat(arc4random_uniform(300) + 200)
        
        //offset for tall screens
        yPosition += frame.maxX - 480.0
        
        //set the position
        sprite.position = CGPoint(x: xPosition, y: yPosition)
        
        //get a random duration for animation
        let randomduration = Float((arc4random_uniform(100) + 1)/100)
        
        //make faster as game progresses (shorter duration)
        let durationIncrement = abs((100.0 - Float(pigeonCount)) / 100.0)
        
        //combine durations
        var duration = randomduration + durationIncrement + 0.5
        
        /******Add duration for test *********/
        duration += 1
        
        //determine flight movement on X axis
        var flightMotion : CGFloat =  frame.size.width + (2.0 * sprite.size.width)
        
        //modify direction
        flightMotion *= CGFloat(directionModifier)
        
        //create a flying animation
        let fly = SKAction.moveBy(x: flightMotion, y: CGFloat(0.0), duration: TimeInterval(duration))
        
        //run animation
        sprite.run(fly)
        
        //place it on screen
        addChild(sprite)
        
        //ensure the pigeon delegates to the game when killed
        sprite.delegate = self

    }
    
    private func startGame(){
        
        //reset counters
        hits = 0
        score = 0
        pigeonCount = 0
        
        levelLabel.text = "Level: \(level)"
        
        //introduce the level
        let introLabel = SKLabelNode(fontNamed: "Chalkduster")
        introLabel.text = "Level \(level)"
        introLabel.fontSize = 40
        introLabel.position = CGPoint(x: frame.width/2, y: frame.height/2)
        introLabel.horizontalAlignmentMode = .center
        introLabel.color = SKColor(white: 0, alpha: 1)
        addChild(introLabel)
        
        //create series of animations
        let wait = SKAction.wait(forDuration: 0.5)
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
        //this animation will set off the timers
        let start = SKAction.run({
            self.seedTimer = Timer.scheduledTimer(timeInterval: self.seedInterval, target: self, selector: #selector(GameScene.seedPigeon), userInfo: nil, repeats: true)
            Timer.scheduledTimer(timeInterval: TimeInterval(self.levelDuration), target: self, selector: #selector(GameScene.stopSeeding) , userInfo: nil, repeats: false)
            })
        
        //run the animations in order
        introLabel.run(SKAction.sequence([wait,fadeOut,start]))
    }
    
    @objc private func stopSeeding(){
        seedTimer.invalidate()
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(GameScene.gameOver), userInfo: nil, repeats: false)
    }
    
    @objc private func gameOver(){
        
        if hits == pigeonCount{
            level += 1
            startGame()
            pigeonSceneDelegate?.level(level, completed: true)
        }
        else{
            pigeonSceneDelegate?.level(level, completed: false)
        }
    }
    
    internal func pigeonKilled() {
        score += 10
        hits += 1
        scoreLabel.text = "Score: \(score)"
    }
}
