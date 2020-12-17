import numpy as np

def affine_forward(x, w, b):
  """
  Computes the forward pass for an affine (fully-connected) layer.

  The input x has shape (N, d_1, ..., d_k) where x[i] is the ith input.
  We multiply this against a weight matrix of shape (D, M) where
  D = \prod_i d_i

  Inputs:
  x - Input data, of shape (N, d_1, ..., d_k)
  w - Weights, of shape (D, M)
  b - Biases, of shape (M,)

  Returns a tuple of:
  - out: output, of shape (N, M)
  - cache: (x, w, b)
  """
  out = None
  #############################################################################
  # TODO: Implement the affine forward pass. Store the result in out. You     #
  # will need to reshape the input into rows.                                 #
  #############################################################################
  x_flatten = x.reshape(x.shape[0], -1)
  N, D = x_flatten.shape

  x_flatten_cat = np.hstack((x_flatten, np.ones(shape=(N, 1))))
  w_b_cat = np.vstack((w, b.reshape(1, -1)))

  out = x_flatten_cat.dot(w_b_cat)

  #############################################################################
  #                             END OF YOUR CODE                              #
  #############################################################################
  cache = (x, w, b)
  return out, cache


def affine_backward(dout, cache):
  """
  Computes the backward pass for an affine layer.

  Inputs:
  - dout: Upstream derivative, of shape (N, M)
  - cache: Tuple of:
    - x: Input data, of shape (N, d_1, ... d_k)
    - w: Weights, of shape (D, M)

  Returns a tuple of:
  - dx: Gradient with respect to x, of shape (N, d1, ..., d_k)
  - dw: Gradient with respect to w, of shape (D, M)
  - db: Gradient with respect to b, of shape (M,)
  """
  x, w, b = cache
  dx, dw, db = None, None, None
  #############################################################################
  # TODO: Implement the affine backward pass.                                 #
  #############################################################################
  xshape = x.shape
  x_flatten = x.reshape(x.shape[0], -1)
  N, D = x_flatten.shape

  x_flatten_cat = np.hstack((x_flatten, np.ones(shape=(N, 1))))
  w_b_cat = np.vstack((w, b.reshape(1, -1)))

  dX = dout.dot(w_b_cat.T)
  dx = dX[:,:-1]
  dx = dx.reshape(xshape)

  dW = x_flatten_cat.T.dot(dout)
  dw = dW[:-1,:]
  db = dW[-1]
  #############################################################################
  #                             END OF YOUR CODE                              #
  #############################################################################
  return dx, dw, db


def relu_forward(x):
  """
  Computes the forward pass for a layer of rectified linear units (ReLUs).

  Input:
  - x: Inputs, of any shape

  Returns a tuple of:
  - out: Output, of the same shape as x
  - cache: x
  """
  out = None
  #############################################################################
  # TODO: Implement the ReLU forward pass.                                    #
  #############################################################################
  out = np.maximum(x, 0)
  #############################################################################
  #                             END OF YOUR CODE                              #
  #############################################################################
  cache = x
  return out, cache


def relu_backward(dout, cache):
  """
  Computes the backward pass for a layer of rectified linear units (ReLUs).

  Input:
  - dout: Upstream derivatives, of any shape
  - cache: Input x, of same shape as dout

  Returns:
  - dx: Gradient with respect to x
  """
  dx, x = None, cache
  #############################################################################
  # TODO: Implement the ReLU backward pass.                                   #
  #############################################################################
  dx = dout
  dx[x<=0] = 0
  #############################################################################
  #                             END OF YOUR CODE                              #
  #############################################################################
  return dx


