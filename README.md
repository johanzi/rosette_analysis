
# Rosette analysis 
Perform segmentation of RGB images of Arabidopsis rosettes and calculate values of green and red to assess relative chlorophyll content. Provides also area of the rosettes.

## Requirements

* ImageJ with SIOX plugin
* RGB images of rosettes (one plant per image)

## Pipeline

### Create a segmentator
The segmentation of the rosette is performed using [SIOX: Simple Interactive Object Extraction plugin](https://imagej.net/SIOX:_Simple_Interactive_Object_Extraction).

The segmentator [segmentator.siox](test/segmentator.siox) located in the `test/` directory was created for *A. thaliana* leaves and can directly be used in the [batch analysis](#batch-analysis) step. Nonetheless, it may be suboptimal for your specific phenotype. You can therefore create your own segmentator using the following steps: 

Create a segmentator for a given dataset of images:

* Open one representative image of the dataset in ImageJ
* Go to Plugins > Segmentation > SIOX: Simple Interactive Object Extraction plugin
* The opened image should now appear in the SIOX Segmentation GUI

![](images/tuto1.JPG?raw=true)

* The 'Foreground' button should already on select mode. Select a part of the plant with one of the selection tool of ImageJ (rectangle as default)
* Click on 'Background' and select a part of the background (substrate the plant is growing in). The foreground selection (plant) should appear now in green

![](images/tuto2.JPG?raw=true)

* Click to 'Segment'. If the segmentation is not correct, use the 'Detail Refinement Brush' and subtract or add elements that where classified incorrectly as background or foreground

![](images/tuto3.JPG?raw=true)

* Click on *Create Mask* to see how the binary image looks like. If OK, proceed with next step
* Click on 'Save segmentator' and save in the directory containing the images (or in a parent directory if needed to be used for multiple directory). *It does not matter where the segmentator is but it goes faster to keep it in the same directory than the images for the next steps* 


### Batch analysis

Once the segmentator is created, the analysis in batch can start. For this, be sure all that your images for a specific genotype are in one directory. Note where your segmentator file (extension .siox) is located.

* Copy the ImageJ macro [macro_rosette_analysis.ijm](macro_rosette_analysis.ijm) into ImageJ/plugins/Macros 
* Restart ImageJ
* Go to 'Plugins > Macros > rosette analysis'
* The macro should request the 'source directory' containing the images, then the segmentator
* The analysis should start. Avoid touching the keyboard during the analysis as it can interrupt the parts of the script that are not performed in BatchMode
* Once performed, new directories and a log file containing information about the run should appear
* Open 'binary_images' directory and verify whether the segmentation was properly performed (rosette clearly delimited). *At that point, if the rosette were not properly segmented, either the segmentator was not properly created (go back to 'Create a segmentator' section, or perhaps the background/plants between your images are too different to be segmented with the same segmentator (a manual segmentation image by image with SIOX plugin is then necessary)

The content of the directory should look like this after analysis:

![](images/tuto4.JPG?raw=true)

*Details on the image analysis:* The binary images will allow to extract values of pixels in the red and green images. 
The two colors yellow and green correspond to the following RGB values (in 8-bit scale):
* Yellow = 255,255,0
* Green = 0,255,0

Therefore, the ratio of green/red should decrease with the amount of green (correlating with the chlorophyll content). This method is not as accurate as a measure using a photospectrometer but does only require a standard camera. It provides in addition other morphological variables such as total leaf area, rosette diameter, ...
 

### Result Parsing

Manu you have the mic! 


## Toy dataset
Download the test directory which contains 10 images of Arabidopsis and the corresponding segmentator file (as a checkup in case the one you generate does not work).



## Authors

* **Johan Zicola**

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

