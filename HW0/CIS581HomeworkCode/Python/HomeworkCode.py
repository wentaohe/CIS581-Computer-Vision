import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from PIL import Image
from PIL import ImageOps


def convolve2d(image, kernel):
    width, height = image.size
    # padding the original image with zeros
    padded_image = np.zeros((height + 2, width + 2))
    padded_image[1: -1, 1:-1] = image
    output = signal.convolve(padded_image, kernel)
    return output


def convolve2d_2(image, kernel):
    width, height = image.size
    output = np.zeros((height, width))
    # padding the original image with zeros
    padded_image = np.zeros((height + 2, width + 2))
    padded_image[1: -1, 1:-1] = image
    for x in range(width):
        for y in range(height):
            output[y, x] = np.sum(np.multiply(
                kernel, padded_image[y: y + 3, x: x + 3]))
    return output


# -- Read an image --
# Attribution - Bikesgray.jpg By Davidwkennedy (http://en.wikipedia.org/wiki/File:Bikesgray.jpg) [CC BY-SA 3.0 (http://creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons
# Write code here to read in the image named 'Bikesgray.jpg' into the variable img1
img1 = Image.open('Bikesgray.jpg').convert("L")

# -- Display original image --
img1.show()

# -- X gradient - Sobel Operator --
f1 = np.asarray([[1, 0, -1], [2, 0, -2], [1, 0, -1]])

# -- Convolve image with kernel f1 -> This highlights the vertical edges in the image --
# Write code here to convolve img1 with f1
vertical_sobel = convolve2d(img1, f1)

#vertical_sobel = convolve2d_2(img1, f1)

# -- Display the image --
# Write code here to display the image 'vertical_sobel' (hint: use plt.imshow with a color may of gray)
plt.figure(1)
plt.imshow(vertical_sobel, cmap=plt.cm.gray)
plt.title('Vertical Sobel')
plt.show()

# -- Y gradient - Sobel Operator --
# Now if you want to highlight horizontal edges in the image, think about what the kernel should be. Store this kernel in the variable f2.
f2 = np.rot90(f1, 3)

# -- Convolve image with kernel f2 -> This should highlight the horizontal edges in the image --
horz_sobel = convolve2d(img1, f2)  # Write code here to convolve img1 with f2

# -- Display the image --
# Write code here to display the image 'horz_sobel' (hint: use plt.imshow with a color may of gray)
plt.figure(2)
plt.imshow(horz_sobel, cmap=plt.cm.gray)
plt.title('Horizontal Sobel')
plt.show()
