YSImageFilter
===
CoreImage wrapper.

Example - TestUIImageFilters
===
Simple drawing CoreGraphics vs [NYXImagesKit](https://github.com/Nyx0uf/NYXImagesKit) vs  vs [GPUImage](https://github.com/BradLarson/GPUImage) vs CoreImage

Benchmark - Resize
----------------
100 trials

**[iPhone4 - iOS7.0]**

||1000x1000px -> 50x50|1000x1000px -> 300x300px|
|:---|:---|:---|
|CoreGraphics(None)|0.003905 (256 FPS)|0.042514 (23 FPS)|
|CoreGraphics(Low)|	0.003729 (268 FPS)|0.082422 (12 FPS)|
|CoreGraphics(High)|0.209191 (4 FPS)|0.480908 (2 FPS)|
|NYXImagesKit|0.207475 (4 FPS)|0.478156 (2 FPS)|
|GPUImage|0.040550 (24 FPS)|0.039459 (25 FPS)|
|CoreImage(CPU)|0.036824 (27 FPS)|0.054015 (18 FPS)|
|CoreImage(GPU)|0.035782 (27 FPS)|0.052756 (18 FPS)|

**[iPhone4s - iOS7.0]**

||1000x1000px -> 50x50|1000x1000px -> 300x300px|
|:---|:---|:---|
|CoreGraphics(None)|0.001483 (674 FPS)|0.023242 (43 FPS)|
|CoreGraphics(Low)|0.001498 (667 FPS)|0.030422 (32 FPS)|
|CoreGraphics(High)|0.139165 (7 FPS)|0.281652 (3 FPS)|
|NYXImagesKit|0.138310 (7 FPS)|0.281438 (3 FPS)|
|GPUImage|0.027866 (35 FPS)|0.029786 (33 FPS)|
|CoreImage(CPU)|0.016034 (62 FPS)|0.022625 (44 FPS)|
|CoreImage(GPU)|0.015991 (62 FPS)|0.022635 (44 FPS)|


**[iPhone5 - iOS7.0]**

||1000x1000px -> 50x50|1000x1000px -> 300x300px|
|:---|:---|:---|
|CoreGraphics(None)|0.000708 (1412 FPS)|0.007247 (137 FPS)|
|CoreGraphics(Low)|0.000605 (1652 FPS)|0.023104 (43 FPS)|
|CoreGraphics(High)|0.050827 (19 FPS)|0.128816 (7 FPS)|
|NYXImagesKit|0.050291 (19 FPS)|0.129923 (7 FPS)|
|GPUImage|0.008119 (123 FPS)|0.010465 (95 FPS)|
|CoreImage(CPU)|0.011094 (90 FPS)|0.015556 (64 FPS)|
|CoreImage(GPU)|0.011037 (90 FPS)|0.015441 (64 FPS)|

**[iPhone5s - iOS7.1]**

||1000x1000px -> 50x50|1000x1000px -> 300x300px|
|:---|:---|:---|
|CoreGraphics(None)|0.000392 (2548 FPS)|0.005476 (182 FPS)|
|CoreGraphics(Low)|0.000386 (2591 FPS)|0.008912 (112 FPS)|
|CoreGraphics(High)|0.021515 (46 FPS)|0.049164 (20 FPS)|
|NYXImagesKit|0.021061 (47 FPS)|0.048945 (20 FPS)|
|GPUImage|0.010388 (96 FPS)|0.011134 (89 FPS)|
|CoreImage(CPU)|0.005921 (168 FPS)|0.012817 (78 FPS)|
|CoreImage(GPU)|0.006170 (162 FPS)|0.016473 (60 FPS)|

Benchmark - Sepia
----------------
100 trials

**[iPhone4 - iOS7.0]**

||50x50px|500x500px|
|:---|:---|:---|
|CoreImage(CPU)|0.007829 (127 FPS)|0.445357 (2 FPS)|
|CoreImage(GPU)|0.007868 (127 FPS)|0.446188 (2 FPS)|
|NYXImagesKit|0.007809 (128 FPS)|0.445349 (2 FPS)|
|GPUImage|0.003374 (296 FPS)|0.044464 (22 FPS)|

**[iPhone4s - iOS7.0]**

||50x50px|500x500px|
|:---|:---|:---|
|CoreImage(CPU)|0.004804 (208 FPS)|0.067474 (14 FPS)|
|CoreImage(GPU)|0.004831 (206 FPS)|0.067433 (14 FPS)|
|NYXImagesKit|0.004781 (209 FPS)|0.067502 (14 FPS)|
|GPUImage|0.003426 (291 FPS)|0.016321 (61 FPS)|

**[iPhone5 - iOS7.0]**

||50x50px|500x500px|
|:---|:---|:---|
|CoreImage(CPU)|0.003257 (307 FPS)|0.037465 (26 FPS)|
|CoreImage(GPU)|0.003276 (305 FPS)|0.037323 (26 FPS)|
|NYXImagesKit|0.003311 (302 FPS)|0.037361 (26 FPS)|
|GPUImage|0.002533 (394 FPS)|0.007925 (126 FPS)|

**[iPhone5s - iOS7.1]**

||50x50px|500x500px|
|:---|:---|:---|
|CoreImage(CPU)|0.001799 (555 FPS)|0.011808 (84 FPS)|
|CoreImage(GPU)|0.001816 (550 FPS)|0.009719 (102 FPS)|
|NYXImagesKit|0.001871 (534 FPS)|0.009674 (103 FPS)|
|GPUImage|0.001799 (555 FPS)|0.006431 (155 FPS)|


License
----------
    Copyright &copy; 2014 Yu Sugawara (https://github.com/yusuga)
    Licensed under the MIT License.

    Permission is hereby granted, free of charge, to any person obtaining a 
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.