
# 3D in Processing Workshop

Using Processing to construct and render 3D objects, control cameras and lighting, and do texture mapping.

## Goals

- Position objects and a camera within a scene
- Control lighting for a scene
- Create 3D objects using vertices
- Load 3D objects from external files
- Add a texture of a 3D object using UV maps
- Changing 3D object textures in real-time

## Basic 3D (rectrotate.pde)

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

## Cameras and Lights (cameras.pde, pointlights.pde)

- `lights()`
- `camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ)`
- `perspective(FOVy, aspect, zNear, zFar)`
- `ambientLight(colour)`
- `pointLight(colour, x, y, z)`
- There are also spotlights (`spotLight()`) and directional lights (`directionalLight`), but in interest of time, won't go into detail on those
- `lightSpecular(colour)` and `shininess(s)`

## Contructing and Texturing 3D Objects (pyramidshape.pde, texturecustomshape.pde)

- `beginShape(mode)` + `vertex(x,y,z)` + `endShape()`
- UV maps (e.g., like a projection of Earth's surface using latitude and longitude)
- `vertex(x,y,z,`**`u,v`**`)`
- UV map can change dynamically

## Loading and Texturing External 3D Objects (modelsin3d.pde)

- Using Blender to create a 3D conifer and UV map for it
- `.obj` and `.mtl` files
- `.obj` as `PShape` using `loadShape(filename)` and `shape(s)`
- `.mtl` files are automatically loaded in Processing
- Manually set `PShape` texture using `PShape.setTexture(tex)`





