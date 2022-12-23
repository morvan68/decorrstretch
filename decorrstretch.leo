<?xml version="1.0" encoding="utf-8"?>
<!-- Created by Leo: http://leoeditor.com/leo_toc.html -->
<leo_file xmlns:leo="http://leoeditor.com/namespaces/leo-python-editor/1.1" >
<leo_header file_format="2"/>
<globals/>
<preferences/>
<find_panel_settings/>
<vnodes>
<v t="martin.20221223130809.2"><vh>NewHeadline</vh></v>
<v t="martin.20221223130914.1"><vh>Imported Files</vh>
<v t="martin.20221223130914.2"><vh>@clean ./ds_lib.py</vh>
<v t="martin.20221223130914.3"><vh>Declarations</vh></v>
<v t="martin.20221223130914.4"><vh>decorrstretch function</vh></v>
<v t="martin.20221223131006.1"><vh>main</vh></v>
</v>
</v>
</vnodes>
<tnodes>
<t tx="martin.20221223130809.2"></t>
<t tx="martin.20221223130914.1"></t>
<t tx="martin.20221223130914.2">@others
@language python
@tabwidth -4
</t>
<t tx="martin.20221223130914.3">import numpy as np
import cv2


</t>
<t tx="martin.20221223130914.4">def decorrstretch(A, tol=None, version='...'):
    """
    Apply decorrelation stretch to image

    Arguments:
    A   -- image in cv2/numpy.array format
    tol -- upper and lower limit of contrast stretching
    version -- the colorspace of the stretch
    """

    # save the original shape
    orig_shape = A.shape
    # reshape the image
    #         B G R
    # pixel 1 .
    # pixel 2   .
    #  . . .      .
    
    A = A.reshape((-1,3)).astype(np.float)
    # covariance matrix of A
    cov = np.cov(A.T)
    # source and target sigma
    sigma = np.diag(np.sqrt(cov.diagonal()))
    # eigen decomposition of covariance matrix
    eigval, V = np.linalg.eig(cov)
    # stretch matrix
    S = np.diag(1/np.sqrt(eigval))
    # compute mean of each color
    mean = np.mean(A, axis=0)
    # substract the mean from image
    A -= mean
    # compute the transformation matrix
    T = reduce(np.dot, [sigma, V, S, V.T])
    # compute offset 
    offset = mean - np.dot(mean, T)
    # transform the image
    A = np.dot(A, T)
    # add the mean and offset
    A += mean + offset
    # restore original shape
    B = A.reshape(orig_shape)
    
    # for each color...
    for b in range(3):
        # apply contrast stretching if requested
        if tol:
            # find lower and upper limit for contrast stretching
            low, high = np.percentile(B[:,:,b], 100*tol), np.percentile(B[:,:,b], 100-100*tol)
            B[B&lt;low] = low
            B[B&gt;high] = high
        # ...rescale the color values to 0..255
        B[:,:,b] = 255 * (B[:,:,b] - B[:,:,b].min())/(B[:,:,b].max() - B[:,:,b].min())
    
    return B.astype(np.uint8)  # return it as uint8 (byte) image

</t>
<t tx="martin.20221223131006.1">if __name__ == '__main__':
    
    #load test image
    
    res = decorrstretch( img)
    
    # save test image
    # or compare with known save</t>
</tnodes>
</leo_file>
