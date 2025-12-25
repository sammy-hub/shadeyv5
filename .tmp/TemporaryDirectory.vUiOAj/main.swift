#sourceLocation(file: "-e", line: 1)
import Foundation; let url = URL(fileURLWithPath: "/Users/samviers/Desktop/shadeyv1/Shadey.xcodeproj/project.pbxproj"); let data = try Data(contentsOf: url); var format = PropertyListSerialization.PropertyListFormat.openStep; _ = try PropertyListSerialization.propertyList(from: data, options: [], format: &format); print(format);
