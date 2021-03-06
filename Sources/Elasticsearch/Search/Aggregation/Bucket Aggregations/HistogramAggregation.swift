
import Foundation

/**
 A multi-bucket aggregation similar to the histogram except it can only be applied on date values. Since dates are represented in Elasticsearch internally as long values, it is possible to use the normal histogram on dates as well, though accuracy will be compromised. The reason for this is in the fact that time based intervals are not fixed (think of leap years and on the number of days in a month). For this reason, we need special support for time based data. From a functionality perspective, this histogram supports the same features as the normal histogram. The main difference is that the interval can be specified by date/time expressions.
 
 [More information](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-datehistogram-aggregation.html)
 */
public struct HistogramAggregation: Aggregation {
    public struct ExtendedBounds: Codable {
        public let min: Int
        public let max: Int
    }
    
    /// :nodoc:
    public static var typeKey = AggregationResponseMap.histogram
    
    /// :nodoc:
    public var name: String
    /// :nodoc:
    public let field: String
    /// :nodoc:
    public let interval: Int
    /// :nodoc:
    public let offset: Int?
    /// :nodoc:
    public let extendedBounds: ExtendedBounds?
    /// :nodoc:
    public let minDocCount: Int?
    /// :nodoc:
    public let missing: String?
    
    
    enum CodingKeys: String, CodingKey {
        case field
        case interval
        case timeZone = "time_zone"
        case offset
        case extendedBounds = "extended_bounds"
        case minDocCount = "min_doc_count"
        case missing
    }
    
    /// Creates a [terms](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-terms-aggregation.html) aggregation
    ///
    /// - Parameters:
    ///   - name: The aggregation name
    ///   - field: The field to perform the aggregation over
    ///   - interval: The bucket interval
    ///   - offset: By default the bucket keys start with 0 and then continue in even spaced steps of interval, e.g. if the interval is 10 the first buckets (assuming there is data inside them) will be [0, 10), [10, 20), [20, 30). The bucket boundaries can be shifted by using the offset option.
    ///   - minDocCount: The minimum number of matches for a document to be included
    ///   - missing: Defines how documents that are missing a value should be treated
    public init(
        name: String,
        field: String,
        interval: Int,
        offset: Int? = nil,
        extendedBounds: ExtendedBounds? = nil,
        minDocCount: Int? = nil,
        missing: String? = nil
        ) {
        self.name = name
        self.field = field
        self.interval = interval
        self.offset = offset
        self.extendedBounds = extendedBounds
        self.minDocCount = minDocCount
        self.missing = missing
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        var valuesContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: DynamicKey(stringValue: type(of: self).typeKey.rawValue)!)
        try valuesContainer.encode(field, forKey: .field)
        try valuesContainer.encode(interval, forKey: .interval)
        try valuesContainer.encodeIfPresent(offset, forKey: .offset)
        try valuesContainer.encodeIfPresent(extendedBounds, forKey: .extendedBounds)
        try valuesContainer.encodeIfPresent(minDocCount, forKey: .minDocCount)
        try valuesContainer.encodeIfPresent(missing, forKey: .missing)
    }
}
