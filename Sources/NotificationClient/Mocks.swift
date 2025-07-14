//
//  Mocks.swift
//  NotificationClient
//
//  Created by Thanh Hai Khong on 10/2/25.
//

import Dependencies

extension DependencyValues {
	public var notificationClient: NotificationClient {
		get { self[NotificationClient.self] }
		set { self[NotificationClient.self] = newValue }
	}
}

extension NotificationClient: TestDependencyKey {
    public static var testValue: NotificationClient {
		NotificationClient()
    }
    
    public static var previewValue: NotificationClient {
        NotificationClient()
    }
}
