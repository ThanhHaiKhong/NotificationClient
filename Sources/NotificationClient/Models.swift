//
//  NotificationItem.swift
//  NotificationClient
//
//  Created by Thanh Hai Khong on 10/2/25.
//

import Foundation
import NetworkClient

// MARK: - Category

extension NotificationClient {
	public enum Category: Int, Codable, Sendable {
		case none = 0
		case advertising = 1
		case payment = 2
	}
}

// MARK: - Notification

extension NotificationClient {
	public struct Notification: Identifiable, Sendable, Equatable, Decodable {
		public let id: String
		public let refId: String
		public let category: Int
		public let title: String
		public let body: String
		public let content: String
		public let uid: String
		public let createdAt: Date
		public let updatedAt: Date
		public let readAt: Date?
		public let deletedAt: Date?
		
		public init(
			id: String,
			refId: String,
			category: Int,
			title: String,
			body: String,
			content: String,
			uid: String,
			createdAt: Date,
			updatedAt: Date,
			readAt: Date? = nil,
			deletedAt: Date? = nil
		) {
			self.id = id
			self.refId = refId
			self.category = category
			self.title = title
			self.body = body
			self.content = content
			self.uid = uid
			self.createdAt = createdAt
			self.updatedAt = updatedAt
			self.readAt = readAt
			self.deletedAt = deletedAt
		}
		
		private enum CodingKeys: String, CodingKey {
			case id
			case refId = "ref_id"
			case category
			case title
			case body
			case content
			case uid
			case createdAt = "created_at"
			case updatedAt = "updated_at"
			case readAt = "read_at"
			case deletedAt = "deleted_at"
		}
	}
}

extension NotificationClient.Notification {
	
	public var imageURL: URL? {
		guard let urlString = content.split(separator: " ").first else { return nil }
		return URL(string: String(urlString))
	}
}

// MARK: - NotificationClient

extension NotificationClient {
	public struct RegisterConfiguration: Sendable {
		public let address: String       // fcm token, email, etc.
		public let uid: String           // user id
		public let transport: Transport
		public let namespace: String
		public let bundle: String
		public let os: OSType
		public let token: String         // auth token
		
		public init(
			address: String,
			uid: String,
			transport: Transport,
			namespace: String,
			bundle: String = Bundle.main.bundleIdentifier ?? "",
			os: OSType,
			token: String
		) {
			self.address = address
			self.uid = uid
			self.transport = transport
			self.namespace = namespace
			self.bundle = bundle
			self.os = os
			self.token = token
		}
		
		public enum Transport: Int, Codable, Sendable {
			case none = 0
			case system = 1
			case firebase = 2
			case sendGrid = 4
			case telegram = 8
			case discord = 16
		}
		
		public enum OSType: String, Codable, Sendable {
			case ios = "IOS"
			case android = "ANDROID"
			case web = "WEB"
		}
		
		private struct RegisterBody: Encodable {
			struct Options: Encodable {
				let namespace: String
				let bundle: String
			}
			
			let address: String
			let uid: String
			let transport: String
			let options: Options
			let os: String
		}
	}
}

extension NotificationClient.RegisterConfiguration {
	public var request: NetworkClient.Request {
		get throws {
			let body = RegisterBody(
				address: address,
				uid: uid,
				transport: transport.rawValue.description.uppercased(), // "FIREBASE"
				options: .init(namespace: namespace, bundle: bundle),
				os: os.rawValue
			)
			
			let endpoint = NetworkClient.Request.Endpoint(
				path: "/notify/\(transport.rawValue)/register",
				method: .post
			)
			
			let payload = NetworkClient.Request.Payload(
				headers: [
					"Content-Type": "application/json",
					"Authorization": "Bearer \(token)"
				],
				body: try JSONEncoder().encode(body)
			)
			
			return NetworkClient.Request(endpoint: endpoint, payload: payload, configuration: .default)
		}
	}
	
	public var deregisterRequest: NetworkClient.Request {
		get throws {
			let body = RegisterBody(
				address: address,
				uid: uid,
				transport: transport.rawValue.description.uppercased(),
				options: .init(namespace: namespace, bundle: bundle),
				os: os.rawValue
			)
			
			let endpoint = NetworkClient.Request.Endpoint(
				path: "/notify/\(transport.rawValue)/deregister",
				method: .post
			)
			
			let payload = NetworkClient.Request.Payload(
				headers: [
					"Content-Type": "application/json",
					"Authorization": "Bearer \(token)"
				],
				body: try JSONEncoder().encode(body)
			)
			
			return NetworkClient.Request(endpoint: endpoint, payload: payload, configuration: .default)
		}
	}
}

