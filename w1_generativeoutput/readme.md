# Workshop 1: Generative Output

We'll explore different algorithms and techniques to generate visual output. The content for this workshop is based on the book [Generative Design](http://www.generative-gestaltung.de/) (and the book's example [code](http://www.generative-gestaltung.de/code)) by Hartmut Bohnacker, Benedikt Groß, Julia Laub, and Claudius Lazzeroni. 

> In these workshop notes, the acronym "GD" refers to the Generative Design book. Related sections and code examples given using the format used in the book (e.g. **P.2.1.2** for sections, `P_2_1_2_01` for code).

## Goals

* Learn different generative rules to transform compositions and images 
* Experiment with autonomous agents to generate emergent patterns
* Use physical systems like attraction and repulsion to generate visual form

#### Required Reading and Viewing

Read the first chapter from Matt Pearson's book, _Generative Art_, **[Generative Art: In Theory and Practice](https://livebook.manning.com/#!/book/generative-art/chapter-1/1) (1st edition)** and then watch [this 6-minute video about Casey Reas](https://www.youtube.com/embed/_8DMEHxOLQE) (Reas is pronounced like "Reese").

[![Casey Reas Creators Project](https://img.youtube.com/vi/_8DMEHxOLQE/0.jpg)](https://www.youtube.com/embed/_8DMEHxOLQE)

<!-- <iframe width="560" height="315" src="https://www.youtube.com/embed/_8DMEHxOLQE" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe> -->

(If you liked that video, you should watch more videos from the _Creators Project_ series.)


# Pre-workshop Set Up

Try to complete the following _before_ the Workshop class.

#### 1. Install required libraries

* [**Ani**](http://www.looksgood.de/libraries/Ani/), a lightweight library for creating animations and transitions ([easing style cheat sheet](http://benedikt-gross.de/libraries/Ani/Ani_Cheat_Sheet.pdf))
* [**ControlP5**](http://www.sojamo.de/libraries/controlP5/), a GUI library to build custom user interfaces 
* **GenerativeDesign**, a collection of various functions for generative design

> Use the menu `Sketch/Import Library.../Add Library...`, in the dialogue that opens, search for the library name and click "Install". 


#### 2. Download code from the Generative Design book

* [Generative Design Code Package for Processing 3.x](https://github.com/generative-design/Code-Package-Processing-3.x/releases/tag/latest)

> Post to slack if you have trouble with set up. Please provide details so we can diagnose (e.g. operating system, error messages, steps to reproduce the error) 


# In-Class Workshop

During the workshop, we'll review the different Processing code examples and do small exercises.

## Agents and Rules

A flexible way to create generative output is to encode drawing behaviour in an _Agent_. An Agent is simply an encapsulation class that maintains and updates its own state based on some rules, and then draws part of an image. The usual approach is to create many Agents so they work collectively to generate semi-autonomous output. 

### Grids of Agents 

#### Sketch: **`gridflip`** 

<!-- ![thumbnail](img/gridflip.png) -->

A grid of Agents, each is a short line that can be tilted in one of two directions. Use Gui menu to adjust parameters and SPACE to pick a new random layout.

* `Agent` class: constructor, `update`, and `draw`
* Using `random(1)` and a threshold between 0 and 1 to make weighted decisions
* code that can easily switch between testing window and **full screen presentation**
	- tile number is chosen based on _size_ of tile, not _number_ of tiles across
* Transformation review
* `Gui` class for parameter control:
	- where to wire it in
	- adding sliders
	- function callbacks


#### Experiments

##### 1. Add code to make the agents randomly "flip". 

Create a new global variable that represents the chance that an Agent flips their angle _each second_.

```java
float flipChance = 0.01;
```

In `setup()`, add a slider to the GUI to adjust `flipChance`. 

```java
gui.addSlider("flipChance", 0, 1); 
```

Add code to `Agent.update()` to flip the angle randomly based on `flipChance`. 

```java
if (random(1) < flipChance/frameRate) {
  float a = -45;
  if (angle < 0) {
    a = 45;
  }
  angle = a;
}
```

> Why do you think `flipChance` is divided by `frameRate`?

Run your code and adjust the flipChance slider to see the effect.


##### 2. To bring the agents to life, try animating the angle change by using this code in `Agent.update()`:

```java
//angle = a;
Ani.to(this, 2, "angle", a, Ani.ELASTIC_OUT);
```

The  [Ani library](http://www.looksgood.de/libraries/Ani/) is very useful. For example, try changing the [animation easing function](http://www.looksgood.de/libraries/Ani/Ani_Cheat_Sheet.pdf) in the code above from `Ani.ELASTIC_OUT` to something else.


#### Sketch: **`gridshape`** 

A grid of Agents, each is a small SVG image that turns towards the mouse or scales based on distance from the mouse.

* loading and drawing SVG shapes
* `atan2` to find angle between two points
* `dist` to find distance between two points


#### Experiments

##### 1. Use the parameters to generate a form

Choose a shape and adjust the parameters (or the code itself) to create a form you like. Press 's' to save your final form to disk and share with the class on Slack #general.

##### 2. Create your own SVG shape to use for an agent

Use an online tool like [Method Draw](http://editor.method.ac/) or your favourite vector drawing program. The SVG should be about 100 by 100 pixels and have a completely transparent background. Simple shapes work great, and offsetting them from the centre of the SVG image area produces nice effects (load one of the SVG shapes in the Data directory to see how they're offset). Try some alpha transparency for the fill and pick different colours too. Save it and share it on Slack.


#### Related

See also GD **P.2.1.1**, p. 206, and these code examples:
* `P_2_1_1_01` changing strokeweight and strokecaps on diagonals in a grid
* `P_2_1_1_04`: shapes in a grid, that are always facing the mouse


### Movement in a grid 

#### Sketch: **`gridmove`** 

Animating the change in position of circles in a grid using controlled random generators.

* calling `Agent.update` from other event functions (not always draw)
* using `randomSeed`

See also GD **P.2.1.2**, p. 210, and these code examples:
* `P_2_1_2_01`: changing size and position of circles in a grid


### Pixels in a grid

#### Sketch: **`gridpixels`** 

Shows that agent rules can come from pixel information. Compare to GD sketch `P_4_3_1_01` which doesn't separate behaviours into agents and uses mouse input to vary parameters.

* Code is a little buggy, and need way to connect agents to each other
* Would be interesting to run this on live video

See also GD **P.4.3.1**, p. 302, and these code examples:
* `P_4_3_1_01`: pixel mapping. each pixel is translated into a new element


## Drawing with Agents

### Using kinematic rules

#### Sketch: **`drawlines`** 

Agents move around the canvas leaving a trail.

* semi-random direction and step size (`maxStep` and `probTurn`)
* `interact = true` turns on additional inter-agent behaviour

> **Question:** One problem with this agent is that eventually they go too fast and it's hard to slow them down again: what code could you add to keep the speed in check?

### Using noise

#### Sketch: **`drawnoise`** 

Agents move around the canvas leaving a trail based on noise.

* Perlin noise (run GD `M_1_4_01` to visualize noise function)

See also GD **M.1.5**, p. 335, and these code examples:
* `M_1_4_01`: creates a terrain like mesh based on noise values.
* `M_1_5_02_TOOL`:  noise values (noise 2d) are used to animate a bunch of agents


### Exercise

Create your own drawing agent using the sketch `agentstarter`. This code has the basic shell for an agent-based drawing program, but all agents currently are initialized at the centre of the canvas and they don't move (look carefully, there's a small black dot at the centre). 


##### 1. Add code to  to create kinematic drawing rules.

A simple drawing rule is to move to a random position nearby. Try adding the code below to `Agent.update()`:

```java
  void update() {
    // save last position
    px = x;
    py = y;

    // pick a new position
    x = x + random(-param, param);
    y = y + random(-param, param);
  }
 ```

##### 2. Run your code and adjust the _param_ slider in the Gui to see what happens. 

Adjusting the param slider makes it more or less random. You should change the param variable and slider name to be something meaningful, like "maxStepSize".


##### 3. Add a parameter to change a global drawing property.

For example, add a global parameter for the opacity of the stroke.

Create a global variable like:

```java
float opacity = 20;
```

Add code to create a Gui slider in `setup` (the string must be exactly the same as the variable name for the Gui to automatically change the value):

```java
  gui.addSlider("opacity", 0, 255);
```

Then use the variable in your agent code. In this case, in `draw`:

```java
  void draw() {
    // draw a line between last position
    // and current position
    strokeWeight(1);
    stroke(0, opacity); // using global opacity variable
    line(px, py, x, y);
  }
```

##### 4. To add variety to your drawing, add a parameter to your agent class so not all agents are the same. 

For example, add a local variable to the Agent class to store the agent's shade (grey value):

```java 
class Agent {

  float shade; 

  ...
 ```

 In the Agent constructor, pick a shade randomly. For example, this picks black or white:

```java 
    // pick a random grey shade
    shade = 255 * int(random(0, 2));
```

Then use this shade when you draw the agent:

```java
  void draw() {
    // draw a line between last position
    // and current position
    strokeWeight(1);
    stroke(shade, opacity); // using agent's shade variable
    line(px, py, x, y);
  }
```


##### 5. To add even more variety with interactive control, add a parameter to control how each agent picks a local behaviour parameter. 

We can go one step further and create a global parameter that controls a range to pick an agent parameter. For example, picking a random stroke weight to be assigned to each agent. 

Create a global variable called `maxWeight` and add it to the Gui. Think about a reasonable range for stroke weights in your drawing (thick lines can be interesting, even 100 looks great).

Add a variable called `weight` to the Agent class, so each agent can keep track of its own weight.

Now assign a random stroke weight in the Agent constructor like this:

```java
    // pick random stroke weight
    weight = random(1, maxWeight);
```

Add code to use the chosen weight when you draw:

```java
  void draw() {
    // draw a line between last position
    // and current position
    strokeWeight(weight); // using agent's weight variable 
    stroke(shade, opacity);
    line(px, py, x, y);
  }
 ```


##### 6. Add code to initialize agent positions.

So far, all agents start in the centre, the pattern of starting positions can have a huge effect on the drawing. 

For example, the starting position could be decided randomly by each Agent like this:

```java
  Agent() {
    // random starting position
    int m = 100; // margin
    x = random(m, width - m);
    y = random(m, height - m);
  }
```

Or by using the `Agent(x, y)` constructor, agents could be initialized in a grid by changing the `createAgents` function like this:

```java
void createAgents() {
  background(255);
  // create Agents in a centred starting grid
  agents = new ArrayList<Agent>();
  for (float x = 100; x < width - 100; x += 5)
    for (float y = 100; y < height - 100; y += 5) {
      Agent a = new Agent(x, y);
      agents.add(a);
    }
}
```

Or you could even spawn new agents as you draw a line, like this:

```java
void mouseDragged() {
  Agent a = new Agent(mouseX, mouseY);
  agents.add(a);
}
```

The ideas above are just a starting point. You could combine different initialization methods together, add more rules to control agent based on grid location, mouse speed, a noise function, what position the last agent had, etc.



##### 7. Experiment with more parameters or drawing rules.

 Some ideas:

* add a rule that always pulls the agent in one direction (like all agents are pulled slowly downward)
* insert scale and rotate transforms, and make their arguments a global parameter or something different for each agent
* add a rule where agents track the mouse in some way (like `gridshapes`)
* add a rule that lets agent's interact (like the code in `drawlines`)
* change how (or what) an agent draws, it could be bezier curves, ellipses, or multiple lines. Even 3D shapes or meshes.
* use an image, SVG shape, or mouse movement as a seed for agent movements. Give each agent access to the thing you want them to use as guidance, and they can (slightly) conform their movements to that shape, or their colour to the underlying pixel values, etc. 
* use the kinds of input we talked about for A1 to initialize or control your agents
* create a family of Agent classes that work together to create a drawing. Some agents could make highlights, some could be rectangular and others curvy, some could even insert text.

# Extras 

## Using Agents in Physical Simulations

The general idea of agent behaviour can be extended well beyond random or noise based decisions. 

### Attractors

* nodes and attractors
* forces
* tuning

See GD **M.4.0**, p. 392, and these code examples:
* `M_4_3_01_TOOL` a drawing tool using attractors
* `M_4_2_01` simple attractors

### Springs and Force-Directed Layout

See GD **M.6.1**, p. 436, and these code examples:
* `M_6_1_01` 200 nodes repel each other
* `M_6_1_03` nodes connected by springs


### Particle Systems

[Shiffman _Nature of Code_: Particle Systems](http://natureofcode.com/book/chapter-4-particle-systems/)

> You may need to add the line `import java.util.Iterator;` to the top of some sketches from this book since they were written for an older version of Processing.

### Genetic Algorithms

[Shiffman _Nature of Code_: The Evolution of Code](http://natureofcode.com/book/chapter-9-the-evolution-of-code/)

## Generative Output in 3D 

See GD **M.3.0**, p. 370, and these code examples:
* `M_3_2_04` generating different 3D meshes from formulas
* `M_3_3_0*` Mesh class demos
* `M_3_4_01_TOOL` interactive control of 3D mesh parameters 


# Exercise

Continue to iterate the drawing agent you started in the exercise above, and post three generated images (just static PNG images) that demonstrate the range of forms possible using your rules and parameter settings.


<!-- # References and Resources

* [Generative Design Book](http://www.generative-gestaltung.de/)
*  -->



 




