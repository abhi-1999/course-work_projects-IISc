from gym.envs.registration import load_env_plugins as _load_env_plugins
from gym.envs.registration import make, register, registry, spec

# Hook to load plugins from entry points
_load_env_plugins()


# Classic
# ----------------------------------------

register(
    id="CartPoleATRPO-v2",
    entry_point="gym.envs.classic_control.cartpole:CartPoleEnv",
    max_episode_steps=1000,
    reward_threshold=1000.0,
)

register(
    id="CartPoleATRPO-v3",
    entry_point="gym.envs.classic_control.cartpole:CartPoleEnv",
    max_episode_steps=5000,
    reward_threshold=5000.0,
)
