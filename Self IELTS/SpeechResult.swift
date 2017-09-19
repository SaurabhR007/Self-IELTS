//
//  SpeechResult.swift
//  Self IELTS
//
//  Created by Apple on 19/09/17.
//  Copyright © 2017 saurabhrode@gmail.com. All rights reserved.
//

import Foundation

class SpeechResult {
   
    var id:String? = nil
    var  bad:String? = nil
    var better:String? = nil
    
    init(id:String!,bad:String!,better:String!) {
        
        if let speechid = id {
           
            self.id = speechid
        }
        if let speechbad = bad {
            
            self.bad = speechbad
        }
        if let speechbetter = better {
            
            self.better = speechbetter
        }
    }
}



