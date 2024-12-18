//
//  StreamPlayBackViewModel.swift
//  LiveRApp
//
//  Created by Menti on 18/12/24.
//

import Foundation

struct VideosResponseData: Decodable {
    var videos: [Videos]
}
struct Videos : Decodable {
    var id: Int
    var userID: Int
    var username: String
    var profilePicURL: String
    var description: String
    var topic: String
    var viewers: Int
    var likes: Int
    var video: String
    var thumbnail: String
}

struct CommentsResponseData: Decodable {
    var comments: [Comments]
}
struct Comments : Decodable {
    var id: Int
    var username: String
    var picURL: String
    var comment: String
}

class StreamPlayBackViewModel{
    func loadVideos() -> [Videos]? {
        if let url = Bundle.main.url(forResource: "Videos", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(VideosResponseData.self, from: data)
                return jsonData.videos
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    func loadComments() -> [Comments]? {
        if let url = Bundle.main.url(forResource: "Comments", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(CommentsResponseData.self, from: data)
                return jsonData.comments
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}




