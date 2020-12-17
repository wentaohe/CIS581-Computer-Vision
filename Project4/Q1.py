
# coding: utf-8

# In[1]:


from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
import matplotlib.pyplot as plt
import numpy as np


# In[2]:


w = np.arange(-10, 10, 0.5)
b = np.arange(-10, 10, 0.5)
w, b = np.meshgrid(w, b)


def sig(w, b): return 1 / (np.exp(-w - b) + 1)


# In[24]:


z = 1 / (np.exp(-w - b) + 1)
fig = plt.figure()

ax = fig.gca(projection='3d')
ax.plot_surface(w, b, z, cmap=cm.coolwarm)
ax.set_xlabel('w')
ax.set_ylabel('b')
ax.set_zlabel('output')
plt.show()


# In[26]:


# L2 loss
z = np.square((0.5 - sig(w, b)))
fig1 = plt.figure()

ax1 = fig1.gca(projection='3d')
ax1.plot_surface(w, b, z, cmap=cm.coolwarm)
ax1.set_xlabel('w')
ax1.set_ylabel('b')
ax1.set_zlabel('output')
plt.show()


# In[19]:


# L2 derivative
dl2 = -2 * (0.5 - sig(w, b)) * np.square(sig(w, b)) * (np.exp(-w - b))
fig1 = plt.figure()

ax1 = fig1.gca(projection='3d')
ax1.plot_surface(w, b, dl2, cmap=cm.coolwarm)
ax1.set_xlabel('w')
ax1.set_ylabel('b')
plt.show()


# In[20]:


# cross entropy
lce = -0.5 * np.log2(sig(w, b)) - 0.5 * np.log2(1 - sig(w, b))
fig1 = plt.figure()

ax1 = fig1.gca(projection='3d')
ax1.plot_surface(w, b, lce, cmap=cm.coolwarm)
ax1.set_xlabel('w')
ax1.set_ylabel('b')
plt.show()


# In[4]:


# gradient of cross entropy
grad = -(0.5 * sig(w, b) * np.exp(-w - b) - 0.5 * 1 /
         (1 - sig(w, b)) * np.square(sig(w, b)) * np.exp(-w - b))
fig1 = plt.figure()

ax1 = fig1.gca(projection='3d')
ax1.plot_surface(w, b, grad, cmap=cm.coolwarm)
ax1.set_xlabel('w')
ax1.set_ylabel('b')
plt.show()
