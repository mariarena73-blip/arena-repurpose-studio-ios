import Foundation

struct OpenRouterGenerationResult: Equatable {
    let content: String
    let model: String?
}

enum OpenRouterServiceError: Error, Equatable {
    case missingAPIKey
    case invalidResponse
    case transportError(String)
    case httpError(statusCode: Int, message: String?)
    case emptyResponse
    case emptyContent
    case invalidJSON
}

extension OpenRouterServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Inserisci una API key OpenRouter."
        case .invalidResponse:
            return "Risposta OpenRouter non valida."
        case .transportError(let message):
            return "Impossibile contattare OpenRouter. \(message)"
        case .httpError(let statusCode, let message):
            if let message, !message.isEmpty {
                return "OpenRouter ha restituito errore HTTP \(statusCode): \(message)"
            }
            return "OpenRouter ha restituito errore HTTP \(statusCode)."
        case .emptyResponse:
            return "OpenRouter ha restituito una risposta vuota."
        case .emptyContent:
            return "OpenRouter non ha restituito contenuto generato."
        case .invalidJSON:
            return "OpenRouter ha restituito JSON non valido."
        }
    }
}

struct OpenRouterService {
    nonisolated static let endpoint = URL(string: "https://openrouter.ai/api/v1/chat/completions")!
    nonisolated static let defaultModel = "openrouter/free"

    private let session: URLSession
    private let endpoint: URL

    init(
        session: URLSession = .shared,
        endpoint: URL = OpenRouterService.endpoint
    ) {
        self.session = session
        self.endpoint = endpoint
    }

    func generateOutput(
        for structuredRequest: String,
        apiKey: String,
        model: String = OpenRouterService.defaultModel
    ) async throws -> OpenRouterGenerationResult {
        let trimmedAPIKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAPIKey.isEmpty else {
            throw OpenRouterServiceError.missingAPIKey
        }

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(trimmedAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try Self.makeRequestBody(
            for: structuredRequest,
            model: model
        )

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw OpenRouterServiceError.invalidResponse
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                throw OpenRouterServiceError.httpError(
                    statusCode: httpResponse.statusCode,
                    message: Self.openRouterErrorMessage(from: data)
                )
            }

            return try Self.decodedGenerationResult(from: data)
        } catch let error as OpenRouterServiceError {
            throw error
        } catch {
            throw OpenRouterServiceError.transportError(error.localizedDescription)
        }
    }

    static func makeRequestBody(
        for structuredRequest: String,
        model: String = OpenRouterService.defaultModel
    ) throws -> Data {
        let body = OpenRouterChatCompletionRequest(
            model: model,
            messages: [
                .init(role: "user", content: structuredRequest)
            ]
        )
        return try JSONEncoder().encode(body)
    }

    static func decodedGenerationResult(from data: Data) throws -> OpenRouterGenerationResult {
        guard !data.isEmpty else {
            throw OpenRouterServiceError.emptyResponse
        }

        let decodedResponse: OpenRouterChatCompletionResponse
        do {
            decodedResponse = try JSONDecoder().decode(
                OpenRouterChatCompletionResponse.self,
                from: data
            )
        } catch {
            throw OpenRouterServiceError.invalidJSON
        }

        guard
            let content = decodedResponse.choices.first?.message.content?
                .trimmingCharacters(in: .whitespacesAndNewlines),
            !content.isEmpty
        else {
            throw OpenRouterServiceError.emptyContent
        }

        let model = decodedResponse.model?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return OpenRouterGenerationResult(
            content: content,
            model: model?.isEmpty == true ? nil : model
        )
    }

    private static func openRouterErrorMessage(from data: Data) -> String? {
        guard !data.isEmpty else { return nil }
        guard let response = try? JSONDecoder().decode(OpenRouterErrorResponse.self, from: data) else {
            return nil
        }
        return response.message?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private struct OpenRouterChatCompletionRequest: Encodable {
    let model: String
    let messages: [Message]

    struct Message: Encodable {
        let role: String
        let content: String
    }
}

private struct OpenRouterChatCompletionResponse: Decodable {
    let model: String?
    let choices: [Choice]

    struct Choice: Decodable {
        let message: Message
    }

    struct Message: Decodable {
        let content: String?
    }
}

private struct OpenRouterErrorResponse: Decodable {
    let message: String?

    private enum CodingKeys: String, CodingKey {
        case error
        case message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let detail = try? container.decode(OpenRouterErrorDetail.self, forKey: .error) {
            message = detail.message
            return
        }

        if let errorMessage = try? container.decode(String.self, forKey: .error) {
            message = errorMessage
            return
        }

        message = try container.decodeIfPresent(String.self, forKey: .message)
    }
}

private struct OpenRouterErrorDetail: Decodable {
    let message: String?
}
