
# coding: utf-8

# In[1]:


import numpy as np
import matplotlib.pyplot as plt


# In[7]:


imgs = np.load('datasets/random/random_imgs.npy')
labels = np.load('datasets/random/random_labs.npy').reshape((64, -1))


# In[9]:


w.shape


# In[37]:


def forward(sample, w, b, labels):
    inter = np.dot(w, sample).reshape((64, 1)) + \
        np.repeat(b, 64).reshape((64, 1))
    #output = 1/(1+np.exp(-inter))
    out = max(0, inter)
    #loss = -labels*np.log2(output) - (1-labels)*np.log2(1-output)
    loss = np.square(labels - output)
    return loss, output


# In[33]:


def backward(sample, w, b, output, labels):
    inter = np.exp(-np.dot(w, sample).reshape((64, 1)) -
                   np.repeat(b, 64).reshape((64, 1)))
    learning_rate = 0.1

    dl_dy = (output - labels) / (output * (1 - output))
    dy_dw = inter * sample.squeeze() / np.square(1 + inter)
    dy_db = inter / np.square(1 + inter)
    dl_dw = np.dot(dl_dy.T, dy_dw)
    dl_db = np.dot(dl_dy.T, dy_db)

    # print(dl_db.shape)
    w = w - learning_rate * dl_dw
    b = b - learning_rate * dl_db
    return w, b


# In[5]:


def train(sample, labels, w, b):
    loss, output = forward(sample, w, b, labels)
    w, b = backward(sample, w, b, output, labels)
    output[output >= 0.5] = 1
    output[output < 0.5] = 0
    accuracy = sum(output == labels) / labels.shape[0]
    return loss, accuracy, w, b


# In[42]:


sample = imgs.reshape((64, 16, 1))
w = np.random.normal(0, 0.1, (1, 16))
b = np.random.normal(0, 0.1)
max_iter = 10000
loss = []
accuracy = []
for i in range(max_iter):
    # print(i)
    loss_, accuracy_, w, b = train(sample, labels, w, b)
    loss.append(loss_)
    accuracy.append(accuracy_)
    if accuracy_ == 1.0:
        print(i)
        break


# In[105]:


inter = np.exp(-np.dot(w, sample).reshape((64, 1)) -
               np.repeat(b, 64).reshape((64, 1)))


# In[12]:


sample = imgs.reshape((64, 16, 1))
w = np.random.normal(0, 0.1, (1, 16))
b = np.random.normal(0, 0.1)
a = -np.dot(w, sample).reshape((64, 1)) - np.repeat(b, 64).reshape((64, 1))
b = 1 / (1 + np.exp(a))


# In[130]:


type(accuracy)


# In[43]:


plt.plot(range(i + 1), accuracy)
plt.show()


# In[44]:


plt.plot(range(i + 1), np.sum(loss, 1))
plt.show()