def conv_forward_naive(x, w, b, conv_param):
  """
  A naive implementation of the forward pass for a convolutional layer.

  The input consists of N data points, each with C channels, height H and width
  W. We convolve each input with F different filters, where each filter spans
  all C channels and has height HH and width HH.

  Input:
  - x: Input data of shape (N, C, H, W)
  - w: Filter weights of shape (F, C, HH, WW)
  - b: Biases, of shape (F,)
  - conv_param: A dictionary with the following keys:
    - 'stride': The number of pixels between adjacent receptive fields in the
      horizontal and vertical directions.
    - 'pad': The number of pixels that will be used to zero-pad the input.

  Returns a tuple of:
  - out: Output data, of shape (N, F, H', W') where H' and W' are given by
    H' = 1 + (H + 2 * pad - HH) / stride
    W' = 1 + (W + 2 * pad - WW) / stride
  - cache: (x, w, b, conv_param)
  """
  out = None
  #############################################################################
  # TODO: Implement the convolutional forward pass.                           #
  # Hint: you can use the function np.pad for padding.                        #
  #############################################################################
  stride, pad = conv_param['stride'], conv_param['pad']
  N, C, H, W = x.shape
  F, _, HH, WW = w.shape
  H_out = int(1 + (H + 2 * pad - HH) / stride)
  W_out = int(1 + (W + 2 * pad - WW) / stride)

  x_padded = np.zeros(shape=(N, C, H+2*pad, W+2*pad))
  x_padded[:, :, pad:pad+H, pad:pad+W] = x

  out = np.zeros(shape=(N, F, H_out, W_out))

  half_HH = HH / 2
  half_WW = WW / 2

  for n_out in range(N):
    for f_out in range(F):
      for h_out in range(H_out):
        for w_out in range(W_out):
          x_padded_window = x_padded[n_out, :, stride*h_out:stride*h_out+HH, stride*w_out:stride*w_out+WW]
          kernel = w[f_out, :, :, :]
          out[n_out, f_out, h_out, w_out] = np.sum(np.multiply(x_padded_window, kernel)) + b[f_out]

  #############################################################################
  #                             END OF YOUR CODE                              #
  #############################################################################
  cache = (x, w, b, conv_param)
  return out, cache


def conv_backward_naive(dout, cache):
  """
  A naive implementation of the backward pass for a convolutional layer.

  Inputs:
  - dout: Upstream derivatives.
  - cache: A tuple of (x, w, b, conv_param) as in conv_forward_naive

  Returns a tuple of:
  - dx: Gradient with respect to x
  - dw: Gradient with respect to w
  - db: Gradient with respect to b
  """
  x, w, b, conv_param = cache
  dx, dw, db = None, None, None
  #############################################################################
  # TODO: Implement the convolutional backward pass.                          #
  #############################################################################
  stride, pad = conv_param['stride'], conv_param['pad']
  N, C, H, W = x.shape
  F, _, HH, WW = w.shape
  _, _, H_out, W_out = dout.shape

  x_padded = np.zeros(shape=(N, C, H+2*pad, W+2*pad))
  x_padded[:, :, pad:pad+H, pad:pad+W] = x

  dx_padded = np.zeros_like(x_padded)
  dw = np.zeros(shape=(F, C, HH, WW))
  db = np.zeros(shape=(F,))

  for n_out in range(N):
    for f_out in range(F):
      for h_out in range(H_out):
        for w_out in range(W_out):
          dx_padded[n_out, :, stride*h_out:stride*h_out+HH, stride*w_out:stride*w_out+WW] += dout[n_out, f_out, h_out, w_out] * w[f_out, :, :, :]
          dw[f_out, :, :, :] += dout[n_out, f_out, h_out, w_out] * x_padded[n_out, :, stride*h_out:stride*h_out+HH, stride*w_out:stride*w_out+WW]
          db[f_out] += dout[n_out, f_out, h_out, w_out]

  dx = dx_padded[:, :, pad:pad+H, pad:pad+W]

  #############################################################################
  #                             END OF YOUR CODE                              #
  #############################################################################
  return dx, dw, db