// MARK: - ListTopics

extension NotificationClient {
	public struct TopicsConfiguration: Sendable {
		public let userId: String
		public let limit: Int
		public let offset: Int
		public let namespace: String
		public let bundle: String
		public let token: String
		
		public init(
			userId: String,
			limit: Int,
			offset: Int,
			namespace: String,
			bundle: String = Bundle.main.bundleIdentifier ?? "",
			token: String
		) {
			self.userId = userId
			self.limit = limit
			self.offset = offset
			self.namespace = namespace
			self.bundle = bundle
			self.token = token
		}
	}
}

extension NotificationClient.TopicsConfiguration {
	public var request: NetworkClient.Request {
		get {
			let endpoint = NetworkClient.Request.Endpoint(
				path: "/notify/topics",
				method: .get,
				query: [
					"userId": userId,
					"limit": String(limit),
					"offset": String(offset),
					"options.namespace": namespace,
					"options.bundle": bundle
				]
			)
			
			let payload = NetworkClient.Request.Payload(
				headers: [
					"Authorization": "Bearer \(token)",
					"Content-Type": "application/json"
				],
				body: nil
			)
			
			return NetworkClient.Request(endpoint: endpoint, payload: payload, configuration: .default)
		}
	}
}

extension NotificationClient {
	public struct TopicsResponse: Decodable {
		public let topics: [Topic]
	}
	
	public struct Topic: Decodable, Identifiable, Sendable {
		public let id: String
		public let name: String
		public let uid: String
	}
}

// MARK: - ReadNotifications

extension NotificationClient {
	public struct ReadConfiguration: Sendable {
		public let ids: [String]
		public let token: String
		
		public init(ids: [String], token: String) {
			self.ids = ids
			self.token = token
		}
	}
}

extension NotificationClient.ReadConfiguration {
	public var request: NetworkClient.Request {
		get throws {
			let endpoint = NetworkClient.Request.Endpoint(
				path: "/notifies/read",
				method: .post
			)
			
			let body = ["ids": ids]
			
			let payload = NetworkClient.Request.Payload(
				headers: [
					"Authorization": "Bearer \(token)",
					"Content-Type": "application/json"
				],
				body: try JSONEncoder().encode(body)
			)
			
			return NetworkClient.Request(endpoint: endpoint, payload: payload, configuration: .default)
		}
	}
}

extension NotificationClient {
	public struct DeleteConfiguration: Sendable {
		public let ids: [String]
		public let isDeleteAll: Bool
		public let token: String
		
		public init(ids: [String], isDeleteAll: Bool = false, token: String) {
			self.ids = ids
			self.isDeleteAll = isDeleteAll
			self.token = token
		}
	}
}

extension NotificationClient.DeleteConfiguration {
	public var request: NetworkClient.Request {
		get throws {
			struct DeleteBody: Encodable {
				let ids: [String]
				let all: String
			}
			
			let endpoint = NetworkClient.Request.Endpoint(
				path: "/notifies/delete",
				method: .post
			)
			
			let body = DeleteBody(
				ids: ids,
				all: isDeleteAll ? "true" : "false"
			)
			
			let payload = NetworkClient.Request.Payload(
				headers: [
					"Authorization": "Bearer \(token)",
					"Content-Type": "application/json"
				],
				body: try JSONEncoder().encode(body)
			)
			
			return NetworkClient.Request(endpoint: endpoint, payload: payload, configuration: .default)
		}
	}
}

extension NotificationClient {
	public struct NotifiesResponse: Decodable {
		public let notifies: [NotificationClient.Notification]
	}
}

// MARK: - List Notifications

extension NotificationClient {
	public struct NotifiesConfiguration: Sendable {
		public let userId: String
		public let limit: Int
		public let offset: Int
		public let namespace: String
		public let bundle: String
		public let token: String
		
		public init(
			userId: String,
			limit: Int,
			offset: Int,
			namespace: String,
			bundle: String = Bundle.main.bundleIdentifier ?? "",
			token: String
		) {
			self.userId = userId
			self.limit = limit
			self.offset = offset
			self.namespace = namespace
			self.bundle = bundle
			self.token = token
		}
	}
}

