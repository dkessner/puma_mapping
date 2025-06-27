# PUMA mapping



## Source code

```
├── readme.md                   # this file
│
├── puma_mapping.pde            # Processing example
├── Map.pde                     # Map and ShapeRecord classes for json data handling
├── shape_records.json          # shape data for LA County PUMAs
│
├── poc                         # original Proof of Concept program
│   ├── poc.pde
│   └── shape_records.json
│
└── shapefile                   # Python code for extracting info from shapefiles
    ├── extract.py
    ├── hello_shapefile.py
    ├── requirements.txt
    └── summarize.py
```

## Python setup

### First time setup

Create a new virtual environment (venv)
```
python3 -m venv venv
```

Activate the venv
```
source venv/bin/activate
```

Install requirements
```
pip install -r requirements.txt
```

### Development

Activate the venv
```
source venv/bin/activate
```

Deactivate the venv
```
deactivate
```



## Reference


### Data

[https://usa.ipums.org](https://usa.ipums.org)

Links to PUMAs data:  
[https://usa.ipums.org/usa/volii/tgeotools.shtml](https://usa.ipums.org/usa/volii/tgeotools.shtml)

Boundary file (shapefile in zipfile) download at bottom of page:  
[https://usa.ipums.org/usa/volii/pumas20.shtml](https://usa.ipums.org/usa/volii/pumas20.shtml)


### Shapefile handling


__PyShp__  
The Python Shapefile Library (PyShp) reads and writes ESRI Shapefiles in pure
Python.  
[https://github.com/GeospatialPython/pyshp](https://github.com/GeospatialPython/pyshp)


[https://github.com/GeospatialPython/pyshp?tab=readme-ov-file#reading-shapefiles](https://github.com/GeospatialPython/pyshp?tab=readme-ov-file#reading-shapefiles)


```python
import shapefile

sf = shapefile.Reader(input_path)

records = sf.records()
shapes = sf.shapes()

shape_records = [{'name':record.Name, 'puma':record.PUMA, 'points':shape.points} \
    for record, shape in zip(records, shapes) if "Los Angeles" in record.Name]
```


