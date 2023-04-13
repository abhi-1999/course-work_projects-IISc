import gym
import numpy as np
import torch
import torch.nn as nn
import matplotlib.pyplot as plt
from torch.optim import Adam
from torch.distributions import Categorical
from collections import namedtuple

import create_env_atrpo

import pickle
import gzip
#env = gym.make('CartPole-v0')
env = gym.make('CartPoleATRPO-v2')
env.spec.max_episode_steps = 1000
env.spec.reward_threshold = 1000.0

state_size = env.observation_space.shape[0]
num_actions = env.action_space.n

Rollout = namedtuple('Rollout', ['states', 'actions', 'rewards', 'next_states', ])
avg_rew_list = []

def do_evaluation(long=False):
    actor.eval()
    eval_env = None
    if long:
        eval_env = gym.make('CartPoleATRPO-v3')
        eval_env.spec.max_episode_steps = 5000
        eval_env.spec.reward_threshold = 5000.0
    else:
        eval_env = gym.make('CartPoleATRPO-v2')
        eval_env.spec.max_episode_steps = 1000
        eval_env.spec.reward_threshold = 1000.0
    print('Evaluating')
    rollout_rew = []
    for t in range(5):
        state = eval_env.reset()
        done = False

        samples = []
        while not done:
            if t % 5 == 0:
                eval_env.render()

            with torch.no_grad():
                action = get_action(state, deterministic=True)

                next_state, reward, done, _ = eval_env.step(action)

                # Collect samples
                samples.append((state, action, reward, next_state))

                state = next_state

        # Transpose our samples
        states, actions, rewards, next_states = zip(*samples)

        rollout_rew.append(sum(rewards))
    eval_env.close()
    actor.train()
    return np.mean(rollout_rew)


'''def do_evaluation():
    actor.eval()
    eval_env = gym.make('CartPoleATRPO-v2')
    eval_env.spec.max_episode_steps = 1000
    eval_env.spec.reward_threshold = 1000.0
    print('Evaluating')
    rollout_rew = []
    for t in range(5):
        state = eval_env.reset()
        done = False

        samples = []
        while not done:
            if t % 5 == 0:
                eval_env.render()

            with torch.no_grad():
                action = get_action(state, deterministic=True)

                next_state, reward, done, _ = eval_env.step(action)

                # Collect samples
                samples.append((state, action, reward, next_state))

                state = next_state

        # Transpose our samples
        states, actions, rewards, next_states = zip(*samples)

        rollout_rew.append(sum(rewards))
    eval_env.close()
    actor.train()
    return np.mean(rollout_rew)
'''


mean_total_rewards = []
def train(epochs=100, num_rollouts=10, render_frequency=None):
    global_rollout = 0

    for epoch in range(epochs):
        rollouts = []
        rollout_total_rewards = []

        if (epoch+1) % 10 == 0:
            avg_rew_list.append(do_evaluation())
            # pass

        for t in range(num_rollouts):
            state = env.reset()
            done = False

            samples = []
            ep_len = 0


            while True:
                if len(samples) == 1000:
                    break
                if done:
                    if len(samples) < 1000:
                        state = env.reset()
                        ed_samples = list(samples[-1])
                        ed_samples[2] = -100
                        samples[-1] = tuple(ed_samples)
                    else:
                        break

                #ep_len += 1

                if render_frequency is not None and global_rollout % render_frequency == 0:
                    env.render()

                with torch.no_grad():
                    action = get_action(state)

                next_state, reward, done, _ = env.step(action)

                # Collect samples
                samples.append((state, action, reward, next_state))

                state = next_state

            # Transpose our samples
            states, actions, rewards, next_states = zip(*samples)

            states = torch.stack([torch.from_numpy(state) for state in states], dim=0).float()
            next_states = torch.stack([torch.from_numpy(state) for state in next_states], dim=0).float()
            actions = torch.as_tensor(actions).unsqueeze(1)
            rewards = torch.as_tensor(rewards).unsqueeze(1)

            rollouts.append(Rollout(states, actions, rewards, next_states))

            rollout_total_rewards.append(rewards.sum().item())
            global_rollout += 1

        update_agent(rollouts)
        mtr = np.mean(rollout_total_rewards)
        print(f'E: {epoch}.\tMean total reward across {num_rollouts} rollouts: {mtr}')

        mean_total_rewards.append(mtr)

    plt.plot(mean_total_rewards)
    plt.figure()
    plt.plot(avg_rew_list)
    #plt.show()


actor_hidden = 32
actor = nn.Sequential(nn.Linear(state_size, actor_hidden),
                      nn.ReLU(),
                      nn.Linear(actor_hidden, num_actions),
                      nn.Softmax(dim=1))


def get_action(state, deterministic=False):
    state = torch.tensor(state).float().unsqueeze(0)  # Turn state into a batch with a single element
    if deterministic:
        action_probab = actor(state)  # Create a distribution from probabilities for actions
        return torch.argmax(action_probab).item()
    else:
        dist = Categorical(actor(state))  # Create a distribution from probabilities for actions
        return dist.sample().item()

# Critic takes a state and returns its values
critic_hidden = 32
critic = nn.Sequential(nn.Linear(state_size, critic_hidden),
                       nn.ReLU(),
                       nn.Linear(critic_hidden, 1))