extension NotificationClient.NotifiesConfiguration {
	public var request: NetworkClient.Request {
		get {
			let endpoint = NetworkClient.Request.Endpoint(
				path: "/users/\(userId)/notifies",
				method: .get,
				query: [
					"userId": userId,
					"limit": String(limit),
					"offset": String(offset),
					"options.namespace": namespace,
					"options.bundle": bundle
				]
			)
			
			let payload = NetworkClient.Request.Payload(
				headers: [
					"Authorization": "Bearer \(token)",
					"Content-Type": "application/json"
				],
				body: nil
			)
			
			return NetworkClient.Request(endpoint: endpoint, payload: payload, configuration: .default)
		}
	}
}

// MARK: - GetNotificationSettings

extension NotificationClient {
	public struct EnabledConfiguration: Sendable {
		public let userId: String
		public let namespace: String
		public let token: String
		
		public init(
			userId: String,
			namespace: String,
			token: String
		) {
			self.userId = userId
			self.namespace = namespace
			self.token = token
		}
	}
}

extension NotificationClient.EnabledConfiguration {
	public var request: NetworkClient.Request {
		get {
			let endpoint = NetworkClient.Request.Endpoint(
				path: "/users/\(userId)/settings/notify",
				method: .get,
				query: [
					"user_id": userId,
					"options.namespace": namespace
				]
			)
			
			let payload = NetworkClient.Request.Payload(
				headers: [
					"Authorization": "Bearer \(token)",
					"Content-Type": "application/json"
				],
				body: nil
			)
			
			return NetworkClient.Request(endpoint: endpoint, payload: payload, configuration: .default)
		}
	}
}

extension NotificationClient {
	public struct EnabledResponse: Decodable, Sendable {
		public let enabled: Bool
	}
}

// MARK: - SetNotificationSettings

extension NotificationClient {
	public struct SetEnabledConfiguration: Sendable {
		public let userId: String
		public let enabled: Bool
		public let namespace: String
		public let token: String
		
		public init(
			userId: String,
			enabled: Bool,
			namespace: String,
			token: String
		) {
			self.userId = userId
			self.enabled = enabled
			self.namespace = namespace
			self.token = token
		}
	}
}

extension NotificationClient.SetEnabledConfiguration {
	public var request: NetworkClient.Request {
		get throws {
			struct SetSettingsBody: Encodable {
				struct Options: Encodable {
					let namespace: String
				}
				let enabled: Bool
				let options: Options
			}
			
			let body = SetSettingsBody(
				enabled: enabled,
				options: .init(namespace: namespace)
			)
			let endpoint = NetworkClient.Request.Endpoint(
				path: "/users/\(userId)/settings/notify",
				method: .put
			)
			let payload = NetworkClient.Request.Payload(
				headers: [
					"Authorization": "Bearer \(token)",
					"Content-Type": "application/json"
				],
				body: try JSONEncoder().encode(body)
			)
			return NetworkClient.Request(endpoint: endpoint, payload: payload, configuration: .default)
		}
	}
}

// MARK: - GetStatuses

extension NotificationClient {
	public struct StatusConfiguration: Sendable {
		public let userId: String
		public let namespace: String
		public let bundle: String
		public let token: String
		
		public init(
			userId: String,
			namespace: String,
			bundle: String = Bundle.main.bundleIdentifier ?? "",
			token: String
		) {
			self.userId = userId
			self.namespace = namespace
			self.bundle = bundle
			self.token = token
		}
	}
}

extension NotificationClient.StatusConfiguration {
	public var request: NetworkClient.Request {
		get {
			let endpoint = NetworkClient.Request.Endpoint(
				path: "/users/\(userId)/statuses/notify",
				method: .get,
				query: [
					"user_id": userId,
					"options.namespace": namespace,
					"options.bundle": bundle
				]
			)
			let payload = NetworkClient.Request.Payload(
				headers: [
					"Authorization": "Bearer \(token)",
					"Content-Type": "application/json"
				],
				body: nil
			)
			return NetworkClient.Request(endpoint: endpoint, payload: payload, configuration: .default)
		}
	}
}

extension NotificationClient {
	public struct StatusResponse: Decodable, Sendable {
		public let unread: Int
	}
}
