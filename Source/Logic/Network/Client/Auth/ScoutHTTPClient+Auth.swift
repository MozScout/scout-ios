//
//  ScoutHTTPClient+Auth.swift
//  Scout
//
//  Created by Victor Liubchenko on 5/12/18.
//

import Foundation

extension ScoutHTTPClient: AuthHTTPClientProtocol {
    
    @discardableResult
    func createUser(withUserName userName: String,
                                    email: String,
                                 password: String,
                             successBlock: @escaping CreateNewUserSuccessBlock,
                             failureBlock: @escaping CreateNewUserFailureBlock) -> HTTPClientConnectionResult {
        
        let request = self.requestBuilder.buildPostRegistrationRequest(withUserName: userName, email: email, password: password)
        
        return self.execute(request: request,
                       successBlock: { (JSONObject, customObject, response) in
            
                       },
                       failureBlock:  { (JSONObject, clientError, response) in
            
                       })
    }
}
