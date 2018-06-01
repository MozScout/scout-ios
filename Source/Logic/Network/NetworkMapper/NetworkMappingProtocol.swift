//
//  NetworkMappingProtocol.swift
//  Scout
//
//

import Foundation
import SwiftyJSON

protocol NetworkMappingProtocol {
    func scoutTitles(fromResource resource: JSON) -> [ScoutArticle]?
    func scoutAudioFileURL(fromResource resource: JSON) -> ScoutArticle
    func scoutSkimAudioFileURL(fromResource resource: JSON) -> ScoutArticle
}
