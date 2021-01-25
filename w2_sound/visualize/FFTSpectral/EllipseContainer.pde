
class EllipseContainer
{
  public float x = -1; 
  public float y = -1; 
  public float size = -1;
  public float hue = 0;
  public float bands; 

  public EllipseContainer(float _bands) {
    bands = _bands;
  }

  public void DeepCopy(EllipseContainer _obj)
  {
    size = _obj.size;
    hue = _obj.hue;
    bands = _obj.bands;
  }

  public void SetParams(float _x, float _y, float _size, float _hue, float _bands) {
    x = _x;
    y = _y;
    size = _size;
    hue = _hue;
    bands = _bands;
  }

  public void SetColorSize(float _size, float _hue)
  {
    size = _size;
    hue = _hue;
  }

  public void SetCoord(float _x, float _y)
  {
    x = _x;
    y = _y;
  }

  public void Draw() {
    if (size < 0) return;
    
    fill(hue, 100, 100);
    noStroke();
    ellipse(x, y, size, size);
  }
}
