//
//  GameScene.swift
//  Asteroids
//
//  Created by Bruno Souza on 10/07/23.
//

import SpriteKit

class GameScene: SKScene {
  // MARK: - PROPERTIES
  private var left: SKSpriteNode?
  private var right: SKSpriteNode?
  private var hyper: SKSpriteNode?
  private var thrust: SKSpriteNode?
  private var fire: SKSpriteNode?
  
  // Player Properties
  let player = SKSpriteNode(imageNamed: "ship-still")
  var isPlayerAlive = false
  var isRotatingLeft = false
  var isRotatingRight = false
  
  // Control Properties
  var rotation: CGFloat = 0 {
    didSet {
      player.zRotation = deg2rad(degrees: rotation)
    }
  }
  let rotationFactor: CGFloat = 4 // larger number will cause faster rotation
  var xVector: CGFloat = 0
  var yVector: CGFloat = 0
  var rotationVector: CGVector = .zero
  
  // MARK: - METHODS
  // método para realizar as configurações e inicializações iniciais da cena do jogo
  override func didMove(to view: SKView) {
    setupLabelsAndButtons()
    createPlayer(atX: frame.width / 2, atY: frame.height / 2)
  }
  
  override func update(_ currentTime: TimeInterval) {
    if isRotatingLeft {
      rotation += rotationFactor
      if rotation == 360 { rotation = 0 }
    } else if isRotatingRight {
      rotation -= rotationFactor
      if rotation < 0 { rotation = 360 - rotationFactor }
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes (at: location)
    guard let tapped = tappedNodes.first else { return }
    
    switch tapped.name {
      case "left":
        isRotatingLeft = true
        isRotatingRight = false
      case "right":
        isRotatingLeft = false
        isRotatingRight = true
      default:
        return
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let tappedNodes = nodes (at: location)
    guard let tapped = tappedNodes.first else { return }
    
    switch tapped.name {
      case "left":
        isRotatingLeft = false
        isRotatingRight = false
      case "right":
        isRotatingLeft = false
        isRotatingRight = false
      default:
        return
    }
  }
  
  // MARK: - NODE METHODS
  func setupLabelsAndButtons() {
    left = childNode(withName: "left") as? SKSpriteNode
    right = childNode(withName: "right") as? SKSpriteNode
    hyper = childNode(withName: "hyper") as? SKSpriteNode
    thrust = childNode(withName: "thrust") as? SKSpriteNode
    fire = childNode(withName: "fire") as? SKSpriteNode
  }
  
  func createPlayer(atX: Double, atY: Double) {
    guard childNode(withName: "player") == nil else { return }
    player.position = CGPoint(x: atX, y: atY)
    player.zPosition = 0
    player.size = CGSize(width: 120, height: 120)
    player.name = "plaver"
    player.texture = SKTexture(imageNamed: "ship-still")
    addChild(player)
    
    player.physicsBody = SKPhysicsBody (texture: player.texture ?? SKTexture(imageNamed: "ship-still"), size: player.size)
    player.physicsBody?.affectedByGravity = false
    player.physicsBody?.isDynamic = true
    player.physicsBody?.mass = 0.2
    player.physicsBody?.allowsRotation = false
    
    isPlayerAlive = true
  }
}
