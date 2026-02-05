"""
OpenAI Gym environments designed for the AI lab course
"""

from gym.envs.registration import register
from envs.aquatic_env import *

register(
    id='AquaticEnv-v0',
    entry_point='envs:AquaticEnv')