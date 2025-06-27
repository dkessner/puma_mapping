#!/usr/bin/env python
#
# extract.py
#


import shapefile
import json
import sys
from pathlib import Path


def main():

    if len(sys.argv) < 2:
        print("Usage: extract.py /path/to/shapefile")
        sys.exit(1)

    input_path = sys.argv[1]
    print("input_path:", input_path)
    print()

    sf = shapefile.Reader(input_path)
    print("sf:", sf)

    records = sf.records()
    shapes = sf.shapes()

    shape_records = [{'name':record.Name, 'puma':record.PUMA, 'points':shape.points} \
            for record, shape in zip(records, shapes) if "Los Angeles" in record.Name]

    print(f"shape_records: {len(shape_records)}")

    with open("shape_records.json", 'w') as f:
        json.dump(shape_records, f)


if __name__ == '__main__':
    main()


