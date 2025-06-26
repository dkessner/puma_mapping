//
// puma_mapping.pde
//



ArrayList<ShapeRecord> shape_records;

float xMin = Float.MAX_VALUE;
float xMax = -Float.MAX_VALUE;
float yMin = Float.MAX_VALUE;
float yMax = -Float.MAX_VALUE;


void setup()
{
    size(800, 800);
    initialize_shape_records();
}


void initialize_shape_records()
{
    JSONArray json_shape_records = loadJSONArray("shape_records.json");
    println(json_shape_records.size());

    shape_records = new ArrayList<ShapeRecord>();

    for (int i=0; i<json_shape_records.size(); i++)
    {
        JSONObject json = json_shape_records.getJSONObject(i);
        shape_records.add(new ShapeRecord(json));
    }

    /*
    for (ShapeRecord shape_record : shape_records)
    {
        println(shape_record.name);
        println(shape_record.points.size());
    }
    */

    for (ShapeRecord shape_record : shape_records)
    {
        for (PVector p : shape_record.points)
        {
            if (p.x < xMin) xMin = p.x;
            if (p.x > xMax) xMax = p.x;
            if (p.y < yMin) yMin = p.y;
            if (p.y > yMax) yMax = p.y;
        }
    }

    println("x range: ", xMin, xMax);
    println("y range: ", yMin, yMax);
}


void draw()
{
    background(0);

    // calculate hover by smallest distance to center

    int hoverIndex = 0;
    float smallestDistance = Float.MAX_VALUE;

    for (int i=0; i<shape_records.size(); i++)
    {
        ShapeRecord shape_record = shape_records.get(i);

        float cx = map(shape_record.center.x, xMin, xMax, 0, width);
        float cy = map(shape_record.center.y, yMin, yMax, height, 0); // note: flip
        float d = dist(mouseX, mouseY, cx, cy);

        if (d < smallestDistance)
        {
            hoverIndex = i;
            smallestDistance = d;
        }
    }

    // draw each ShapeRecord

    for (int i=0; i<shape_records.size(); i++)
    {
        ShapeRecord shape_record = shape_records.get(i);

        // change color if hovering over this one
        if (i == hoverIndex)
            fill(0, 255, 0);
        else
            fill(255);

        beginShape();
        for (PVector p : shape_record.points)
        {
            float x = map(p.x, xMin, xMax, 0, width);
            float y = map(p.y, yMin, yMax, height, 0); // note: flip
            vertex(x, y);
        }
        endShape();
    }

    // display name of selected record

    ShapeRecord record_hover = shape_records.get(hoverIndex);
    textSize(20);
    text(record_hover.name, width*.2, height-50);
    text(record_hover.puma, width*.2, height-25);
}


class ShapeRecord
{
    String name;
    String puma;
    ArrayList<PVector> points;
    PVector center;

    public ShapeRecord(JSONObject json)
    {
        name = json.getString("name");
        puma = json.getString("puma");
        points = new ArrayList<PVector>();

        JSONArray json_points = json.getJSONArray("points");
        for (int i=0; i<json_points.size(); i++)
        {
            JSONArray point = json_points.getJSONArray(i);
            if (point.size() != 2) println("I am insane!");
            PVector p = new PVector(point.getFloat(0), point.getFloat(1));
            points.add(p);
        }

        center = new PVector();
        for (PVector p : points)
            center.add(p);
        center.div(points.size());
    }
}


