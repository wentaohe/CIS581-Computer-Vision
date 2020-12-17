
# coding: utf-8

# In[4]:


import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt


# In[5]:


training = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
labels = np.array([[0], [1], [1], [0]])

training = training.reshape(2, -1)
labels = labels.reshape(1, -1)


# In[6]:


num_input = 2
hidden_size = 2
num_class = 1
learning_rate = 0.1
iterations = 10000
display_step = 1

x = tf.placeholder(tf.float32, [num_input, None])
y = tf.placeholder(tf.float32, [num_class, None])


# In[7]:


w_fc1 = tf.get_variable('w_fc1', [hidden_size, num_input])
b_fc1 = tf.get_variable('b_fc1', [hidden_size, 1])

w_fc2 = tf.get_variable('w_fc2', [1, 2])
b_fc2 = tf.get_variable('b_fc2', [1, 1])


# In[8]:


def net(x):
    fc_1 = tf.tanh(tf.add(tf.matmul(w_fc1, x), b_fc1))
    fc_2 = tf.add(tf.matmul(w_fc2, fc_1), b_fc2)

    return fc_2


# In[7]:


def forward(x, w, b, labels):

    return loss, output


# In[8]:


def backward(x, w, b, output, labels):
    learning_rate = 0.1
    z = (np.dot(x, [w_11, w_12]) + np.array([[b11], [b12]])).squeeze()

    dl_dy = (output - labels) / (output * (1 - output))
    dy_da =

    dy_dw2 = np.tanh(z)
    dy_db2 = np.ones(output.shape)

    dl_dw2 = np.dot(dy_dw2.T, dl_dy)
    dl_db2 = np.dot(dy_db2.T, dl_dy)

    dy_dz1 = w_2[0] * (1 - np.square(np.tanh(z[:, 0])))
    dy_dz2 = w_2[1] * (1 - np.square(np.tanh(z[:, 1])))
    dz1_dw11 = x
    dz1_db1 = 1
    dz2_dw12 = x
    dz2_db2 = 1

    d

    dl_dw = np.dot(dl_dy.T, dy_dw)
    dl_db = np.dot(dl_dy.T, dy_db)

    w = w - learning_rate * dl_dw
    b = b - learning_rate * dl_db
    return w, b


# In[97]:


z = (np.dot(x, [w_11, w_12]) + np.array([[b11], [b12]])).squeeze()
dy_dz1 = w_2[0] * (1 - np.square(np.tanh(z[:, 0])))


# In[9]:


logits = net(x)
prediction = tf.sigmoid(logits)

loss = tf.losses.sigmoid_cross_entropy(y, logits)
opt = tf.train.GradientDescentOptimizer(learning_rate=learning_rate)
train_opt = opt.minimize(loss)


# In[10]:


correct_pred = tf.cast(tf.greater_equal(prediction, 0.5), tf.float32)
correct_pred = tf.equal(correct_pred, y)
accuracy = tf.reduce_mean(tf.cast(correct_pred, tf.float32))


# In[11]:


y_loss = []
y_acc = []
itr = []
w_2 = []


# In[12]:


with tf.Session() as sess:
    # Initialize variables
    init = tf.global_variables_initializer()
    # Run initializer
    sess.run(init)
    for step in range(1, iterations + 1):
        # Run optimization
        sess.run(train_opt, feed_dict={x: training, y: labels})
        if (step == 1) or (step % display_step == 0):
            lo, acc, w2 = sess.run([loss, accuracy, w_fc2], feed_dict={
                                   x: training, y: labels})
            if acc == 1:
                break
            y_loss.append(lo)
            y_acc.append(acc)
            w_2.append(w2)
            itr.append(step - 1)


# In[46]:


x = np.linspace(-100., 100.)

fig, ax = plt.subplots()
for w2 in w_2:
    A, B = w2[0, 0], w2[0, 1]
    ax.plot(x, A * x + B)

ax.set_xlim((-100., 100.))
ax.set_ylim((-100., 100.))
plt.show()


# In[14]:


fig = plt.figure()
ax1 = fig.add_subplot(211)
plt.plot(itr, y_acc, 'b')
ax1.set_xlabel('iteration')
ax1.set_ylabel('loss')


# In[15]:


y_acc
