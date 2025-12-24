//
//  LocalTimeStampLogRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import Foundation

protocol LocalTimeStampLogRepositoryProtocol {
    // MARK: create
    func create(_ log: LocalTimeStampLogDto) throws
    
    // MARK: read
    func read(id: UUID) throws -> LocalTimeStampLogDto?
    func readAll() throws -> [LocalTimeStampLogDto]
    func readByCategory(_ category: String) throws -> [LocalTimeStampLogDto]
    
    
    // MARK: update
    func update(_ log: LocalTimeStampLogDto) throws
    
    // MARK: delete
    func delete(id: UUID) throws
    func deleteAll() throws
}
