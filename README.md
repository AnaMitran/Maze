# Maze
Escaping a maze using Verilog

The challenge posed by the "maze" problem is finding the exit, located on the outline of the maze. I know for sure that I start from a free position and that there are 3 walls around me, so I will have only one way out of them. In order to orient myself further, I use the Wall Follower algorithm, which means making sure that I always have a wall on my right (or left). This method guarantees that regardless of the appearance of the bottlenecks and the resumption of some steps, I will finally be able to find the way out of the labyrinth.

The implementation cannot be of the brute force type by traversing the entire matrix corresponding to the labyrinth and cannot retain more than the indices of the current position. The scenario is similar to the movement of a visually impaired person. I have to touch the wall on the right to know for sure that it is there and I will hit my head on the wall that I assumed was a free lane. Which reminds me of Minesweeper where I had to create a strategy to discover the cells around me without detonating a bomb. And in the case of this game, I went from close to close, in order to reach the goal.

![image](https://user-images.githubusercontent.com/89164540/156737960-e4333ddc-2f0b-488b-b258-8c09dfa9d11c.png)

Initially in the maze, the script looks similar to:

![image](https://user-images.githubusercontent.com/89164540/157997870-bce2bdbb-0bed-43e8-a3a2-d6294e46a2b8.png)


My first task is to find the exit between the 3 walls.
How do I do that? I am guided by the compass, that is, by the cardinal points (N, V, S, E) and I always remember the direction in which I moved.

Knowing the coordinates of the starting point, I will be able to determine the new position in which I moved, according to the X direction, as I increment or decrement the row or column as follows:

![image](https://user-images.githubusercontent.com/89164540/157997881-a72f2842-bc87-401c-87c3-4b3dd08abb63.png)


I can go in any direction, but for a good practice for the subsequent passage of the labyrinth I choose the next direction in trigonometric direction.

![image](https://user-images.githubusercontent.com/89164540/156738965-519bd825-10ef-4821-89d4-f1eef2d61f6f.png)

Why in a trigonometric sense? Because then, after coming out of the 3 walls, I prioritize checking the value on the right, ie the existence of the wall on the right. If I have a wall on the right, I'll check in front of me. If I have a wall in front of me, I check if I can go out to the left and only then do I discover that I have a wall and not a corridor, I go back to where I came from, because it is a dead end.

To check what is on the right, I choose the direction before the direction of travel "forward".

![image](https://user-images.githubusercontent.com/89164540/157997908-d4c70533-602d-490c-8ea0-371e199a3f1a.png)


The black arrows indicate the direction of travel. Every time I discover a wall, I return to the back position, that is, in the reverse direction of travel. Yellow arrows indicate the trigonometric direction of the next direction (S - E - N - W).
To go back I use the rules of changing the coordinates, presented above and I do not actually change the direction, except in trigonometric direction or I choose the previous direction to check the wall on the right.
If I don't have the wall on my right, it means that I passed a corner of the labyrinth. However, this case is similar to the situation of the exit between the first 3 walls.

![image](https://user-images.githubusercontent.com/89164540/157997921-f371be59-a32f-455e-8eda-967402416639.png)


Implementation logic:

![image](https://user-images.githubusercontent.com/89164540/157997935-e3d79856-9d11-495b-9ef2-69209918ebaf.png)


The deterministic finite automaton is of the Moore type (exit on status - I always find useful information or I can make changes to the maze only at the next step = the next rising clockwise front). The circuit is of synchronous sequential type, with combinational part of data processing / setting. 

The module has the following structure:

![image](https://user-images.githubusercontent.com/89164540/157997948-284d8ddc-1f22-42a4-a100-97b7347e586b.png)

In each state, they can change either maze_we for maze writing or maze_oe for maze reading.

**set**: start state, save the coordinates of the starting point, set an initial direction of travel and allow marking the path in the maze by maze_we = 1
**update**: modify the coordinates of the position indicated by the previously chosen direction and allow the reading of the registration value in this position by maze_oe = 1
**check**: I can check the value of my position (in maze_in), if I discovered:
- a wall (maze_in = 1), I return to the previous position and I will move to the next direction in trigonometric direction
- a corridor (maze_in = 0), I allow the marking of the road, I check if I have not reached the exit, I am on the contour of the labyrinth and I will change the direction in the previous one to check if I have a wall on the right

It goes from the update state to the check and vice versa as long as I did not find the way out of the maze (done = 1).

I noticed that only these states are enough both to find the exit between the three walls and to orient myself through the labyrinth, as they use the same logic of updating and verifying the data.
