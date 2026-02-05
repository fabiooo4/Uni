from envs.obsgrid_env import ObsGrid


class AquaticEnv(ObsGrid):

    def __init__(self):
        actions = {0: "L", 1: "R", 2: "U", 3: "D"}
        #(O) Open Water: Normal movement; no additional challenges.  
        #(C) Currents: Areas where the drone's movement is influenced by ocean currents, potentially pushing it off course.  
        #(F) Seaweed Forests: Dense vegetation that slows the drone, incurring extra energy costs per move.    
        #(R) Rocky Areas: Impassable zones the drone must navigate around.  
        #(E) Energy Stations: Specific points where the drone can recharge its battery, adding a small reward to encourage efficient navigation.

        grid = [
           ["S", "O", "O", "F", "F", "C", "R", "R", "R", "R"],
           ["O", "R", "R", "C", "C", "C", "F", "E", "F", "F"],
           ["O", "O", "F", "C", "R", "C", "F", "F", "F", "F"],
           ["R", "R", "F", "C", "E", "C", "F", "O", "F", "R"],
           ["O", "F", "F", "C", "R", "C", "F", "O", "F", "R"],
           ["R", "E", "F", "R", "R", "O", "F", "C", "F", "R"],
           ["O", "F", "C", "C", "C", "O", "F", "C", "F", "C"],
           ["O", "F", "F", "F", "O", "O", "O", "F", "F", "C"],
           ["O", "O", "O", "O", "R", "R", "R", "R", "F", "R"],
           ["R", "R", "R", "O", "O", "O", "O", "G", "O", "F"]
        ]

        rewards = {"S": -0.01, "O": -0.01, "F": -0.1, "C": -0.04, "R": -10.0, "E": 0.1,  "G": 20.0}
        actdyn = {0: {0: 0.8, 1: 0.0, 2: 0.1, 3: 0.1}, 1: {1: 0.8, 0: 0.0, 2: 0.1, 3: 0.1}, 2: {2: 0.8, 1: 0.1, 0: 0.1,
                  3: 0.0}, 3: {3: 0.8, 1: 0.1, 2: 0.0, 0: 0.1}}
        super().__init__(actions, grid, actdyn, rewards)

