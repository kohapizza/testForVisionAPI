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
    
    let imageUrlString = "https://life.ja-group.jp/upload/food/vegetable/main/11_1.jpg"

    func analyzeImage() async {
        do {
            let openAI = OpenAI(apiToken: "YOUR API KEY")
            
            let chatQuery = ChatQuery(messages: [
                .user(.init(content: .vision([
                    .chatCompletionContentPartTextParam(.init(text: "What's in this image? Answer in only Japanese words.")),
                    .chatCompletionContentPartImageParam(.init(imageUrl: .init(url: imageUrlString, detail: .auto)))
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

