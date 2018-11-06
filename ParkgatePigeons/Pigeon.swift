import SpriteKit

protocol PigeonDelegate{
    func pigeonKilled()
}

class Pigeon : SKSpriteNode {
    var delegate : PigeonDelegate?
    
    init(){
        let texture = SKTexture(imageNamed: "pigeon-alive.png")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        name = "pigeon"
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        delegate?.pigeonKilled() //call the pigeonKilled Method, only if the delegate exists
    }
}
