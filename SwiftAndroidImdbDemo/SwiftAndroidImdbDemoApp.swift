import SwiftUI
import SwiftAndroidSDK

@main
struct SwiftAndroidImdbDemoApp: App {

    init() {
        // One-time SDK configuration. The bearer token is read from a file
        // (or environment) — see README.md for setup. Hard-coded here as a
        // placeholder; replace before running.
        let token = TokenLoader.bearerToken
        TMDBContainer.getShared().configure(bearerToken: token)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

/// Loads the TMDB bearer token at app launch.
///
/// Order of precedence:
/// 1. `TMDB_BEARER_TOKEN` environment variable (set in the Xcode scheme)
/// 2. `tmdb-token.txt` in the app bundle (gitignored — drop your token there)
/// 3. Empty string (the SDK will return 401 from any call until you set one)
enum TokenLoader {
    static var bearerToken: String {
        if let env = ProcessInfo.processInfo.environment["TMDB_BEARER_TOKEN"], !env.isEmpty {
            return env
        }
        if let url = Bundle.main.url(forResource: "tmdb-token", withExtension: "txt"),
           let content = try? String(contentsOf: url, encoding: .utf8) {
            return content.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return ""
    }
}
