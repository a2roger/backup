
class EllipseContainer
{
  public float x = -1; 
  public float y = -1; 
  public float size = -1;
  public float hue = 0;
  public float start_hue;
  public float bands; 

  private int mX;
  private int mY;
  private float mStepAmount;

  public EllipseContainer(int posx, int posy, float sHue, float _stepAmount, float _bands) {
    mX = posx;
    mY = posy;
    start_hue = sHue;
    mStepAmount = _stepAmount;
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
    ellipse(x, y, size, size);

    fill(hue, 100, 100);
    noStroke();
  }
}
