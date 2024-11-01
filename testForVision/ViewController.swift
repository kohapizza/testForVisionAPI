//
//  ViewController.swift
//  testForVision
//
//  Created by 佐伯小遥 on 2024/10/22.
//

import UIKit
import OpenAI


class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    @IBAction func tapButton(_ sender: UIButton) {
        Task {
            await analyzeImage()
        }
    }

    func analyzeImage() async {
        guard let image = UIImage(named: "potato") else {
            print("Image not found")
            return
            
        }
        
        imageView.image = image
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to JPEG data")
            return
        }
        
        do {
            let openAI = OpenAI(apiToken: "YOUR_API_KEY")
            
            let chatQuery = ChatQuery(messages: [
                .user(.init(content: .vision([
                    .chatCompletionContentPartTextParam(.init(text: "What's in this image? Answer in only Japanese words.")),
                    .chatCompletionContentPartImageParam(.init(imageUrl: .init(url: imageData, detail: .auto)))
                ])))
            ], model: Model.gpt4_o, maxTokens: 50)
            
            let result = try await openAI.chats(query: chatQuery)
            print("Image analysis result: \(result)")
            
            if let choice = result.choices.first {
                if case let .string(text) = choice.message.content {
                    print("Content : \(text)") // ここで「じゃがいも」が表示される
                    textLabel.text = text
                } else {
                    print("Content is not a string")
                }
            } else {
                print("No choices available")
            }
            
        } catch {
            print("Error during image analysis: \(error)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    

}