def max_pool_forward_naive(x, pool_param):
  """
  A naive implementation of the forward pass for a max pooling layer.

  Inputs:
  - x: Input data, of shape (N, C, H, W)
  - pool_param: dictionary with the following keys:
    - 'pool_height': The height of each pooling region
    - 'pool_width': The width of each pooling region
    - 'stride': The distance between adjacent pooling regions

  Returns a tuple of:
  - out: Output data
  - cache: (x, pool_param)
  """
  out = None
  #############################################################################
  # TODO: Implement the max pooling forward pass                              #
  #############################################################################
  pool_height, pool_width, stride = pool_param['pool_height'], pool_param['pool_width'], pool_param['stride']
  N, C, H, W = x.shape
  H_out = int(1 + (H-pool_height)/stride)
  W_out = int(1 + (W-pool_width)/stride)

  out = np.zeros(shape=(N, C, H_out, W_out))

  for n_out in range(N):
    for c_out in range(C):
      for h_out in range(H_out):
        for w_out in range(W_out):
          out[n_out, c_out, h_out, w_out] = np.max(x[n_out, c_out, stride*h_out:stride*h_out+pool_height, stride*w_out:stride*w_out+pool_width])
  #############################################################################
  #                             END OF YOUR CODE                              #
  #############################################################################
  cache = (x, pool_param)
  return out, cache


def max_pool_backward_naive(dout, cache):
  """
  A naive implementation of the backward pass for a max pooling layer.

  Inputs:
  - dout: Upstream derivatives
  - cache: A tuple of (x, pool_param) as in the forward pass.

  Returns:
  - dx: Gradient with respect to x
  """
  dx = None
  x, pool_param = cache
  #############################################################################
  # TODO: Implement the max pooling backward pass                             #
  #############################################################################
  pool_height, pool_width, stride = pool_param['pool_height'], pool_param['pool_width'], pool_param['stride']
  N, C, H, W = x.shape
  H_out = int(1 + (H-pool_height)/stride)
  W_out = int(1 + (W-pool_width)/stride)

  dx = np.zeros_like(x)

  for n_out in range(N):
    for c_out in range(C):
      for h_out in range(H_out):
        for w_out in range(W_out):
          x_padded_window =  x[n_out, c_out, stride*h_out:stride*h_out+pool_height, stride*w_out:stride*w_out+pool_width]
          argmax_indx = np.unravel_index(x_padded_window.argmax(), x_padded_window.shape)
          dx[n_out, c_out, stride*h_out:stride*h_out+pool_height, stride*w_out:stride*w_out+pool_width][argmax_indx] = dout[n_out, c_out, h_out, w_out]
  #############################################################################
  #                             END OF YOUR CODE                              #
  #############################################################################
  return dx


def svm_loss(x, y):
  """
  Computes the loss and gradient using for multiclass SVM classification.

  Inputs:
  - x: Input data, of shape (N, C) where x[i, j] is the score for the jth class
    for the ith input.
  - y: Vector of labels, of shape (N,) where y[i] is the label for x[i] and
    0 <= y[i] < C

  Returns a tuple of:
  - loss: Scalar giving the loss
  - dx: Gradient of the loss with respect to x
  """
  N = x.shape[0]
  correct_class_scores = x[np.arange(N), y]
  margins = np.maximum(0, x - correct_class_scores[:, np.newaxis] + 1.0)
  margins[np.arange(N), y] = 0
  loss = np.sum(margins) / N
  num_pos = np.sum(margins > 0, axis=1)
  dx = np.zeros_like(x)
  dx[margins > 0] = 1
  dx[np.arange(N), y] -= num_pos
  dx /= N
  return loss, dx


def softmax_loss(x, y):
  """
  Computes the loss and gradient for softmax classification.

  Inputs:
  - x: Input data, of shape (N, C) where x[i, j] is the score for the jth class
    for the ith input.
  - y: Vector of labels, of shape (N,) where y[i] is the label for x[i] and
    0 <= y[i] < C

  Returns a tuple of:
  - loss: Scalar giving the loss
  - dx: Gradient of the loss with respect to x
  """
  probs = np.exp(x - np.max(x, axis=1, keepdims=True))
  probs /= np.sum(probs, axis=1, keepdims=True)
  N = x.shape[0]
  loss = -np.sum(np.log(probs[np.arange(N), y])) / N
  dx = probs.copy()
  dx[np.arange(N), y] -= 1
  dx /= N
  return loss, dx

