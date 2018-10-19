
# Rosette analysis 
Perform segmentation of RGB images of Arabidopsis rosettes and calculate values of green and red to assess relative chlorophyll content. Provides also area of the rosettes.

## Requirements

* ImageJ with SIOX plugin
* RGB images of rosettes (one plant per image)

## Pipeline

### Create a segmentator
The segmentation of the rosette is performed using [SIOX: Simple Interactive Object Extraction plugin](https://imagej.net/SIOX:_Simple_Interactive_Object_Extraction).
The user needs first to create a segmentator for a given dataset of images. To do this:
* Open one representative image of the dataset in ImageJ
* Go to Plugins > Segmentation > SIOX: Simple Interactive Object Extraction plugin
* The opened image should now appear in the SIOX Segmentation GUI
![](images/tuto1.JPG?raw=true)
* The 'Foreground' button should already on select mode. Select a part of the plant with one of the selection tool of ImageJ (rectangle as default)
![](images/tuto2.JPG?raw=true)
* Click on 'Background' and select a part of the background (substrate the plant is growing in). The foreground selection (plant) should appear now in green
* Click to 'Segment'. If the segmentation is not correct, use the 'Detail Refinement Brush' and subtract or add elements that where classified incorrectly as background or foreground
![](images/tuto3.JPG?raw=true)
* Click on *Create Mask* to see how the binary image looks like. If OK, proceed with next step
* Click on 'Save segmentator' and save in the directory containing the images (or in a parent directory if needed to be used for multiple directory). *It does not matter where the segmentator is as long as you reming the place for the next step* 

### Batch analysis

Once the segmentator is generator, the analysis in batch can start. For this, be sure all your images for a specific genotype are in one directory. Note where your segmentator file (extension .siox) is located.

* Copy the ImageJ macro macro_rosette_analysis.ijm into ImageJ/plugins/Macros 
* Restart ImageJ
* Go to 'Plugins > Macros > rosette analysis'
* The macro should request the 'source directory' containing the images, then the segmentator
* The analysis should start. Avoid touching the keyboard during the analysis
* Once performed, new directories should appear and a log file containing information about the run
* Open 'binary_images' directory and verify whether the segmentation was properly performed (rosette clearly delimited)

*Details on the image analysis:* The binary images will allow to extract values of pixels in the red and green images. 
The two colors yellow and green correspond to the following RGB values (in 8-bit scale):
* Yellow = 255,255,0
* Green = 0,255,0

Therefore, the ratio of green/red should decrease with the amount of green (correlating with the chlorophyll content). This method is not as accurate as a measure using a photospectrometer but does only require a standard camera. It provides in addition other morphological variables such as total leaf area, rosette diameter, ...
 

### Result Parsing

Manu you have the mic! 

