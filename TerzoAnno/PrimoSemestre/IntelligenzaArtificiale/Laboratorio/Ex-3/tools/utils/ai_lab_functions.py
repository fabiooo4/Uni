from collections import deque
import heapq
import numpy as np
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image



class Node:
    def __init__(self, state, parent=None, pathcost=0, value=0):
        if parent == None:
            self.depthcost = 0
        else:
            self.depthcost = parent.depthcost + 1

        self.state = state
        self.pathcost = pathcost
        self.value = value
        self.parent = parent
        self.removed = False

    def __hash__(self):
        return int(self.state)

    def __lt__(self, other):
        return self.value < other.value


class NodeQueue():
    
    def __init__(self):
        self.queue = deque()
        self.node_dict = {}
        self.que_len = 0

    def is_empty(self):
        return (self.que_len == 0)

    def add(self, node):
        self.node_dict[node.state] = node
        self.queue.append(node)
        self.que_len += 1

    def remove(self):
        while True:
            n = self.queue.popleft()
            if not n.removed:
                if n.state in self.node_dict:
                    del self.node_dict[n.state]
                self.que_len -= 1
                return n

    def __len__(self):
        return self.que_len

    def __contains__(self, item):
        return item in self.node_dict

    def __getitem__(self, i):
        return self.node_dict[i]


class PriorityQueue():
    def __init__(self):
        self.fringe = []
        self.frdict = {} 
        self.frlen = 0

    def is_empty(self):
        return self.frlen == 0

    def add(self, n):
        heapq.heappush(self.fringe, n)
        self.frdict[n.state] = n
        self.frlen += 1

    def remove(self):
        while True:
            n = heapq.heappop(self.fringe)
            if not n.removed:
                if n.state in self.frdict:
                    del self.frdict[n.state]
                self.frlen -= 1
                return n

    def replace(self, n):
        self.frdict[n.state].removed = True
        self.frdict[n.state] = n
        self.frlen -= 1
        self.add(n)

    def __len__(self):
        return self.frlen

    def __contains__(self, item):
        return item in self.frdict

    def __getitem__(self, i):
        return self.frdict[i]


class Heu():
    @staticmethod
    def l1_norm(p1, p2):
        return np.sum(np.abs(np.asarray(p1) - np.asarray(p2)))

    @staticmethod
    def l2_norm(p1, p2):
        return np.linalg.norm((np.asarray(p1) - np.asarray(p2)))

    @staticmethod
    def chebyshev(p1, p2):
        return np.max(np.abs(np.asarray(p1) - np.asarray(p2)))


def build_path(node):
    path = []
    while node.parent is not None:
        path.append(node.state)
        node = node.parent
    return tuple(reversed(path))


def solution_2_string(sol, env):
    if( not isinstance(sol, tuple) ):
        return sol

    if sol is not None:
        solution = [env.state_to_pos(s) for s in sol]
    return solution


def zero_to_infinity():
    i = 0
    while True:
        yield i
        i += 1

def run_episode(environment, policy, limit):
    obs = environment.reset()
    done = False
    reward = 0
    s = 0
    while not done and s < limit:
        obs, r, done, _ = environment.step(policy[obs])
        reward += r
        s += 1
    return reward

def plot(series, title, xlabel, ylabel):
        plt.figure(figsize=(13, 6))
        for s in series:
            plt.plot(s["x"], s["y"], label=s["label"])
        plt.xlabel(xlabel)
        plt.ylabel(ylabel)
        plt.title(title)
        plt.legend()
        plt.show()

        
def values_to_policy(U, env):
    p = [0 for _ in range(env.observation_space.n)]
    
    for state in range(env.observation_space.n):
        max_array = [0 for _ in range(env.action_space.n)]
        for action in range(env.action_space.n):
            for next_state in range(env.observation_space.n):
                max_array[action] += env.T[state, action, next_state] * U[next_state]
                
        max_array = np.round(max_array, 6)
        winners = np.argwhere(max_array == np.amax(max_array)).flatten()
        win_action = winners[0]#np.random.choice(winners)
        p[state] = win_action
                
    return np.asarray(p)


def rolling(a, window):
    shape = a.shape[:-1] + (a.shape[-1] - window + 1, window)
    strides = a.strides + (a.strides[-1],)
    return np.mean(np.lib.stride_tricks.as_strided(a, shape=shape, strides=strides), -1)


def plot_policy(policy, name_env='ex3_render'):

    # Load the background image
    image_path = f'images/{name_env}.png'
    background_image = Image.open(image_path)

    # Create a plot
    fig, ax = plt.subplots(figsize=(10, 10))

    # Display the background image with alpha
    ax.imshow(background_image, extent=[0, 10, 0, 10], alpha=0.5)

    # Define arrow directions
    directions = {'D': (0, -0.2), 'U': (0, 0.2), 'L': (-0.2, 0), 'R': (0.2, 0)}

    # Plot the arrows
    for i in range(policy.shape[0]):
        for j in range(policy.shape[1]):
            direction = policy[i, j]
            dx, dy = directions[direction]
            ax.arrow(j + 0.5, 9.5 - i, dx, dy, head_width=0.1, head_length=0.1, fc='red', ec='red')


    plt.show()

def check_sol(policy):
    solution = np.array([['D', 'L', 'R', 'R', 'D', 'D', 'D', 'D', 'D', 'D'],
                        ['D', 'D', 'D', 'R', 'R', 'R', 'R', 'D', 'D', 'L'],
                        ['R', 'R', 'D', 'D', 'D', 'R', 'R', 'D', 'D', 'L'],
                        ['D', 'D', 'D', 'R', 'R', 'D', 'R', 'D', 'D', 'L'],
                        ['R', 'D', 'D', 'L', 'R', 'R', 'R', 'R', 'D', 'L'],
                        ['R', 'D', 'D', 'D', 'D', 'D', 'D', 'R', 'D', 'L'],
                        ['D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D', 'D'],
                        ['D', 'D', 'D', 'D', 'L', 'R', 'R', 'R', 'D', 'L'],
                        ['R', 'R', 'R', 'D', 'D', 'D', 'D', 'D', 'D', 'L'],
                        ['U', 'U', 'R', 'R', 'R', 'R', 'R', 'L', 'L', 'L']])

    if not np.all(policy == solution):
        print(bcolors.FAIL + "Your solution is not correct")
    else:
        print(bcolors.BOLD + bcolors.OKGREEN + 'Your solution is correct!\n'+ bcolors.ENDC)

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

