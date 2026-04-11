import SwiftUI
import SwiftAndroidSDK

@main
struct SwiftAndroidImdbDemoApp: App {

    init() {
        // One-time SDK configuration. The credentials mirror what the SDK
        // has in its own local.properties — see README.md for setup.
        TMDBContainer.getShared().configure(
            bearerToken: TokenLoader.bearerToken,
            apiKey: TokenLoader.apiKey,
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

/// Loads the TMDB credentials at app launch.
///
/// Order of precedence per credential:
/// 1. `TMDB_READ_TOKEN` / `TMDB_API_KEY` environment variables
///    (set in the Xcode scheme → Run → Arguments → Environment Variables)
/// 2. `tmdb-token.txt` / `tmdb-api-key.txt` in the app bundle
///    (gitignored — drop the values there for local development)
/// 3. Empty string (the SDK will return 401 from any call until you set one)
enum TokenLoader {
    static var bearerToken: String {
        loadCredential(envVar: "TMDB_READ_TOKEN", bundleResource: "tmdb-token")
    }

    static var apiKey: String {
        loadCredential(envVar: "TMDB_API_KEY", bundleResource: "tmdb-api-key")
    }

    private static func loadCredential(envVar: String, bundleResource: String) -> String {
        if let env = ProcessInfo.processInfo.environment[envVar], !env.isEmpty {
            return env
        }
        if let url = Bundle.main.url(forResource: bundleResource, withExtension: "txt"),
           let content = try? String(contentsOf: url, encoding: .utf8) {
            return content.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return ""
    }
}
