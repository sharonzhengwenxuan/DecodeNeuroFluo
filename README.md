# DecodeNeuroFluo
Decoding fluorescence-based neuromodulatory transmission properties for quantitative analysis of spatial precision and release heterogeneity
Features and methods introduction
●	Image processing
○	Alignment
○	Deconvolution
○	Baseline adjustment
○	Denoise
○	Background adjustment
○	ΔF/F presentation
●	Spatialtemporal analysis
○	Peak location identification
○	Peak extraction
○	Peak maximum response analysis
○	Peak exponential decay analysis
Dependencies
The following JAR File has to be added to the java folder of Matlab 
●	DeconvolutionLab_2 
Additional Matlab toolboxes are also required
●	Curve Fitting Toolbox
●	Statistics and Machine Learning Toolbox
Input and output data
Input 
●	The default setting for input is in “.tif” format
●	The images of one cell should be in the same folder number by a number (eg. 1), and each image should be named in sequence (eg. 1_1, 1_2,...)
Output
●	Folders
○	_edited_1: aligned image from input
○	_edited_2: deconvolved from _edited_1
○	_edited_3: baseline adjusted from _edited_2
○	_edited_4: denoised from _edited_3
○	_edited_5:  ΔF/F calculated from _edited_4
○	_edited_6;  background adjusted ΔF/F calculated from _edited_5 
●	Images
○	Overlaid ΔF/F color image on cell image:  currently saved in A6 folder as “xx_xxxbmp_transparant.png”
○	3D image: manually save to PNG from matlab image after running jerky
○	Peak extraction: manually save to PNG from matlab image after running jerky
●	Peak quantification
○	The data of response against distance to the maximum response is currently saved as jacktotal, which is background adjusted. 
Usage
●	Run A0_TestRun.m in the A0 folder
○	This code will perform simple calculation of ΔF/F and present results in color images
○	Proceed only  if there are noticeable response without significant movements and noises
○	Manual options
■	The default setting for the start and end of the images are 401 and 1001, and they can be changed at the beginning of A0_TestRun.m
●	Run A6_1main.m in the A6 folder
○	This code will perform alignment, deconvolution, baseline adjustment, denoise, and present ΔF/F in color images without background adjustment
○	Manual options
■	In STA5Calc.m line 40, change the noise level according to the setup and image quality to achieve cleaner images that show individual peaks
■	The default setting for the start and end of the images are 401 and 1001, and they can be changed at the beginning of A6_1main.m
■	The default setting for the response starts at 501
●	Run A6_2F6.m
○	This code will present ΔF/F in color images after background adjustment
○	The background level is uniformly assumed to be the minimum value of the image before the response
○	Manual options
■	In line 18, the background value can be manually changed if the background is not uniform
●	Run A6_3Overlay.m
○	This code will overlay the one ΔF/F color image of choice on one denoised cell image for peak location identification
○	Manual options
■	Slice number can be changed at the beginning
■	In line 15, the range of bw can be changed to overlay large response 
●	Run the function jerky
○	This code will present the 3D image
●	Run A6_4PeakIdentification.m
○	This code will identify clusters of response using DBSCAN algorithm 
○	The default epsilon and minpts were set to accommodate for individual peaks with a decay constant around 1
○	Manual option
■	In STAPeak.m, in line xx and xx, epsilon and minpts can be adjusted for clusters of different size
●	Run A6_5Pumpkintest.m
○	This code will plot the response against the distance to the maximum response point of a peak of selection
○	Input requires circling the region of interest
○	The output response will be adjusted by eliminating the background (similar in A6_2F6)
<img width="468" height="637" alt="image" src="https://github.com/user-attachments/assets/4868e643-048f-472a-862d-671b8c44d17e" />
