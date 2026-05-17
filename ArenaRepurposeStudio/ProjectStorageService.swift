import Foundation
import Combine

final class ProjectStorageService: ObservableObject {
    @Published private(set) var projects: [Project] = []

    private let fileURL: URL = {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("aid_projects.json")
    }()

    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        e.outputFormatting = .prettyPrinted
        return e
    }()

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    init() {
        load()
    }

    func save(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            var updated = project
            updated.updatedAt = Date()
            projects[index] = updated
        } else {
            projects.insert(project, at: 0)
        }
        persist()
    }

    func delete(_ project: Project) {
        projects.removeAll { $0.id == project.id }
        persist()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            projects.remove(at: index)
        }
        persist()
    }

    private func persist() {
        guard let data = try? encoder.encode(projects) else { return }
        try? data.write(to: fileURL, options: .atomicWrite)
    }

    private func load() {
        guard
            let data = try? Data(contentsOf: fileURL),
            let loaded = try? decoder.decode([Project].self, from: data)
        else { return }
        projects = loaded
    }
}