critic_optimizer = Adam(critic.parameters(), lr=0.005)


def update_critic(advantages):
    loss = (advantages ** 2).mean()  # MSE
    critic_optimizer.zero_grad()
    loss.backward()
    critic_optimizer.step()


# delta, maximum KL divergence
max_d_kl = 0.01


def update_agent(rollouts):
    states = torch.cat([r.states for r in rollouts], dim=0)
    actions = torch.cat([r.actions for r in rollouts], dim=0).flatten()

    advantages = [estimate_advantages(states, next_states[-1], rewards) for states, _, rewards, next_states in rollouts]
    advantages = torch.cat(advantages, dim=0).flatten()

    # Normalize advantages to reduce skewness and improve convergence
    advantages = (advantages - advantages.mean()) / advantages.std()

    update_critic(advantages)

    distribution = actor(states)
    distribution = torch.distributions.utils.clamp_probs(distribution)
    probabilities = distribution[range(distribution.shape[0]), actions]

    # Now we have all the data we need for the algorithm

    # We will calculate the gradient wrt to the new probabilities (surrogate function),
    # so second probabilities should be treated as a constant
    L = surrogate_loss(probabilities, probabilities.detach(), advantages)
    KL = kl_div(distribution, distribution)

    parameters = list(actor.parameters())

    g = flat_grad(L, parameters, retain_graph=True)
    d_kl = flat_grad(KL, parameters, create_graph=True)  # Create graph, because we will call backward() on it (for HVP)

    def HVP(v):
        return flat_grad(d_kl @ v, parameters, retain_graph=True)

    search_dir = conjugate_gradient(HVP, g)
    max_length = torch.sqrt(2 * max_d_kl / (search_dir @ HVP(search_dir)))
    max_step = max_length * search_dir

    def criterion(step):
        apply_update(step)

        with torch.no_grad():
            distribution_new = actor(states)
            distribution_new = torch.distributions.utils.clamp_probs(distribution_new)
            probabilities_new = distribution_new[range(distribution_new.shape[0]), actions]

            L_new = surrogate_loss(probabilities_new, probabilities, advantages)
            KL_new = kl_div(distribution, distribution_new)

        L_improvement = L_new - L

        if L_improvement > 0 and KL_new <= max_d_kl:
            return True

        apply_update(-step)
        return False

    i = 0
    while not criterion((0.9 ** i) * max_step) and i < 10:
        i += 1


def estimate_advantages(states, last_state, rewards):
    values = critic(states)
    last_value = critic(last_state.unsqueeze(0))
    next_values = torch.zeros_like(rewards)
    rho = rewards.numpy().mean()
    # print(len(rewards))
    for i in reversed(range(rewards.shape[0])):
        #if i == rewards.shape[0] - 1:
        #    next_values[i] = next_values[i] + val*(rewards[i] + last_value - next_values[i])
        #else:
        #    next_values[i] = next_values[i] + val*(rewards[i] + next_values[i+1] - next_values[i])
        #if i == rewards.shape[0] - 1:
        #    next_values[i] = rewards[i] - rho + last_value
        #else:
        #    next_values[i] = rewards[i] - rho + values[i+1]

        last_value = next_values[i] = rewards[i] + last_value - rho
    advantages = next_values - values
    return advantages


def surrogate_loss(new_probabilities, old_probabilities, advantages):
    return (new_probabilities / old_probabilities * advantages).mean()


def kl_div(p, q):
    p = p.detach()
    return (p * (p.log() - q.log())).sum(-1).mean()


def flat_grad(y, x, retain_graph=False, create_graph=False):
    if create_graph:
        retain_graph = True

    g = torch.autograd.grad(y, x, retain_graph=retain_graph, create_graph=create_graph)
    g = torch.cat([t.view(-1) for t in g])
    return g


def conjugate_gradient(A, b, delta=0., max_iterations=10):
    x = torch.zeros_like(b)
    r = b.clone()
    p = b.clone()

    i = 0
    while i < max_iterations:
        AVP = A(p)

        dot_old = r @ r
        alpha = dot_old / (p @ AVP)

        x_new = x + alpha * p

        if (x - x_new).norm() <= delta:
            return x_new

        i += 1
        r = r - alpha * AVP

        beta = (r @ r) / dot_old
        p = r + beta * p

        x = x_new
    return x


def apply_update(grad_flattened):
    n = 0
    for p in actor.parameters():
        numel = p.numel()
        g = grad_flattened[n:n + numel].view(p.shape)
        p.data += g
        n += numel



# Train our agent
train(epochs=250, num_rollouts=10, render_frequency=500)
torch.save(actor.state_dict(), 'actor_ATRPO_1000.zip')

with gzip.open('rewards_eval_1000_atrpo.gzip', 'wb') as f:
        pickle.dump(np.copy(avg_rew_list), f)
avg_rew_list = []

for i in range(20):
    avg_rew_list.append(do_evaluation(long=True))

plt.figure()
plt.plot(avg_rew_list)
plt.show()


with gzip.open('rewards_eval_5000_atrpo.gzip', 'wb') as f:
        pickle.dump(np.copy(avg_rew_list), f)

with gzip.open('rewards_train_atrpo.gzip', 'wb') as f:
        pickle.dump(np.copy(mean_total_rewards), f)
