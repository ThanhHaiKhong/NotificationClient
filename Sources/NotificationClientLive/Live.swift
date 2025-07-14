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
			getNotifications: { configuration in
				try await actor.getNotifications(configuration)
			},
			getTopics: { configuration in
				try await actor.getTopics(configuration)
			},
			markAsRead: { configuration in
				try await actor.markAsRead(configuration)
			},
			deletes: { configuration in
				try await actor.deletes(configuration)
			},
			enabledNotifications: { configuration in
				try await actor.enabledNotifications(configuration)
			},
			setEnabledNotifications: { configuration in
				try await actor.setEnabledNotifications(configuration)
			},
			statusNotifications: { configuration in
				try await actor.statusNotifications(configuration)
			}
        )
    }()
}
