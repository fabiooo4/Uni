from envs.obsgrid_env import ObsGrid


class SmallMazeEnv(ObsGrid):
    """
    Small fully observable maze environment with deterministic actions
    """
    def __init__(self):
        actions = {0: "L", 1: "R", 2: "U", 3: "D"}
        grid = [
            ["C", "C", "S", "C"],
            ["C", "C", "W", "C"],
            ["C", "C", "C", "C"],
            ["C", "W", "W", "W"],
            ["C", "C", "C", "G"]
        ]
        rewards = {"C": 0, "S": 0, "G": 1}
        actdyn = {0: {0: 1.0}, 1: {1: 1.0}, 2: {2: 1.0}, 3: {3: 1.0}}
        super().__init__(actions, grid, actdyn, rewards)


class GrdMazeEnv(ObsGrid):
    """
    Small fully observable maze environment with deterministic actions where greedy search is optimal and expands less
    states than A*
    """
    def __init__(self):
        actions = {0: "L", 1: "R", 2: "U", 3: "D"}
        grid = [
            ["C", "C", "C", "S"],
            ["C", "C", "W", "C"],
            ["C", "C", "C", "C"],
            ["C", "W", "W", "W"],
            ["C", "C", "C", "G"]
        ]
        rewards = {"C": 0, "S": 0, "G": 1}
        actdyn = {0: {0: 1.0}, 1: {1: 1.0}, 2: {2: 1.0}, 3: {3: 1.0}}
        super().__init__(actions, grid, actdyn, rewards)


class BlockedMazeEnv(ObsGrid):
    """
    Small fully observable maze environment with deterministic actions where a solution does not exist
    """
    def __init__(self):
        actions = {0: "L", 1: "R", 2: "U", 3: "D"}
        grid = [
            ["C", "C", "S", "C"],
            ["C", "C", "W", "C"],
            ["C", "C", "C", "C"],
            ["C", "C", "W", "W"],
            ["C", "C", "W", "G"]
        ]
        rewards = {"C": 0, "S": 0, "G": 1}
        actdyn = {0: {0: 1.0}, 1: {1: 1.0}, 2: {2: 1.0}, 3: {3: 1.0}}
        super().__init__(actions, grid, actdyn, rewards)
