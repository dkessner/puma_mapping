//
// Map.pde
//


public class Map
{
    private float rectX;
    private float rectY;
    private float rectW;
    private float rectH;

    private ArrayList<ShapeRecord> shapeRecords;

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

        initializeShapeRecords();
    }

    public float worldToScreenX(float x)
    {
        return map(x, xMin, xMax, rectX, rectX+rectW);
    }

    public float worldToScreenY(float y)
    {
        return map(y, yMin, yMax, rectY+rectH, rectY); // note: flip
    }

    private void initializeShapeRecords()
    {
        // read in shape records from json file

        JSONArray jsonShapeRecords = loadJSONArray("shape_records.json");
        println("[Map] shape records: " + jsonShapeRecords.size());

        shapeRecords = new ArrayList<ShapeRecord>();

        for (int i=0; i<jsonShapeRecords.size(); i++)
        {
            JSONObject json = jsonShapeRecords.getJSONObject(i);
            shapeRecords.add(new ShapeRecord(this, json));
        }

        // calculate bounding box

        for (ShapeRecord shapeRecord : shapeRecords)
        {
            for (PVector p : shapeRecord.points)
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

    void displayBackground()
    {
        rect(rectX, rectY, rectW, rectH);
    }

    void displayShapes()
    {
        for (ShapeRecord shapeRecord : shapeRecords)
            shapeRecord.display();
    }

    public ShapeRecord selected()
    {
        // return the ShapeRecord with center closest to mouse

        ShapeRecord result = shapeRecords.get(0);
        float smallestDistance = Float.MAX_VALUE;

        for (ShapeRecord shapeRecord : shapeRecords)
        {
            float cx = worldToScreenX(shapeRecord.center.x);
            float cy = worldToScreenY(shapeRecord.center.y);
            float d = dist(mouseX, mouseY, cx, cy);

            if (d < smallestDistance)
            {
                result = shapeRecord;
                smallestDistance = d;
            }
        }

        return result;
    }
}


public class ShapeRecord
{
    private Map map; // back reference for coordinate conversion
    private String name;
    private String puma;
    private ArrayList<PVector> points;
    private PVector center;

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

    public void display()
    {
        beginShape();
        for (PVector p : points)
        {
            float x = map.worldToScreenX(p.x);
            float y = map.worldToScreenY(p.y);
            vertex(x, y);
        }
        endShape();
    }

    public int getPuma() {return Integer.parseInt(puma);}
    public String getName() {return name;}
}



