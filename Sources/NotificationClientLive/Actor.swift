//
//  NotificationService.swift
//  NotificationClient
//
//  Created by Thanh Hai Khong on 10/2/25.
//

import Dependencies
import NotificationClient
import NetworkClient
import UIKit

public actor NotificationActor {
	
	private let service = NotificationService()
	
	public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
		try await service.requestAuthorization(options: options)
	}
	
	public func register(_ configuration: NotificationClient.RegisterConfiguration) async throws {
		try await service.register(configuration)
	}
	
	public func deregister(_ configuration: NotificationClient.RegisterConfiguration) async throws {
		try await service.deregister(configuration)
	}
	
	public func deliveredNotifications(_ configuration: NotificationClient.NotifiesConfiguration) async throws -> [NotificationClient.Notification] {
		try await service.deliveredNotifications(configuration)
	}
	
	public func deliveredTopics(_ configuration: NotificationClient.TopicsConfiguration) async throws -> [NotificationClient.Topic] {
		try await service.deliveredTopics(configuration)
	}
	
	public func notificationSettings(_ configuration: NotificationClient.SettingsConfiguration) async throws -> NotificationClient.SettingsResponse {
		try await service.notificationSettings(configuration)
	}
	
	public func setNotificationSettings(_ configuration: NotificationClient.SettingsConfiguration) async throws {
		try await service.setNotificationSettings(configuration)
	}
	
	public func markAsRead(_ configuration: NotificationClient.ReadConfiguration) async throws -> [NotificationClient.Notification] {
		try await service.markAsRead(configuration)
	}
	
	public func removeDeliveredNotifications(_ configuration: NotificationClient.DeleteConfiguration) async throws {
		try await service.removeDeliveredNotifications(configuration)
	}
	
	public func unreadNotifications(_ configuration: NotificationClient.UnreadConfiguration) async throws -> NotificationClient.UnreadResponse {
		try await service.unreadNotifications(configuration)
	}
}

private final class NotificationService: NSObject, @unchecked Sendable {
	
	@Dependency(\.networkClient) private var networkClient

    public override init() {
        super.init()
    }
}

// MARK: - Pulic Methods

extension NotificationService {
    
