import io
import sys
import numpy as np
from gym import spaces
from gym.utils import seeding
from gym import Env


class ObsGrid(Env):

    metadata = {'render.modes': ['human']}

    def __init__(self, actions, grid, actdyn, rewards):
        """
        Creates an istance of the grid environment

        Args:
            actions: available actions
            grid: maze environment grid
            actdyn: dynamics of available actions
            rewards: state rewards
        """
        # Store info
        self.actions = actions
        self.rows, self.cols = np.shape(grid)
        self.shape = (self.rows, self.cols)
        self.grid = np.asarray(grid).flatten()
        self.startstate = np.argwhere(self.grid == "S")[0, 0]
        self.goalstate = np.argwhere(self.grid == "G")[0, 0]
        self.action_space = spaces.Discrete(len(self.actions))
        self.observation_space = spaces.Discrete(len(self.grid))
        self.staterange = range(self.observation_space.n)  # For random sampling actions from a given distribution
        # Precompute transition function T(s, a, s') and reward function R(s, a, s')
        self.T = np.zeros((self.observation_space.n, self.action_space.n, self.observation_space.n))
        self.R = np.zeros((self.observation_space.n, self.action_space.n, self.observation_space.n))
        self.RS = np.zeros((self.observation_space.n))
        for s in range(self.observation_space.n):
            # If this is an end state, the agent stays there without additional rewards
            if self.grid[s] == "W":
                continue
            if self.grid[s] == "G" or self.grid[s] == "P":
                self.T[s, :, s] = 1.0
                continue

            x, y = self.state_to_pos(s)
            for a in range(self.action_space.n):
                if self.grid[s] != "C":
                    # If the state is not "C", the action succeeds with probability 1
                    nx, ny = x, y
                    if a == 0:  # Left
                        ny = max(0, y - 1)
                    elif a == 1:  # Right
                        ny = min(self.cols - 1, y + 1)
                    elif a == 2:  # Up
                        nx = max(0, x - 1)
                    elif a == 3:  # Down
                        nx = min(self.rows - 1, x + 1)
                    ns = self.pos_to_state(nx, ny)
                    if self.grid[ns] == "W":
                        self.T[s, a, s] = 1.0
                        self.R[s, a, s] = rewards[self.grid[s]]
                        self.RS[s] = rewards[self.grid[s]]
                    else:
                        self.T[s, a, ns] = 1.0
                        self.R[s, a, ns] = rewards[self.grid[ns]]
                        self.RS[s] = rewards[self.grid[s]]
                else:
                    # Use action dynamics for "C" cells
                    for d in actdyn[a]:
                        nx, ny = x, y
                        if d == 0:
                            ny = max(0, y - 1)
                        elif d == 1:
                            ny = min(self.cols - 1, y + 1)
                        elif d == 2:
                            nx = max(0, x - 1)
                        else:
                            nx = min(self.rows - 1, x + 1)
                        stp = self.pos_to_state(nx, ny)
                        if self.grid[stp] == "W":
                            self.T[s, a, s] += actdyn[a][d]
                            self.R[s, a, s] = rewards[self.grid[s]]
                            self.RS[s] = rewards[self.grid[s]]
                        else:
                            ns = self.pos_to_state(nx, ny)
                            self.T[s, a, ns] += actdyn[a][d]
                            self.R[s, a, ns] = rewards[self.grid[ns]]
                            self.RS[s] = rewards[self.grid[s]]
                # Normalize probability values over the state space
                self.T[s, a, :] /= np.sum(self.T[s, a, :])


        
        for s in range(self.observation_space.n):
            if self.grid[s] == "P": self.RS[s] = rewards["P"]
            if self.grid[s] == "G": self.RS[s] = rewards["G"]
        
        self.reward_range = self.R.min(), self.R.max()
        self.np_random = None
        self.currstate = None
        self.done = False
        #self.RS = (self.R.min(axis=1).min(axis=0))
        #self.RS[-1] = 1
        self.seed(1)
        self.reset()

    def is_terminal(self, state):
        if self.grid[state] == "G" or self.grid[state] == "R":
            return True
        return False

    def seed(self, seed=None):
        self.np_random, seed = seeding.np_random(seed)
        return [seed]

    def reset(self):
        self.currstate = self.startstate
        self.done = False
        return self.currstate

    def step(self, action):
        """
        Performs a step from the current state executing ``action``

        Args:
            action: action to execute

        Returns:
            (observation, reward, done, info)
        """
        if self.done:
            return None
        ns = self.sample(self.currstate, action)
        r = self.R[self.currstate, action, ns]
        self.currstate = ns
        if self.grid[ns] == "G" or self.grid[ns] == "P" or self.grid[ns] == "R":
            self.done = True
            return ns, r, True, None
        return ns, r, False, None

    def pos_to_state(self, x, y):
        """
        Returns the state given its position in x and y coordinates

        Args:
            x: x coordinate
            y: y coordinate

        Returns:
            state
        """
        return x * self.cols + y

    def state_to_pos(self, state):
        """
        Returns the coordinates x and y of a state

        Args:
            state: state

        Returns:
            state coordinates (x, y)
        """
        return divmod(state, self.cols)

    def sample(self, state, action):
        """
        Returns a new state sampled from the ones that can be reached from ``state`` executing ``action``

        Args:
            state: state from which to execute ``action``
            action: action to execute

        Returns:
            reached state
        """
        return self.np_random.choice(self.staterange, p=self.T[state, action])

    def render(self, mode='human'):
        outfile = io.StringIO() if mode == 'ansi' else sys.stdout
        outfile.write(np.array_str(self.grid.reshape(self.rows, self.cols)) + "\n")
