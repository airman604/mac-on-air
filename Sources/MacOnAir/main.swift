import IsCameraOn
import Foundation

// Parse command line arguments
guard CommandLine.arguments.count >= 2 else {
	print("Usage: \(CommandLine.arguments[0]) <webhook-url>")
	exit(1)
}

let webhookURLString = CommandLine.arguments[1]
guard let webhookURL = URL(string: webhookURLString) else {
	print("Error: Invalid webhook URL: \(webhookURLString)")
	exit(1)
}

// Function to send webhook request
func sendWebhook(isOn: Bool) async {
	let payload: [String: Bool] = ["on": isOn]
	
	guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
		print("Error: Failed to serialize JSON payload")
		return
	}
	
	var request = URLRequest(url: webhookURL)
	request.httpMethod = "POST"
	request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	request.httpBody = jsonData
	
	do {
		let (_, response) = try await URLSession.shared.data(for: request)
		
		if let httpResponse = response as? HTTPURLResponse {
			if httpResponse.statusCode == 200 {
				print("✅ Webhook sent: camera \(isOn ? "ON" : "OFF")")
			} else {
				print("⚠️  Webhook returned status code: \(httpResponse.statusCode)")
			}
		}
	} catch {
		print("❌ Error sending webhook: \(error.localizedDescription)")
	}
}

// Start monitoring camera status changes
print("📱 Starting camera monitoring service...")
print("🔗 Webhook URL: \(webhookURLString)")
print("")

Task {
	for await isOn in cameraStatusChanges(includeExternal: true) {
		let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
		print("[\(timestamp)] Camera status changed: \(isOn ? "📸 ON" : "📴 OFF")")
		await sendWebhook(isOn: isOn)
	}
}

// Keep the service running
RunLoop.main.run()
