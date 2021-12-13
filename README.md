# rsoneFusion
Smoothing Filter-based Panchromatic Spectral Decomposition for Multispectral and Hyperspectral Image Pan-sharpening (SFPSD)

This project provides the MATLAB source code of MS and HS image sharpening method SFPSD and the engineering test program compiled by c/c++, the program can be found in Release.

The input of the test program can be in the following two ways:
1. A tiff image with the same name rpb
2. GeoTiff images with geographic information. 

The program will automatically perform sub-pixel registration of PAN and MS/HS images. Refer to [1] for the registration method.

The registered data will be sharpened using the SFPSD method. 

The program rendering is as follows: 
![image](https://user-images.githubusercontent.com/46412476/145835744-cd0ff724-6492-4547-915b-1234c1002150.png)

If our methods or procedures are helpful to you, please cite the following papers: 
[1] Xie G, Wang M, Zhang Z, et al. Near Real-Time Automatic Sub-Pixel Registration of Panchromatic and Multispectral Images for Pan-Sharpening[J]. Remote Sensing, 2021, 13(18): 3674. (https://www.mdpi.com/2072-4292/13/18/3674)
