
# Workshop 6: 3D Graphics

We'll explore how to use Processing to construct and render 3D objects, control cameras and lighting, and do texture mapping.

## Goals

- Position objects and a camera within a scene
- Control lighting for a scene
- Create 3D objects using vertices
- Load 3D objects from external files
- Add a texture of a 3D object using UV maps
- Changing 3D object textures in real-time

_No pre-workshop setup is necessary._

> **Note:** On MacOS, you may see red warning messages in the console  when you run Processing code using the P3D renderer. It's safe to ignore it. 

# In-Class Workshop

During the workshop, we'll review the different Processing code examples and do small exercises.

## 3D Basics

### Sketches: **`rectrotate`**

Demonstrates the basics of setting up your canvas for 3D graphics, drawing 3D primitives, and using 3D transformations.

Topics and demos:
- Coordinate system:
    - Down = +Y
    - Right = +X
    - Out of screen = +Z
- `size(w, h, `**`P3D`**`)`
- 3D primitives:
    - `box(w,h,d)` or `box(s)`
    - `sphere(r)`
- Use `noStroke()` for solid look, `noFill()` for wireframe look
- Transformations:
    - `translate(x,y,z)`
    - `scale(x,y,z)` – *Also scales the stroke weight, which can look weird for large values*
    - `rotateX(t)`, `rotateY(t)`, `rotateZ(t)`

#### Experiments

1. Try commenting out the `translate` line, what happens? Why?
2. Add the code below to draw a "2D" line right after the box,  what happens? Why?
```Java
line(0, -75, 0, 75);
```
3. Change the third argument of `translate` to be `mouseX - 100` like the code below. What happens? Why?
```Java
translate(width/2, height/2, mouseX - 100);
```

## Cameras and Lights 

### Sketches: **`cameras`** and **`pointlights`**

Topics and demos:
- `lights()`
- `camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ)`
- `perspective(FOVy, aspect, zNear, zFar)`
- `ambientLight(colour)`
- `pointLight(colour, x, y, z)`
- There are also spotlights (`spotLight()`) and directional lights (`directionalLight`), but in interest of time, won't go into detail on those
- `lightSpecular(colour)` and `shininess(s)`

#### Experiment

TBD

## Constructing and Texturing 3D Objects

### Sketches: **`pyramidshape`** and **`texturecustomshape`**

Topics and demos:

- `beginShape(mode)` + `vertex(x,y,z)` + `endShape()`
- UV maps (e.g., like a projection of Earth's surface using latitude and longitude)
- `vertex(x,y,z,`**`u,v`**`)`
- UV map can change dynamically

#### Experiment

TBD

## Loading and Texturing External 3D Objects 

### Sketch: **`modelsin3d`** 

Topics and demos:

- Using Blender to create a 3D conifer and UV map for it
- `.obj` and `.mtl` files
- `.obj` as `PShape` using `loadShape(filename)` and `shape(s)`
- `.mtl` files are automatically loaded in Processing
- Manually set `PShape` texture using `PShape.setTexture(tex)`

#### Experiment

Find an object online, or create your own, then try to import it. Avoid very detailed and complex models. 


# Digital Sketchbook Exercise

TBD



