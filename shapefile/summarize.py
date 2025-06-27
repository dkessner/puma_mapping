#!/usr/bin/env python
#
# summarize.py
#


import shapefile
import json
import sys
from pathlib import Path


def main():

    if len(sys.argv) < 2:
        print("Usage: summarize.py /path/to/shapefile")
        sys.exit(1)

    input_path = sys.argv[1]
    print("input_path:", input_path)
    print()

    sf = shapefile.Reader(input_path)
    print("sf:", sf)

    records = sf.records()
    shapes = sf.shapes()

    for record, shape in zip(records, shapes):
        print(record.Name, record.PUMA, len(shape.points))


if __name__ == '__main__':
    main()


