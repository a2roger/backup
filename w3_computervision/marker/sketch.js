// https://kylemcdonald.github.io/cv-examples/
// more here:
// http://fhtr.org/JSARToolKit/demos/tests/test2.html

// parameters
let p = {
    threshold: 128,
    thresholdMin: 0,
    thresholdMax: 255
  }

let capture;
let w = 640,
    h = 480;

let raster, param, pmat, resultMat, detector;

function setup() {
    createCanvas(w, h);

    pixelDensity(1); // this makes the internal p5 canvas smaller

    // setup camera (I think this can be simplified)
    capture = createCapture({
        audio: false,
        video: {
            width: w,
            height: h
        }
    }, function() {
        console.log('capture ready.')
    });
    capture.elt.setAttribute('playsinline', '');
    capture.size(w, h);
    capture.hide();

    // add params to a GUI
    createParamGui(p, paramChanged);    

    // JSAR setup (syntax is not very JavaScript)
    // point the detector to the canvas
    raster = new NyARRgbRaster_Canvas2D(canvas);
    // set some basic camera parameters
    param = new FLARParam(canvas.width, canvas.height);
    // setup the camera transformation matrix
    pmat = mat4.identity();
    param.copyCameraMatrix(pmat, 100, 10000);
    // create the detector
    detector = new FLARMultiIdMarkerDetector(param, 2);
    // tell detector to assume markers continue from frame to frame
    detector.setContinueMode(true);
    // place to put results each frame
    resultMat = new NyARTransMatResult();
}

function draw() {
    image(capture, 0, 0, w, h);

    canvas.changed = true;
     
    // get list of detected markers
    detected = detector.detectMarkerLite(raster, p.threshold);

    for (let i = 0; i < detected; i++) {

        // lot of work to get the marker id number:

        // Get the ID marker data for the current marker.
        // ID markers are special kind of markers that encode a number.
        // The bytes for the number are in the ID marker data.
        let idData = detector.getIdMarkerData(i);

        // read bytes from the id packet
        let id = -1;
        // this code handles 32-bit numbers
        if (idData.packetLength <= 4) {
            id = 0;
            for (let j = 0; j < idData.packetLength; j++) {
                id = (id << 8) | idData.getPacketData(j);
            }
        }        

        // get the transformation for this marker
        detector.getTransformMatrix(i, resultMat);

        // convert the transformation to account for our camera
        let mat = resultMat;
        let cm = mat4.create();
        cm[0] = mat.m00, cm[1] = -mat.m10, cm[2] = mat.m20, cm[3] = 0;
        cm[4] = mat.m01, cm[5] = -mat.m11, cm[6] = mat.m21, cm[7] = 0;
        cm[8] = -mat.m02, cm[9] = mat.m12, cm[10] = -mat.m22, cm[11] = 0;
        cm[12] = mat.m03, cm[13] = -mat.m13, cm[14] = mat.m23, cm[15] = 1;
        mat4.multiply(pmat, cm, cm);

        // define a set of 3d vertices
        let q = 1;
        let verts = [
            vec4.create(-q, -q, 0, 1),
            vec4.create(q, -q, 0, 1),
            vec4.create(q, q, 0, 1),
            vec4.create(-q, q, 0, 1),
//            vec4.create(0, 0, -2*q, 1) // poke up
        ];

        // convert that set of vertices from object space to screen space
        let w2 = width / 2;
        let h2 = height / 2;

        verts.forEach(function (v) {
            mat4.multiplyVec4(cm, v);
            v[0] = v[0] * w2 / v[3] + w2;
            v[1] = -v[1] * h2 / v[3] + h2;
        });

        // flash the markers to show they're recognized
        noStroke();
        fill(0, millis() % 255);
        beginShape();
        verts.forEach(function (v) {
            vertex(v[0], v[1]);
        });
        endShape();

        // show marker id
        noStroke()
        fill('#ff0000')
        textSize(32)
        textAlign(LEFT, CENTER)
        text(`${id}`,verts[0][0] + 10, verts[0][1] - 10)
    }
}

// global callback from the settings GUI
function paramChanged(name) {
}