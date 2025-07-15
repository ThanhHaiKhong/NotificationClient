//
//  Live.swift
//  NotificationClient
//
//  Created by Thanh Hai Khong on 10/2/25.
//

import NotificationClient
import Dependencies

extension NotificationClient: DependencyKey {
    public static let liveValue: NotificationClient = {
		let actor = NotificationActor()
        return NotificationClient(
            requestAuthorization: { options in
                try await actor.requestAuthorization(options: options)
            },
			register: { configuration in
				try await actor.register(configuration)
			},
			deregister: { configuration in
				try await actor.deregister(configuration)
			},
			deliveredNotifications: { configuration in
				try await actor.deliveredNotifications(configuration)
			},
			deliveredTopics: { configuration in
				try await actor.deliveredTopics(configuration)
			},
			markAsRead: { configuration in
				try await actor.markAsRead(configuration)
			},
			removeDeliveredNotifications: { configuration in
				try await actor.removeDeliveredNotifications(configuration)
			},
			notificationSettings: { configuration in
				try await actor.notificationSettings(configuration)
			},
			setNotificationSettings: { configuration in
				try await actor.setNotificationSettings(configuration)
			},
			unreadNotifications: { configuration in
				try await actor.unreadNotifications(configuration)
			}
        )
    }()
}
