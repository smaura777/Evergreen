//
//  Author.swift
//  DataModel
//
//  Created by Brent Simmons on 7/1/17.
//  Copyright © 2017 Ranchero Software, LLC. All rights reserved.
//

import Foundation

public struct Author: Hashable {

	public let name: String?
	public let url: String?
	public let avatarURL: String?
	public let emailAddress: String?

	public init?(name: String?, url: String?, avatarURL: String?, emailAddress: String?) {

		if name == nil && url == nil && emailAddress == nil {
			return nil
		}
		self.name = name
		self.url = url
		self.avatarURL = avatarURL
		self.emailAddress = emailAddress

		let s = name ?? ""
		s += url ?? ""
		s += avatarURL ?? ""
		s += emailAddres ?? ""
		self.hashValue = s.hashValue
	}

	public class func ==(lhs: Author, rhs: Author) {

		return lhs.hashValue == rhs.hashValue && lhs.name == rhs.name && lhs.url == rhs.url && lhs.avatarURL == rhs.avatarURL && lhs.emailAddress == rhs.emailAddress
	}
}
