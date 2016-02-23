//
//  DNService.swift
//  DNApp
//
//  Created by Cristian Lucania on 22/02/16.
//  Copyright © 2016 Cristian Lucania. All rights reserved.
//

import Alamofire

struct DNService {
    // DOC: https://github.com/metalabdesign/dn_api_v2
    
    private static let baseURL = "https://www.designernews.co"
    private static let clientID = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"
    private static let clientSecret = "53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"
    
    private enum ResourcePath: CustomStringConvertible {
        case Login
        case Stories
        case StoryId(storyId: Int)
        case StoryUpvote(storyId: Int)
        case StoryReply(storyId: Int)
        case CommentUpvote(commentId: Int)
        case CommentReply(commentId: Int)
        
        var description: String {
            switch self {
            case .Login: return "/oauth/token"
            case .Stories: return "/api/v2/stories"
            case .StoryId(let id): return "/api/v2/stories/\(id)"
            case .StoryUpvote(let id): return "/api/v2/stories/\(id)/upvote"
            case .StoryReply(let id): return "/api/v2/stories/\(id)/reply"
            case .CommentUpvote(let id): return "/api/v2/comments/\(id)/upvote"
            case .CommentReply(let id): return "/api/v2/comments/\(id)/reply"
            }
        }
    }
    
    static func storiesForSection(section: String, page: Int, response: (JSON)->()) {
        let urlString = baseURL + ResourcePath.Stories.description + "/" + section
        let parameters = [
        "page": String(page),
        "client_id": clientID
        ]
        Alamofire.request(.GET, urlString, parameters: parameters).responseJSON { resp in
            let stories = JSON(data: resp.data!)
            response(stories)
        }
    }
}
























