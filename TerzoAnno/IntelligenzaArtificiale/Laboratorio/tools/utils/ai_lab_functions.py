from collections import deque
import heapq
import numpy as np
import matplotlib.pyplot as plt


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


class CheckResult_L1A1():

    def __init__(self, student_ts_sol, student_gs_sol, env):
        # student_ts_sol is a list where student_ts_sol[0] = solution_ts, student_ts_sol[1] = time_ts, student_ts_sol[2] = memory_ts
        # same fore the graph search solutions
        self.student_ts_sol = student_ts_sol
        self.student_gs_sol = student_gs_sol
        self.env = env

    def check_sol_ts(self):
        print(bcolors.OKCYAN + '##########################################' + bcolors.ENDC)
        print(bcolors.OKCYAN + '#######  BFS TREE SEARCH PROBLEM  ########' + bcolors.ENDC)
        print(bcolors.OKCYAN + '##########################################'+ bcolors.ENDC)


        print("Solution: {}".format(solution_2_string(self.student_ts_sol[0], self.env)))
        print("N° of nodes explored: {}".format(self.student_ts_sol[1]))
        print("Max n° of nodes in memory: {}\n".format(self.student_ts_sol[2]))

        if solution_2_string(self.student_ts_sol[0], self.env) != [(0, 1), (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
            print(bcolors.FAIL + "> The solution is not correct, should be: \n[(0, 1), (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
        elif self.student_ts_sol[1] != 103723:
            print(bcolors.FAIL + "> The number of node explored is not correct, should be: 103723\n" + bcolors.ENDC)
        elif self.student_ts_sol[2] != 77791:
            print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 77791\n" + bcolors.ENDC)
        #else:
        #    print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)


    def check_sol_gs(self):
        print(bcolors.OKCYAN + '##########################################' + bcolors.ENDC)
        print(bcolors.OKCYAN + '#######  BFS Graph SEARCH PROBLEM  #######' + bcolors.ENDC)
        print(bcolors.OKCYAN + '##########################################'+ bcolors.ENDC)

        print("Your solution: {}".format(solution_2_string(self.student_gs_sol[0], self.env)))
        print("N° of nodes explored: {}".format(self.student_gs_sol[1]))
        print("Max n° of nodes in memory: {}\n".format(self.student_gs_sol[2]))

        if solution_2_string(self.student_gs_sol[0], self.env) != [(0, 1), (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
            print(bcolors.FAIL + "> The solution is not correct, should be: \n[(0, 1), (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
        elif self.student_gs_sol[1] != 59:
            print(bcolors.FAIL + "> The number of node explored is not correct, should be: 59\n" + bcolors.ENDC)
        elif self.student_gs_sol[2] != 15:
            print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 15\n" + bcolors.ENDC)
        else:
            print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)


class CheckResult_L1A2():
    def __init__(self, student_ts_sol, env):
       
        # student_ts_sol is a list where student_ts_sol[0] = solution_ts, student_ts_sol[1] = time_ts, student_ts_sol[2] = memory_ts, student_ts_sol[3] = iterations_ts
        # same fore the graph search solutions
        self.student_ts_sol = student_ts_sol
        self.env = env

    def check_sol_ts(self):
        print(bcolors.OKCYAN + '##########################################' + bcolors.ENDC)
        print(bcolors.OKCYAN + '#######  IDS TREE SEARCH PROBLEM  ########' + bcolors.ENDC)
        print(bcolors.OKCYAN + '##########################################'+ bcolors.ENDC)

        print("Necessary Iterations: {}".format(self.student_ts_sol[3]))
        print("Your solution: {}".format(solution_2_string(self.student_ts_sol[0], self.env)))
        print("N° of nodes explored: {}".format(self.student_ts_sol[1]))
        print("Max n° of nodes in memory: {}\n".format(self.student_ts_sol[2]))

        if self.student_ts_sol[3] != 9:
            print(bcolors.FAIL + "> Your necessary iterations are not correct, should be: 9\n" + bcolors.ENDC)
        elif solution_2_string(self.student_ts_sol[0], self.env) != [(0, 1), (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
            print(bcolors.FAIL + "> Your solution is not correct, should be: \n[(0, 1), (0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
        elif self.student_ts_sol[1] != 138298:
            print(bcolors.FAIL + "> The number of node explored is not correct, should be: 138298\n" + bcolors.ENDC)
        elif self.student_ts_sol[2] != 9:
            print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 9\n" + bcolors.ENDC)
        else:
            print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)


def CheckResult_UCS(solution, time, memory, env):
    print()  
    print(bcolors.OKCYAN + '##########################################' + bcolors.ENDC)
    print(bcolors.OKCYAN + '#####  UNIFORM GRAPH SEARCH PROBLEM  #####' + bcolors.ENDC)
    print(bcolors.OKCYAN + '##########################################'+ bcolors.ENDC)
    print("Solution: {}".format(solution_2_string(solution, env)))
    print("N° of nodes explored: {}".format(time))
    print("Max n° of nodes in memory: {}".format(memory))



class CheckResult_L2A1():

    def __init__(self, student_ts_sol, student_gs_sol, heuristic, env):
        # student_ts_sol is a list where student_ts_sol[0] = solution_ts, student_ts_sol[1] = time_ts, student_ts_sol[2] = memory_ts
        # same fore the graph search solutions
        self.student_ts_sol = student_ts_sol
        self.student_gs_sol = student_gs_sol
        self.heuristic = heuristic
        self.env = env

    def check_sol_ts(self):
        print(bcolors.OKCYAN + '########################################################' + bcolors.ENDC)
        print(bcolors.OKCYAN + '#######  GREEDY BEST FIRST TREE SEARCH PROBLEM  ########' + bcolors.ENDC)
        print(bcolors.OKCYAN + '########################################################'+ bcolors.ENDC)


        print("Your solution: {}".format(solution_2_string(self.student_ts_sol[0], self.env)))
        print("N° of nodes explored: {}".format(self.student_ts_sol[1]))
        print("Max n° of nodes in memory: {}\n".format(self.student_ts_sol[2]))

        if self.heuristic == 'l1_norm':
            if solution_2_string(self.student_ts_sol[0], self.env) != 'time-out':
                print(bcolors.FAIL + "> Your solution is not correct!\n" + bcolors.ENDC)
            elif self.student_ts_sol[1] != 10001:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 10001\n" + bcolors.ENDC)
            elif self.student_ts_sol[2] != 7501:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 7501\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)

        elif self.heuristic == 'l2_norm':
            if solution_2_string(self.student_ts_sol[0], self.env) != 'time-out':
                print(bcolors.FAIL + "> Your solution is not correct!\n" + bcolors.ENDC)
            elif self.student_ts_sol[1] != 10001:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 10001\n" + bcolors.ENDC)
            elif self.student_ts_sol[2] != 7501:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 7501\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)

        elif self.heuristic == 'chebyshev':
            if solution_2_string(self.student_ts_sol[0], self.env) != 'time-out':
                print(bcolors.FAIL + "> Your solution is not correct!\n" + bcolors.ENDC)
            elif self.student_ts_sol[1] != 10001:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 10001\n" + bcolors.ENDC)
            elif self.student_ts_sol[2] != 7501:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 7501\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)

        else: 
            print(bcolors.FAIL + f"> The heuristic '{self.heuristic}' does not exist!" + bcolors.ENDC)

    def check_sol_gs(self):
        print(bcolors.OKCYAN + '########################################################' + bcolors.ENDC)
        print(bcolors.OKCYAN + '#######  GREEDY BEST FIRST GRAPH SEARCH PROBLEM  #######' + bcolors.ENDC)
        print(bcolors.OKCYAN + '########################################################'+ bcolors.ENDC)


        print("Your solution: {}".format(solution_2_string(self.student_gs_sol[0], self.env)))
        print("N° of nodes explored: {}".format(self.student_gs_sol[1]))
        print("Max n° of nodes in memory: {}\n".format(self.student_gs_sol[2]))

        if self.heuristic == 'l1_norm':
            if solution_2_string(self.student_gs_sol[0], self.env) != [(0, 3), (1, 3), (2, 3), (2, 2), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
                print(bcolors.FAIL + "> Your solution is not correct, should be: [(0, 3), (1, 3), (2, 3), (2, 2), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
            elif self.student_gs_sol[1] != 45:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 45\n" + bcolors.ENDC)
            elif self.student_gs_sol[2] != 15:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 15\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)
        
        elif self.heuristic == 'l2_norm':
            if solution_2_string(self.student_gs_sol[0], self.env) != [(0, 3), (1, 3), (2, 3), (2, 2), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
                print(bcolors.FAIL + "> Your solution is not correct, should be: [(0, 3), (1, 3), (2, 3), (2, 2), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
            elif self.student_gs_sol[1] != 45:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 45\n" + bcolors.ENDC)
            elif self.student_gs_sol[2] != 15:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 15\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)

        elif self.heuristic == 'chebyshev':
            if solution_2_string(self.student_gs_sol[0], self.env) != [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
                print(bcolors.FAIL + "> Your solution is not correct, should be: [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
            elif self.student_gs_sol[1] != 53:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 53\n" + bcolors.ENDC)
            elif self.student_gs_sol[2] != 16:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 16\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)

        else:
            print(bcolors.FAIL + f"> The heuristic '{self.heuristic}' does not exist!" + bcolors.ENDC)

class CheckResult_L2A2():

    def __init__(self, student_ts_sol, student_gs_sol, heuristic, env):
        # student_ts_sol is a list where student_ts_sol[0] = solution_ts, student_ts_sol[1] = time_ts, student_ts_sol[2] = memory_ts
        # same fore the graph search solutions
        self.student_ts_sol = student_ts_sol
        self.student_gs_sol = student_gs_sol
        self.heuristic = heuristic
        self.env = env

    def check_sol_ts(self):
        print(bcolors.OKCYAN + '#########################################' + bcolors.ENDC)
        print(bcolors.OKCYAN + '#######  A* TREE SEARCH PROBLEM  ########' + bcolors.ENDC)
        print(bcolors.OKCYAN + '#########################################'+ bcolors.ENDC)


        print("Your solution: {}".format(solution_2_string(self.student_ts_sol[0], self.env)))
        print("N° of nodes explored: {}".format(self.student_ts_sol[1]))
        print("Max n° of nodes in memory: {}\n".format(self.student_ts_sol[2]))

        if self.heuristic == 'l1_norm':
            if solution_2_string(self.student_ts_sol[0], self.env) != [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
                print(bcolors.FAIL + "> Your solution is not correct, should be: [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
            elif self.student_ts_sol[1] != 8361:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 8361\n" + bcolors.ENDC)
            elif self.student_ts_sol[2] != 6271:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 6271\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)
        
        elif self.heuristic == 'l2_norm':
            if solution_2_string(self.student_ts_sol[0], self.env) != [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
                print(bcolors.FAIL + "> Your solution is not correct, should be: [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
            elif self.student_ts_sol[1] != 8801:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 8801\n" + bcolors.ENDC)
            elif self.student_ts_sol[2] != 6601:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 6601\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)

        elif self.heuristic == 'chebyshev':
            if solution_2_string(self.student_ts_sol[0], self.env) != [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
                print(bcolors.FAIL + "> Your solution is not correct!\n" + bcolors.ENDC)
            elif self.student_ts_sol[1] != 16977:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 16977\n" + bcolors.ENDC)
            elif self.student_ts_sol[2] != 12733:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 12733\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)

        else:
            print(bcolors.FAIL + f"> The heuristic '{self.heuristic}' does not exist!" + bcolors.ENDC)


    def check_sol_gs(self):
        print(bcolors.OKCYAN + '##########################################' + bcolors.ENDC)
        print(bcolors.OKCYAN + '#######  A* GRAPH SEARCH PROBLEM  ########' + bcolors.ENDC)
        print(bcolors.OKCYAN + '##########################################'+ bcolors.ENDC)


        print("Your solution: {}".format(solution_2_string(self.student_gs_sol[0], self.env)))
        print("N° of nodes explored: {}".format(self.student_gs_sol[1]))
        print("Max n° of nodes in memory: {}\n".format(self.student_gs_sol[2]))

        if self.heuristic == 'l1_norm':
            if solution_2_string(self.student_gs_sol[0], self.env) != [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
                print(bcolors.FAIL + "> Your solution is not correct, should be: [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
            elif self.student_gs_sol[1] != 61:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 61\n" + bcolors.ENDC)
            elif self.student_gs_sol[2] != 16:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 16\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)

        elif self.heuristic == 'l2_norm':
            if solution_2_string(self.student_gs_sol[0], self.env) != [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
                print(bcolors.FAIL + "> Your solution is not correct, should be: [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
            elif self.student_gs_sol[1] != 61:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 61\n" + bcolors.ENDC)
            elif self.student_gs_sol[2] != 16:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 16\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)

        elif self.heuristic == 'chebyshev':
            if solution_2_string(self.student_gs_sol[0], self.env) != [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]:
                print(bcolors.FAIL + "> Your solution is not correct, should be: [(0, 1), (1, 1), (2, 1), (2, 0), (3, 0), (4, 0), (4, 1), (4, 2), (4, 3)]\n" + bcolors.ENDC)
            elif self.student_gs_sol[1] != 61:
                print(bcolors.FAIL + "> The number of node explored is not correct, should be: 61\n" + bcolors.ENDC)
            elif self.student_gs_sol[2] != 16:
                print(bcolors.FAIL + "> The max number of nodes in memory is not correct, should be: 16\n" + bcolors.ENDC)
            else:
                print(bcolors.BOLD + bcolors.OKGREEN + '===> Your solution is correct!\n'+ bcolors.ENDC)
        else:
            print(bcolors.FAIL + f"> The heuristic '{self.heuristic}' does not exist!" + bcolors.ENDC)



class CheckResult_L3():

    def __init__(self, env_name, policy_render):
        self.env_name = env_name
        self.policy = policy_render
    
    def check_value_iteration(self):
        print()
        print(bcolors.OKCYAN +  '#################################################################' + bcolors.ENDC)
        print(bcolors.OKCYAN + f'#######  Environment: {self.env_name} \tValue Iteration  ########' + bcolors.ENDC)
        print(bcolors.OKCYAN +  '#################################################################'+ bcolors.ENDC)
        print()

        if self.env_name == 'LavaFloor-v0':
            sol = np.array([['D', 'L', 'L', 'U'], ['D', 'L', 'L', 'L'], ['R', 'R', 'R', 'L']])
            
        elif self.env_name == 'HugeLavaFloor-v0':
            sol = np.array([['D','D','L','L','L','U','R','D','L','L'], ['D','D','L','L','L','L','R','D','L','L'], ['D','L','U','L','U','D','L','D','U','D'], ['D','L','L','L','U','L','L','D','L','D'], ['D','L','D','L','U','L','L','D','D','L'], ['D','L','U','L','L','L','L','D','D','U'], ['D','L','L','R','D','R','R','D','L','L'], ['R','D','D','D','L','L','R','D','D','D'], ['U','R','R','R','D','D','R','R','R','D'], ['L','R','R','R','R','R','R','R','R','L']])
        elif self.env_name == 'NiceLavaFloor-v0':
            sol = np.array([['L', 'L', 'L', 'U'],['L', 'L', 'L', 'L'],['L', 'L', 'L', 'L']])

        elif self.env_name == 'VeryBadLavaFloor-v0':
            sol = np.array([['R', 'R', 'R', 'D'],['D', 'L', 'R', 'L'],['R', 'R', 'R', 'L']])
            

        if not np.all(self.policy==sol):
            print(bcolors.FAIL + f"> Your policy\n {self.policy} is not optimal!\n\nOur policy is:\n {sol}" + bcolors.ENDC)
        else:
            print(bcolors.BOLD + bcolors.OKGREEN + f'===> Your solution is correct!\n\nPolicy:\n{self.policy}'+ bcolors.ENDC)


    def check_policy_iteration(self):
        print()
        print(bcolors.OKCYAN +  '##################################################################' + bcolors.ENDC)
        print(bcolors.OKCYAN + f'#######  Environment: {self.env_name} \tPolicy Iteration  ########' + bcolors.ENDC)
        print(bcolors.OKCYAN +  '##################################################################'+ bcolors.ENDC)
        print()

        if self.env_name == 'LavaFloor-v0':
            sol = np.array([['D', 'L', 'L', 'U'], ['D', 'L', 'L', 'L'], ['R', 'R', 'R', 'L']])
            
        elif self.env_name == 'HugeLavaFloor-v0':
            sol = np.array([['D','D','L','L','L','U','R','D','L','L'], ['D','D','L','L','L','L','R','D','L','L'], ['D','L','U','L','U','D','L','D','U','D'], ['D','L','L','L','U','L','L','D','L','D'], ['D','L','D','L','U','L','L','D','D','L'], ['D','L','U','L','L','L','L','D','D','U'], ['D','L','L','R','D','R','R','D','L','L'], ['R','D','D','D','L','L','R','D','D','D'], ['U','R','R','R','D','D','R','R','R','D'], ['L','R','R','R','R','R','R','R','R','L']])
        
        elif self.env_name == 'NiceLavaFloor-v0':
            sol = np.array([['D', 'L', 'D', 'U'],['D', 'L', 'L', 'L'],['R', 'R', 'L', 'L']])

        elif self.env_name == 'VeryBadLavaFloor-v0':
            sol = np.array([['R', 'R', 'R', 'D'], ['D', 'L', 'R', 'L'],['R', 'R', 'R', 'L']])
            

        if not np.all(self.policy==sol):
            print(bcolors.FAIL + f"> Your policy\n {self.policy} is not optimal!\n\nOur policy is:\n {sol}" + bcolors.ENDC)
        else:
            print(bcolors.BOLD + bcolors.OKGREEN + f'===> Your solution is correct!\n\nPolicy:\n{self.policy}'+ bcolors.ENDC)
            
class CheckResult_L5():

    def __init__(self, policy_render):
        self.policy = policy_render
    
    def check_qlearning(self):
        print()
        print(bcolors.OKCYAN +  '#####################################################' + bcolors.ENDC)
        print(bcolors.OKCYAN +  '#######  Environment: Cliff-v0 \tQ-Learning  #########' + bcolors.ENDC)
        print(bcolors.OKCYAN +  '#####################################################'+ bcolors.ENDC)
        print()

        
        sol = np.array([['D', 'U', 'D', 'R', 'D', 'R', 'D', 'D', 'L', 'D', 'D', 'D'],
                        ['D', 'U', 'R', 'R', 'R', 'U', 'D', 'R', 'D', 'R', 'R', 'D'],
                        ['R', 'R', 'R', 'R', 'R', 'R', 'R', 'R', 'R', 'R', 'R', 'D'],
                        ['U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U']])

        print(bcolors.BOLD + bcolors.OKGREEN + f'===> Your policy:\n\n{self.policy}'+ bcolors.ENDC)
        print()
        print(bcolors.BOLD + bcolors.OKGREEN + f'===> Our policy:\n\n{sol}'+ bcolors.ENDC)


    def check_sarsa(self):
        print()
        print(bcolors.OKCYAN +  '################################################' + bcolors.ENDC)
        print(bcolors.OKCYAN +  '#######  Environment: Cliff-v0 \tSARSA  #########' + bcolors.ENDC)
        print(bcolors.OKCYAN +  '################################################'+ bcolors.ENDC)
        print()

        sol = np.array([['R', 'R', 'R', 'R', 'R', 'R', 'R', 'R', 'R', 'R', 'R', 'D'],
                        ['U', 'U', 'L', 'U', 'U', 'U', 'R', 'R', 'U', 'U', 'R', 'D'],
                        ['U', 'U', 'L', 'U', 'R', 'R', 'L', 'R', 'U', 'U', 'R', 'D'],
                        ['U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U']])          
        
        print(bcolors.BOLD + bcolors.OKGREEN + f'===> Your policy:\n\n{self.policy}'+ bcolors.ENDC)
        print()
        print(bcolors.BOLD + bcolors.OKGREEN + f'===> Our policy:\n\n{sol}'+ bcolors.ENDC)            