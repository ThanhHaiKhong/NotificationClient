// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependenciesMacros
import UserNotifications

@DependencyClient
public struct NotificationClient: Sendable {
    public var requestAuthorization: @Sendable (_ options: UNAuthorizationOptions) async throws -> Bool
	public var register: @Sendable (_ configuration: NotificationClient.RegisterConfiguration) async throws -> Void
	public var deregister: @Sendable (_ configuration: NotificationClient.RegisterConfiguration) async throws -> Void
	public var deliveredNotifications: @Sendable (_ configuration: NotificationClient.NotifiesConfiguration) async throws -> [NotificationClient.Notification]
	public var deliveredTopics: @Sendable (_ configuration: NotificationClient.TopicsConfiguration) async throws -> [NotificationClient.Topic]
	public var markAsRead: @Sendable (_ configuration: NotificationClient.ReadConfiguration) async throws -> [NotificationClient.Notification]
	public var removeDeliveredNotifications: @Sendable (_ configuration: NotificationClient.DeleteConfiguration) async throws -> Void
	public var enabledNotifications: @Sendable (_ configuration: NotificationClient.EnabledConfiguration) async throws -> NotificationClient.EnabledResponse
	public var setEnabledNotifications: @Sendable (_ configuration: NotificationClient.SetEnabledConfiguration) async throws -> Void
	public var unreadNotifications: @Sendable (_ configuration: NotificationClient.UnreadConfiguration) async throws -> NotificationClient.UnreadResponse
}
