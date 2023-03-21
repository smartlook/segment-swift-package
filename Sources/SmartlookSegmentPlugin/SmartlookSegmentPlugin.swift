import Foundation
import Segment
import SmartlookAnalytics

public class SmartlookSegmentPlugin: DestinationPlugin {

    public var key = "Smartlook"
    public var timeline = Timeline()
    public var type = Segment.PluginType.destination
    public var analytics: Segment.Analytics? = nil

    private var smartlookKey: String
    private var smartlookInstance: Smartlook

    public init(projectKey: String, smartlookInstance: Smartlook = Smartlook.instance) {
        self.smartlookKey = projectKey
        self.smartlookInstance = smartlookInstance
    }

    public func execute<T>(event: T?) -> T? where T : RawEvent {
        return event
    }

    public func update(settings: Settings, type: UpdateType) {

        guard type == .initial else { return }

        analytics?.manuallyEnableDestination(plugin: self)
        
        smartlookInstance.preferences.eventTracking?.trackNavigation = false
        smartlookInstance.preferences.projectKey = smartlookKey
        smartlookInstance.start()
    }

    public func identify(event: IdentifyEvent) -> IdentifyEvent? {

        smartlookInstance.user.identifier = event.userId

        let parameters = flattenJSON(event.traits)
        parameters?.forEach({ (key: String, value: String) in
            smartlookInstance.user.setProperty(key, to: value)
        })

        return event
    }

    public func track(event: TrackEvent) -> TrackEvent? {

        let parameters = flattenJSON(event.properties)
        let properties = Properties()

        parameters?.forEach({ (key: String, value: String) in
            properties.setProperty(key, to: value)
        })

        smartlookInstance.track(event: event.event, properties: properties)

        return event
    }

    public func alias(event: AliasEvent) -> AliasEvent? {

        smartlookInstance.user.setProperty("aliasId", to: event.userId)

        return event
    }

    public func screen(event: ScreenEvent) -> ScreenEvent? {

        guard let screenName = event.name else { return event }

        let parameters = flattenJSON(event.properties)
        let properties = Properties()

        parameters?.forEach({ (key: String, value: String) in
            properties.setProperty(key, to: value)
        })

        smartlookInstance.track(navigationEvent: screenName, properties: properties)

        return event
    }

    public func reset() {
        smartlookInstance.user.openNew()
    }

    // MARK: - private methods to handle Segment JSON

    private func flattenJSON(_ json: JSON?) -> [String: String]? {
        guard let jsonData = json?.toString().data(using: .utf8) else {
            return nil
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [AnyHashable: Any] else {
            return nil
        }

        return flattenDictionary(jsonObject)
    }

    private func flattenDictionary<Key: Hashable, Value>(_ dict: [Key: Value], parentKey: String = "") -> [String: String] {
        var flattenedDict = [String: String]()

        for (key, value) in dict {
            var newKey = "\(key)"
            if !parentKey.isEmpty {
                newKey = "\(parentKey)_\(key)"
            }

            if let subDict = value as? [Key: Value] {
                let subDictResult = flattenDictionary(subDict, parentKey: newKey)
                flattenedDict.merge(subDictResult) { (current, _) in current }

            } else if let stringValue = value as? String {
                flattenedDict[newKey] = stringValue

            } else {
                let stringValue = String(describing: value)
                flattenedDict[newKey] = stringValue
            }
        }

        return flattenedDict
    }
}
