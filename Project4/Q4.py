
# coding: utf-8

# In[84]:


import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt


# In[85]:


img = np.load('datasets/line/line_imgs.npy')
labels = np.load('datasets/line/line_labs.npy')

img = img.reshape((-1, 16, 16, 1)).astype('float32')
labels = labels.reshape((-1, 1)).astype('float32')


# In[52]:


img = np.load('datasets/detection/detection_imgs.npy')
labels = np.load('datasets/detection/detection_labs.npy')

img = img.reshape((-1, 16, 16, 1)).astype('float32')
labels = labels.reshape((-1, 1)).astype('float32')


# In[53]:


labels.shape


# In[86]:


plt.imshow(img[1, :, :, 0], cmap='gray')
plt.show()


# In[149]:


img = tf.cast(img, tf.float32)
labels = tf.cast(labels, tf.float32)
#train_bat, label_bat = tf.train.batch([img,labels],64)


# In[9]:


# convolutional layer
def layers(x, hidden_num, kernel_size, stride):
  #channels = 1
  W = tf.get_variable('weights', [kernel_size, kernel_size, 1, hidden_num],
                      initializer=tf.initializers.random_normal(0, 0.1))  # hidden_num = number of filter
  x = tf.get_variable('bias', [1, 1, 1, hidden_num],
                      initializer=tf.constant_initializer(1.0))
  x = tf.nn.conv2d(x, W, strides=[1, stride, stride, 1], padding='same')
  x = tf.nn.relu(x)


# In[10]:


def conv2d(x, W, b, strides=1):
  x = tf.nn.conv2d(x, W, strides=[1, strides, strides, 1], padding='SAME')
  x = tf.nn.bias_add(x, b)
  # print('x',x.shape)
  return tf.nn.relu(x)


# In[11]:


def maxpool2d(x, k=2):
  return tf.nn.max_pool(x, kisize=[1, k, k, 1], strides=[1, k, k, 1], padding='SAME')


# In[105]:


tf.reset_default_graph()
# weights['wd1'].get_shape().as_list()[0]


# In[106]:


with tf.variable_scope('paras', reuse=tf.AUTO_REUSE):
  init = tf.random_normal_initializer(0., 0.1)
  weights = {
      'wc1': tf.get_variable('W0', shape=(7, 7, 1, 16), initializer=init),
      'wc2': tf.get_variable('W1', shape=(7, 7, 16, 8), initializer=init),
      'wd1': tf.get_variable('W2', shape=(16 * 16 * 8, 1), initializer=init),
      'wd2': tf.get_variable('W3', shape=(16 * 16 * 8, 1), initializer=init)
  }
  init = tf.constant_initializer(0.1)
  bias = {
      'bc1': tf.get_variable('b0', shape=(16), initializer=init),
      'bc2': tf.get_variable('b1', shape=(8), initializer=init),
      'bc3': tf.get_variable('b2', shape=(1), initializer=init),
      'bc4': tf.get_variable('b3', shape=(1), initializer=init)
  }


# In[107]:


x = tf.placeholder("float32", [64, 16, 16, 1])
y = tf.placeholder("float32", [64, 1])


# In[108]:


def conv_net(x, weights, bias):
  conv1 = conv2d(x, weights['wc1'], bias['bc1'])

  conv2 = conv2d(conv1, weights['wc2'], bias['bc2'])

  fc1 = tf.reshape(conv2, [conv2.shape[0], -1])
  fc1 = tf.add(tf.matmul(fc1, weights['wd1']), bias['bc3'])

  fc2 = tf.reshape(conv2, [fc1.shape[0], -1])
  fc2 = tf.add(tf.matmul(fc2, weights['wd2']), bias['bc4'])
  return fc1, fc2


# In[109]:


output_1, output_2 = conv_net(x, weights, bias)

y_hat_1 = tf.sigmoid(output_1)
y_hat_2 = tf.sigmoid(output_2)

pred_1 = tf.cast(tf.greater_equal(y_hat_1, 0.5), tf.float32)
pred_2 = tf.cast(tf.greater_equal(y_hat_2, 0.5), tf.float32)

cost_1 = tf.reduce_mean(tf.losses.sigmoid_cross_entropy(y, output_1))
cost_2 = tf.reduce_mean(tf.nn.l2_loss((labels - y_hat_2)))

optimizer_1 = tf.train.GradientDescentOptimizer(
    learning_rate=0.01).minimize(cost_1)
optimizer_2 = tf.train.GradientDescentOptimizer(
    learning_rate=0.001).minimize(cost_2)


# In[110]:


pred_2


# In[111]:


correct_prediction_1 = tf.equal(pred_1, y)
correct_prediction_2 = tf.equal(pred_2, y)

accuracy_1 = tf.reduce_mean(tf.cast(correct_prediction_1, tf.float32))
accuracy_2 = tf.reduce_mean(tf.cast(correct_prediction_2, tf.float32))


# In[112]:


with tf.Session() as sess:
  global_init = tf.global_variables_initializer()
  sess.run(global_init)
  train_loss_1 = []
  train_loss_2 = []
  train_accuracy_1 = []
  train_accuracy_2 = []
  itr = []

  for i in range(10000):
    tt = sess.run(pred_1, feed_dict={x: img, y: labels})
    opt = sess.run(optimizer_1, feed_dict={x: img, y: labels})
    # print(tt)
    loss, acc = sess.run([cost_1, accuracy_1], feed_dict={x: img, y: labels})
    train_loss_1.append(loss)
    train_accuracy_1.append(acc)
    itr.append(i)
    #print('iter ',i,'accu ',acc,'loss ',loss)
    if acc == 1.0:
      break


# In[82]:


ee = tf.Variable(2, name='x', dtype=tf.float32)
log_x = tf.log(ee)
log_x_squared = tf.square(log_x)

optimizer = tf.train.GradientDescentOptimizer(0.5)
train = optimizer.minimize(log_x_squared)

init = tf.global_variables_initializer()


def optimize():

  with tf.Session() as session:
    session.run(init)
    print("starting at", "x:", session.run(ee),
          "log(x)^2:", session.run(log_x_squared))
    for step in range(10):
      session.run(train)
      pred_1.eval()
      print("step", step, "x:", session.run(ee),
            "log(x)^2:", session.run(log_x_squared))


# In[128]:


optimize()


# In[113]:


fig = plt.figure()
ax1 = fig.add_subplot(211)
plt.plot(itr, train_loss_1, 'b')
ax1.set_xlabel('iteration')
ax1.set_ylabel('loss')

fig = plt.figure()
ax1 = fig.add_subplot(211)
plt.plot(itr, train_accuracy_1, 'b')
ax1.set_xlabel('iteration')
ax1.set_ylabel('accuracy')
