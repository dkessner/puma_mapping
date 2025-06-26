#!/usr/bin/env python
#
# hello_shapefile.py
#


import shapefile
import json
import sys
from pathlib import Path


def main():

    if len(sys.argv) < 2:
        print("Usage: hello_shapefile.py /path/to/shapefile")
        sys.exit(1)

    input_path = sys.argv[1]
    print("input_path:", input_path)
    print()

    sf = shapefile.Reader(input_path)

    print("sf:", sf)
    print()
    print("sf.shapeType:", sf.shapeType)
    print("sf.shapeType == shapefile.POLYGON:", sf.shapeType == shapefile.POLYGON)
    print()

    fields = sf.fields
    print("fields:", fields)
    print()

    shapes = sf.shapes()
    records = sf.records()
    print(f"{len(shapes)} shapes")
    print(f"{len(records)} records")

    first = shapes[0]
    print("len(shapes[0].points):",  str(len(first.points)))
    print()

    print("shapes[0]:", shapes[0])
    print("records[0]:", records[0])
    print("records[0].Name:", records[0].Name)
    print("records[0].PUMA:", records[0].PUMA)
    print()


if __name__ == '__main__':
    main()



