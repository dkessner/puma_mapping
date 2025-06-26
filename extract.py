#!/usr/bin/env python
#

import shapefile
import json


from pathlib import Path

home_directory = Path.home()
print(home_directory)


#sf = shapefile.Reader(home_directory / "Desktop" / "ipums" /  "ipums_puma_2020.shp")
sf = shapefile.Reader("ipums_puma_2020.shp")
print(sf)
print(sf.shapeType)
print(sf.shapeType == shapefile.POLYGON)


shapes = sf.shapes()
print(f"{len(shapes)} shapes")

first = shapes[0]
#print(dir(first))
print(str(len(first.points)) + " points")

fields = sf.fields
print(fields)

records = sf.records()
print(f"{len(records)} records")
print(records[0])
print(records[1])
print(records[2].Name)
print(records[2].PUMA)


print('----')
print()


#for record, shape in zip(records, shapes):
#    if "Los Angeles" in record.Name:
#        print(record, shape.points)


shape_records = [{'name':record.Name, 'puma':record.PUMA, 'points':shape.points} \
        for record, shape in zip(records, shapes) if "Los Angeles" in record.Name]

print(f"shape_records: {len(shape_records)}")
#print(shape_records[0])

with open("shape_records.json", 'w') as f:
    json.dump(shape_records, f)

