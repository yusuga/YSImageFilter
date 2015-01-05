#YSImageFilter

UIImage filter. Allows filtering, resizing, masking.

#Example - TestUIImageFilters

CoreGraphics vs [NYXImagesKit](https://github.com/Nyx0uf/NYXImagesKit) vs [GPUImage](https://github.com/BradLarson/GPUImage) vs CoreImage

##Benchmark - Resize

###Solid color image

![solid color image](http://cl.ly/image/2N2F3f2w1q16/solid.png)

####100 trials

**[iPhone4 - iOS7.0]**

||1000x1000px -> 50x50px|1000x1000px -> 300x300px|
|:---|:---|:---|
|CoreGraphics(None)|0.002660 (375 FPS)|0.034310 (29 FPS)|
|CoreGraphics(Low)|0.002756 (362 FPS)|0.075693 (13 FPS)|
|CoreGraphics(Medium)|0.038360 (26 FPS)|0.126424 (7 FPS)|
|CoreGraphics(High)|0.060210 (16 FPS)|0.172681 (5 FPS)|
|NYXImagesKit|0.051545 (19 FPS)|0.109839 (9 FPS)|
|GPUImage|0.011259 (88 FPS)|0.012334 (81 FPS)|
|CoreImage(CPU)|0.011139 (89 FPS)|0.015267 (65 FPS)|
|CoreImage(GPU)|0.012046 (83 FPS)|0.015520 (64 FPS)|

**[iPhone5s - iOS7.1]**

||1000x1000px -> 50x50px|1000x1000px -> 300x300px|
|:---|:---|:---|
|CoreGraphics(None)|0.000261 (3825 FPS)|0.005128 (195 FPS)|
|CoreGraphics(Low)|0.000283 (3533 FPS)|0.007939 (125 FPS)|
|CoreGraphics(Medium)|0.003536 (282 FPS)|0.013599 (73 FPS)|
|CoreGraphics(High)|0.006976 (143 FPS)|0.019372 (51 FPS)|
|NYXImagesKit|0.005342 (187 FPS)|0.012160 (82 FPS)|
|GPUImage|0.004330 (230 FPS)|0.005025 (199 FPS)|
|CoreImage(CPU)|0.002575 (388 FPS)|0.003410 (293 FPS)|
|CoreImage(GPU)|0.002737 (365 FPS)|0.004470 (223 FPS)|

###Picture image

![picture image](http://cl.ly/image/2R0R3l0o0q35/cat.png)

####100 trials

**[iPhone4 - iOS7.0]**

||1000x1000px -> 50x50px|1000x1000px -> 300x300px|
|:---|:---|:---|
|CoreGraphics(None)|0.003887 (257 FPS)|0.044526 (22 FPS)|
|CoreGraphics(Low)|0.004481 (223 FPS)|0.081731 (12 FPS)|
|CoreGraphics(Medium)|0.121744 (8 FPS)|0.271093 (3 FPS)|
|CoreGraphics(High)|0.206694 (4 FPS)|0.479763 (2 FPS)|
|NYXImagesKit|0.206455 (4 FPS)|0.477664 (2 FPS)|
|GPUImage|0.039227 (25 FPS)|0.040107 (24 FPS)|
|CoreImage(CPU)|0.037182 (26 FPS)|0.053168 (18 FPS)|
|CoreImage(GPU)|0.036454 (27 FPS)|0.054199 (18 FPS)|

**[iPhone5s - iOS7.1]**

||1000x1000px -> 50x50px|1000x1000px -> 300x300px|
|:---|:---|:---|
|CoreGraphics(None)|0.000361 (2768 FPS)|0.005303 (188 FPS)|
|CoreGraphics(Low)|0.000363 (2755 FPS)|0.008804 (113 FPS)|
|CoreGraphics(Medium)|0.009869 (101 FPS)|0.025250 (39 FPS)|
|CoreGraphics(High)|0.021267 (47 FPS)|0.049103 (20 FPS)|
|NYXImagesKit|0.021170 (47 FPS)|0.048766 (20 FPS)|
|GPUImage|0.010341 (96 FPS)|0.011156 (89 FPS)|
|CoreImage(CPU)|0.006236 (160 FPS)|0.012596 (79 FPS)|
|CoreImage(GPU)|0.008334 (119 FPS)|0.016483 (60 FPS)|

##Benchmark - Sepia

![picture image](http://cl.ly/image/2R0R3l0o0q35/cat.png)

###100 trials

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


##License

    GTMUIImage+Resize.m
    Copyright 2009 Google Inc.
    
    Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.  You may obtain a copy of the License at
     
    http://www.apache.org/licenses/LICENSE-2.0
 
    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the License for the specific language governing permissions and limitations under the License.

    ***

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