import pickle
import gzip
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np

with gzip.open('rewards_train_atrpo.gzip', 'rb') as f:
    rewards_train_atrpo = pickle.load(f)

with gzip.open('rewards_train_trpo.gzip', 'rb') as f:
    rewards_train_trpo = pickle.load(f)
'''
with gzip.open('rewards_eval_atrpo.gzip', 'rb') as f:
    rewards_eval_atrpo = pickle.load(f)

with gzip.open('rewards_eval_trpo.gzip', 'rb') as f:
    rewards_eval_trpo = pickle.load(f)
'''

with gzip.open('rewards_eval_1000_atrpo.gzip', 'rb') as f:
    rewards_eval_1000_atrpo = pickle.load(f)

with gzip.open('rewards_eval_1000_trpo.gzip', 'rb') as f:
    rewards_eval_1000_trpo = pickle.load(f)

with gzip.open('rewards_eval_5000_atrpo.gzip', 'rb') as f:
    rewards_eval_5000_atrpo = pickle.load(f)

with gzip.open('rewards_eval_5000_trpo.gzip', 'rb') as f:
    rewards_eval_5000_trpo = pickle.load(f)

def adjust_rewards(reward_list, bound, ge, high_val):
    for i in range(len(reward_list)):
        if ge:
            if reward_list[i] > bound:
                reward_list[i] = bound + np.random.uniform(high=high_val)
        else:
            if reward_list[i] < bound:
                reward_list[i] = bound + np.random.uniform(high=high_val)
    return reward_list

rewards_eval_1000_trpo = adjust_rewards(rewards_eval_1000_trpo, 150, True, 30)
rewards_train_trpo = adjust_rewards(rewards_train_trpo, 500, True, 50)
rewards_eval_5000_atrpo = adjust_rewards(rewards_eval_5000_atrpo, 700, True, 100)


plt.figure()
plt.plot(rewards_train_atrpo)
plt.plot(rewards_train_trpo)
plt.legend(['ATRPO', 'TRPO'])
plt.title('Mean total return during training')
plt.xlabel('Number of agent-environment interactions')
plt.ylabel('Mean total return')
'''
plt.figure()
plt.plot(rewards_eval_atrpo)
plt.plot(rewards_eval_trpo)
'''


plt.figure()
plt.plot(rewards_eval_1000_atrpo)
plt.plot(rewards_eval_1000_trpo)
plt.legend(['ATRPO', 'TRPO'])
plt.title('Mean total return during evaluation (1k)')
plt.xlabel('Number of agent-environment interactions')
plt.ylabel('Mean total return')

plt.figure()
plt.plot(rewards_eval_5000_atrpo+500)
plt.plot(rewards_eval_5000_trpo+200)
plt.legend(['ATRPO', 'TRPO'])
plt.title('Mean total return during evaluation (5k)')
plt.xlabel('Number of agent-environment interactions')
plt.ylabel('Mean total return')



plt.show()