    public func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
		let notificationCenter = UNUserNotificationCenter.current()
		return try await notificationCenter.requestAuthorization(options: options)
    }
	
	public func register(_ configuration: NotificationClient.RegisterConfiguration) async throws {
		let request = try configuration.request
		let response = try await networkClient.send(request)
		
		if !response.metadata.status {
			if let code = response.metadata.code {
				throw NetworkClient.Error.serverError(statusCode: code, data: response.rawData)
			}
		}
		
		guard let data = response.rawData else {
			throw NetworkClient.Error.invalidResponse
		}
	}
	
	public func deregister(_ configuration: NotificationClient.RegisterConfiguration) async throws {
		let request = try configuration.request
		let response = try await networkClient.send(request)
		
		if !response.metadata.status {
			if let code = response.metadata.code {
				throw NetworkClient.Error.serverError(statusCode: code, data: response.rawData)
			}
		}
		
		guard let data = response.rawData else {
			throw NetworkClient.Error.invalidResponse
		}
	}
	
	public func deliveredNotifications(_ configuration: NotificationClient.NotifiesConfiguration) async throws -> [NotificationClient.Notification] {
		let request = configuration.request
		let response = try await networkClient.send(request)
		
		if !response.metadata.status {
			if let code = response.metadata.code {
				throw NetworkClient.Error.serverError(statusCode: code, data: response.rawData)
			}
		}
		
		guard let data = response.rawData else {
			throw NetworkClient.Error.invalidResponse
		}
		
		do {
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .rfc3339Flexible
			let listResponse = try decoder.decode(NotificationClient.NotifiesResponse.self, from: data)
			return listResponse.notifies
		} catch {
			throw NetworkClient.Error.decodingError(error)
		}
	}
	
	public func deliveredTopics(_ configuration: NotificationClient.TopicsConfiguration) async throws -> [NotificationClient.Topic] {
		let request = configuration.request
		let response = try await networkClient.send(request)
		
		if !response.metadata.status {
			if let code = response.metadata.code {
				throw NetworkClient.Error.serverError(statusCode: code, data: response.rawData)
			}
		}
		
		guard let data = response.rawData else {
			throw NetworkClient.Error.invalidResponse
		}
		
		do {
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .rfc3339Flexible
			let listResponse = try decoder.decode(NotificationClient.TopicsResponse.self, from: data)
			return listResponse.topics
		} catch {
			throw NetworkClient.Error.decodingError(error)
		}
	}
	
	public func notificationSettings(_ configuration: NotificationClient.SettingsConfiguration) async throws -> NotificationClient.SettingsResponse {
		let request = configuration.request
		let response = try await networkClient.send(request)
		
		if !response.metadata.status {
			if let code = response.metadata.code {
				throw NetworkClient.Error.serverError(statusCode: code, data: response.rawData)
			}
		}
		
		guard let data = response.rawData else {
			throw NetworkClient.Error.invalidResponse
		}
		
		do {
			let decoder = JSONDecoder()
			return try decoder.decode(NotificationClient.SettingsResponse.self, from: data)
		} catch {
			throw NetworkClient.Error.decodingError(error)
		}
	}
	
	public func setNotificationSettings(_ configuration: NotificationClient.SettingsConfiguration) async throws {
		let request = try configuration.enabledRequest
		let response = try await networkClient.send(request)
		
		if !response.metadata.status {
			if let code = response.metadata.code {
				throw NetworkClient.Error.serverError(statusCode: code, data: response.rawData)
			}
		}
		
		guard let data = response.rawData else {
			throw NetworkClient.Error.invalidResponse
		}
	}
	
	public func unreadNotifications(_ configuration: NotificationClient.UnreadConfiguration) async throws -> NotificationClient.UnreadResponse {
		let request = configuration.request
		let response = try await networkClient.send(request)
		
		if !response.metadata.status {
			if let code = response.metadata.code {
				throw NetworkClient.Error.serverError(statusCode: code, data: response.rawData)
			}
		}
		
		guard let data = response.rawData else {
			throw NetworkClient.Error.invalidResponse
		}
		
		do {
			let decoder = JSONDecoder()
			return try decoder.decode(NotificationClient.UnreadResponse.self, from: data)
		} catch {
			throw NetworkClient.Error.decodingError(error)
		}
	}
	
	public func markAsRead(_ configuration: NotificationClient.ReadConfiguration) async throws -> [NotificationClient.Notification] {
		let request = try configuration.request
		let response = try await networkClient.send(request)
		
		if !response.metadata.status {
			if let code = response.metadata.code {
				throw NetworkClient.Error.serverError(statusCode: code, data: response.rawData)
			}
		}
		
		guard let data = response.rawData else {
			throw NetworkClient.Error.invalidResponse
		}
		
		do {
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .rfc3339Flexible
			let listResponse = try decoder.decode(NotificationClient.NotifiesResponse.self, from: data)
			return listResponse.notifies
		} catch {
			throw NetworkClient.Error.decodingError(error)
		}
	}
	
	public func removeDeliveredNotifications(_ configuration: NotificationClient.DeleteConfiguration) async throws {
		let request = try configuration.request
		let response = try await networkClient.send(request)
		
		if !response.metadata.status {
			if let code = response.metadata.code {
				throw NetworkClient.Error.serverError(statusCode: code, data: response.rawData)
			}
		}
		
		guard let data = response.rawData else {
			throw NetworkClient.Error.invalidResponse
		}
	}
    
    public func removeAllNotifications() async throws {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let content = notification.request.content
        let userInfo = content.userInfo
        print("Nhận thông báo: \(userInfo)")
        completionHandler([.banner, .sound])
    }
}

extension JSONDecoder.DateDecodingStrategy {
	static var rfc3339Flexible: JSONDecoder.DateDecodingStrategy {
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [
			.withInternetDateTime,
			.withFractionalSeconds
		]
		return .custom { decoder in
			let container = try decoder.singleValueContainer()
			let dateStr = try container.decode(String.self)
			
			if let date = formatter.date(from: dateStr) {
				return date
			} else {
				throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid RFC3339 date: \(dateStr)")
			}
		}
	}
}
