//
// Map.java
//


public class Map
{
    private float rectX;
    private float rectY;
    private float rectW;
    private float rectH;

    private ArrayList<ShapeRecord> shape_records;

    private float xMin = Float.MAX_VALUE;
    private float xMax = -Float.MAX_VALUE;
    private float yMin = Float.MAX_VALUE;
    private float yMax = -Float.MAX_VALUE;

    public Map(float rectX, float rectY, float rectW, float rectH)
    {
        this.rectX = rectX;
        this.rectY = rectY;
        this.rectW = rectW;
        this.rectH = rectH;

        initialize_shape_records();
    }

    public float worldToScreenX(float x)
    {
        return map(x, xMin, xMax, rectX, rectX+rectW);
    }

    public float worldToScreenY(float y)
    {
        return map(y, yMin, yMax, rectY+rectH, rectY); // note: flip
    }

    private void initialize_shape_records()
    {
        // read in shape records from json file

        JSONArray json_shape_records = loadJSONArray("shape_records.json");
        println("[Map] shape records: " + json_shape_records.size());

        shape_records = new ArrayList<ShapeRecord>();

        for (int i=0; i<json_shape_records.size(); i++)
        {
            JSONObject json = json_shape_records.getJSONObject(i);
            shape_records.add(new ShapeRecord(this, json));
        }

        // calculate bounding box

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

        println("[Map] x range: ", xMin, xMax);
        println("[Map] y range: ", yMin, yMax);
    }

    void display()
    {
        rect(rectX, rectY, rectW, rectH);

        // draw each ShapeRecord

        for (ShapeRecord shape_record : shape_records)
            shape_record.display();

        // display selected 

        ShapeRecord selected = selected();
        fill(0, 255, 0);
        selected.display();

        textSize(20);
        text(selected.name, width*.2, height-50);
        text(selected.puma, width*.2, height-25);
    }

    ShapeRecord selected()
    {
        // calculate hover by smallest distance to center

        int hoverIndex = 0;
        float smallestDistance = Float.MAX_VALUE;

        for (int i=0; i<shape_records.size(); i++)
        {
            ShapeRecord shape_record = shape_records.get(i);

            float cx = worldToScreenX(shape_record.center.x);
            float cy = worldToScreenY(shape_record.center.y);

            float d = dist(mouseX, mouseY, cx, cy);

            if (d < smallestDistance)
            {
                hoverIndex = i;
                smallestDistance = d;
            }
        }

        return shape_records.get(hoverIndex);
    }
}


class ShapeRecord
{
    Map map; // back reference for coordinate conversion
    String name;
    String puma;
    ArrayList<PVector> points;
    PVector center;

    public ShapeRecord(Map map, JSONObject json)
    {
        this.map = map;
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

    void display()
    {
        beginShape();
        for (PVector p : points)
        {
            float x = map.worldToScreenX(p.x);
            float y = map.worldToScreenY(p.y); // note: flip
            vertex(x, y);
        }
        endShape();
    }
}

