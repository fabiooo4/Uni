import sys
import numpy as np
from gym.envs.toy_text import discrete


def categorical_sample(prob_n, np_random):
    """
    Sample from categorical distribution
    Each row specifies class probabilities
    """
    prob_n = np.asarray(prob_n)
    csprob_n = np.cumsum(prob_n)
    return (csprob_n > np_random.rand()).argmax()


class WindyGridworldEnv(discrete.DiscreteEnv):
    """
    Windy Gridworld implementation from Sutton and Barto.

    Standard gridworld, with start and goal states, but with one difference: there is a crosswind running upward
    through the middle of the grid. Available actions are U, R, D, L but in the middle region the resultant next states
    are shifted upward by a 'wind' the strength of which varies from column to column.

    Implementation guided by the CliffWalking environment of OpenAI Gym
    """
    metadata = {'render.modes': ['human']}

    def __init__(self):
        """
        Creates an istance of the windy gridworld environment
        """
        self.rows, self.cols = 7, 10
        self.shape = (self.rows, self.cols)
        self.startstate = np.ravel_multi_index((3, 0), self.shape)
        self.goalstate = np.ravel_multi_index((3, 7), self.shape)
        self.actions = {0: "U", 1: "R", 2: "D", 3: "L"}
        nS = self.rows * self.cols
        nA = len(self.actions)
        winds = np.zeros(self.shape)
        winds[:, (3, 4, 5, 8)] = 1
        winds[:, (6, 7)] = 2
        P = {}
        for s in range(nS):
            position = np.unravel_index(s, self.shape)
            P[s] = {a: [] for a in range(nA)}
            P[s][0] = self._calculate_transition_prob(position, [-1, 0], winds)
            P[s][1] = self._calculate_transition_prob(position, [0, 1], winds)
            P[s][2] = self._calculate_transition_prob(position, [1, 0], winds)
            P[s][3] = self._calculate_transition_prob(position, [0, -1], winds)
        isd = np.zeros(nS)
        isd[self.startstate] = 1.
        super().__init__(nS, nA, P, isd)

    def _limit_coordinates(self, coord):
        """
        Prevents the agent from falling out of the grid world

        Args:
            coord: coordinates tuple (x, y)

        Returns:
            (x, y) coordinates tuple limited to the grid
        """
        coord[0] = min(coord[0], self.shape[0] - 1)
        coord[0] = max(coord[0], 0)
        coord[1] = min(coord[1], self.shape[1] - 1)
        coord[1] = max(coord[1], 0)
        return coord

    def _calculate_transition_prob(self, current, delta, winds):
        """
        Calculate the transition tuples

        Args:
            current: current position (x, y)
            delta: change in position for the transition
            winds:wind strengths per cell

        Returns:
            (prob, new_state, reward, done): transition tuple for step
        """
        new_position = np.array(current) + np.array(delta) + np.array([-1, 0]) * winds[tuple(current)]
        new_position = self._limit_coordinates(new_position).astype(int)
        new_state = np.ravel_multi_index(tuple(new_position), self.shape)
        is_done = tuple(new_position) == (3, 7)
        return [(1., new_state, -1., is_done)]

    def state_to_pos(self, state):
        """
        Returns the coordinates x and y of a state

        Args:
            state: state

        Returns:
            state coordinates (x, y)
        """
        return divmod(state, self.shape[1])

    def pos_to_state(self, x, y):
        """
        Returns the state given its position in x and y coordinates

        Args:
            x: x coordinate
            y: y coordinate

        Returns:
            state
        """
        return x * self.shape[1] + y

    def sample(self, state, action):
        """
        Returns a new state sampled from the ones that can be reached from ``state`` executing ``action``

        Args:
            state: state from which to execute ``action``
            action: action to execute

        Returns:
            reached state
        """
        return self.P[state][action][categorical_sample([t[0] for t in self.P[state][action]], self.np_random)][1]

    def render(self, mode='human'):
        """
        Renders the environment

        Args:
            mode: rendering mode
        """
        outfile = sys.stdout
        for s in range(self.nS):
            position = np.unravel_index(s, self.shape)
            if self.s == s:
                output = " x "
            elif position == (3, 7):
                output = " T "
            else:
                output = " o "
            if position[1] == 0:
                output = output.lstrip()
            if position[1] == self.shape[1] - 1:
                output = output.rstrip()
                output += '\n'
            outfile.write(output)
        outfile.write('\n')
