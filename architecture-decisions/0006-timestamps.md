# 5. Timestamps

Date: 2024-02-22

## Status

Decided

## Context

We want to ensure that all timestamps are recorded and displayed in the same time zone and in iso8601 format: "2024-02-22T13:57:19-05:00". However, Mediaflux requires that timestamps be in a different format: "22-FEB-2024 13:57:19"

When querying a collection through Aterm — you will see the timezone for the automatic date settings in Mediaflux to be Etc/UTC with no gmt offset.

NOTE: there is no difference between time zones UTC and Etc/UTC

Etc/UTC is a timezone in the Olson-timezone-database (tz database), also known as IANA-timezones-database, in which all timezones conform to a uniform naming convention: Area/Location

Some timezones cannot be attributed to any Area of the world (think continents or oceans). Thus, the special Area Etc (Etcetera) was introduced. Area Etc applies mainly to administrative timezones such as UTC.

## Decision

Time zones should be recorded using the America/New York zone, NOT EST, because EST will change depending on the time of year. Additionally, the [ruby `Time` class](https://ruby-doc.org/3.3.0/Time.html) should be preferred over the `DateTime` class because the `Time` class covers concepts of Daylight Savings time. 

We will record the iso8601 timestamp in the database and this is what we will always display to the user. When we send data to Mediaflux, we will transform this timestamp to what Mediaflux expects. 

### Examples

Parsing a timestamp from MediaFlux:
```
Time.zone.parse(@last_modified_mf).in_time_zone("America/New_York").iso8601
```

Recording the current timestamp:
```
Time.current.in_time_zone("America/New_York").iso8601
```

Transforming iso8601 into Mediaflux format:
```
ProjectMediaflux.format_date_for_mediaflux(project.metadata[:updated_on])
```