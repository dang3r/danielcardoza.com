+++
tags = [
  "blog",
  "project",
]
title = "Adventures with Math Academy"
description = "Fun tidbits about Math Academy"
date = "2025-03-31"
+++

# Adventures with Math Academy

Last year, I learned about [MathAcademy.com](https://mathacademy.com/). It is a website that helps you learn math in a cooler way. Imagine you had a graph of all mathematical knowledge where the nodes are concepts and the edges represents prerequisites/dependencies. With that graph, if you learn a new concept you can determine what new ones to learn. Imagine creating a queue of new concepts to to learn by identifying adjacent child nodes to nodes whose concept you already know. Also, imagine the cool spaced repetition and other learning techniques you can apply by adding labels to a given node indicating when you last reviewed the concept and were proficient in it! Follow [Justin Skycak](https://github.com/dang3r/forge/blob/master/mathacademy/factoring.py) for more information. I love his blog.

### Rational Roots Theorem
I completed Mathematical Foundations II earlier in the year.  I won't dive into everything, one of my favourite fundamentals I relearned was the  [rational root theorem](https://en.wikipedia.org/wiki/Rational_root_theorem) and what it meant. It, along with synthetic division and factoring let you determine the roots for any polynomial with rational roots! I think I was exposed to the RRT in high school but not synthetic division. Combining those (with factoring), lets you make an algorithm for identifying roots!

The core of the algorithm is:
- Find the potential candidates for a polynomial using the constant and highest degree term (with non-zero coefficient). To do this you must factor both terms and generate a set of candidate roots using the RRT.
- Determine if a candidate root is a root calling the polynomial and seeing if f(x) == 0
- When you have a root, simplify the polynomial using `synthetic_division` . This will reduce the polynomials degree.
- if polynomial has degree >= 2, continue, else return all roots

I love revisiting the fundamentals and the gamification of Math Academy really helped me stick with it. I started Mathematical Foundations III but have taken a break to focus on a few other things. My rough code for doing the above is [here](https://github.com/dang3r/forge/blob/master/mathacademy/factoring.py).

### Additional Tooling
One of the coolest aspects of Math Academy is the Knowledge Graph. As you proceed through a course, I really wanted to see the graph and know how many new concepts are coming up. To do so, I identified the javascript file describing the Math Academy API, had Claude port it to Python and then had Claude generate some scripts for generating some graph visualizations. You can see all of that code on [Github](https://github.com/dang3r/forge/tree/master/mathacademy).

Below are some of the graphs I generated at different levels

### MFIII Incomplete Concepts Graph

![Incomplete](/images/math_academy_incomplete_knowledge_graph_1.png)

### MFIII Course Graph

![Course](/images/math_academy_knowledge_graph_1.png)

### MFIII Module Graph

![Module](/images/math_academy_module_knowledge_graph.png)


### MFIII Unit Graph

![Unit](/images/math_academy_unit_knowledge_graph.png)

