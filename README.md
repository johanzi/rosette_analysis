
# Rosette analysis
Perform segmentation of Arabidopsis rosettes pictures to extract RGB values and project leaf area.
The macro extract also RGB values for yellow and green colors of your calibrator.

## Requirements

* ImageJ with SIOX plugin
* RGB images of rosettes (one plant per image)
* Python >= 3.0


## Pipeline

### Photo shooting
Each picture will be cutted in half. The upper half has to contain the plant whereas the lower half has to contain the calibrator. Note that the plants and the calibrator don't have to be exactly at the same place during the all photo shooting as long as they stay in the upper and lower part of the picture, respectively.
![](tuto/tuto0.png?raw=true)


### Create the segmentators
The segmentations are performed with [SIOX: Simple Interactive Object Extraction plugin](https://imagej.net/SIOX:_Simple_Interactive_Object_Extraction).

Three segmentators have to be created:

* One for the rosette
* One for the yellow color in your calibrator
* One for the green color in your calibrator

In the test folder, you will find the three segmentators ('segmentator4Rosette.siox','segmentator4Yellow.siox', 'segmentator 4Green.siox') and can directly try the macro in the [batch analysis](#batch-analysis) step. Those segmentators were created for *A. thaliana* leaves and the calibrator we used. You should therefore create your own segmentators using the following steps:

#### Create a segmentator for the rosette

* Open one representative image of the dataset in ImageJ
* Go to Plugins > Segmentation > SIOX: Simple Interactive Object Extraction plugin
* The opened image should now appear in the SIOX Segmentation GUI

![](tuto/tuto1.png?raw=true)

* The 'Foreground' button should already be on select mode. Select a part of the plant with one of the selection tool of ImageJ (rectangle as default). You can also select multiple areas by holding 'shift'
* Click on 'Background' and select a part of the background (substrate the plant is growing in). The foreground selection (plant) should appear now in green. You can also select multiple areas by holding 'shift'

![](tuto/tuto2.png?raw=true)

* Click to 'Segment'. If the segmentation is not correct, use the 'Detail Refinement Brush' and subtract or add elements that where classified incorrectly as background or foreground.

![](tuto/tuto3.png?raw=true)

* Click on 'Create Mask' to see how the binary image looks like. If OK, proceed with next step
* Click on 'Save segmentator' and save in the directory containing the images (or in a parent directory if needed to be used for multiple directory). *It does not matter where the segmentator is but it goes faster to keep it in the same directory than the images for the next steps*


#### Create the segmentator for the yellow calibrator

In this example, we will create the yellow segmentator from the color panel.

Follow the steps in [rosette segmentator](#create-a-segmentator-for-the-rosette) but instead of selecting the rosette as a foreground select the yellow color from the calibrator.


![](tuto/tuto4.png?raw=true)

Select a part of the background.

![](tuto/tuto5.png?raw=true)

* Click on 'Save segmentator' and save in the directory containing the images (or in a parent directory if needed to be used for multiple directory). **The segmentator has to be saved as 'Segmentator4Yellow.siox'**

#### Create the segmentator for the green calibrator

* Repeat the steps in [yellow segmentator](#create-the-segmentator-for-the-yellow-calibrator) but instead of selecting the yellow color from the calibrator, select the green color. **The segmentator has to be saved as 'Segmentator4Green.siox'**




### Batch analysis

Once the segmentators are created, the analysis in batch can start. For this, be sure that all your images are in same directory. Note where your segmentator file (extension .siox) is located.

* Copy the ImageJ macro [Rosette_Analysis.ijm](Rosette_Analysis.ijm) into ImageJ/plugins
* Restart ImageJ
* Go to 'Plugins > rosette analysis'
* The macro should request the 'source directory' containing the images, then the segmentator
* The analysis should start. Avoid touching the keyboard during the analysis as it can interrupt the parts of the script that are not performed in BatchMode

### Segmentation control
* Once performed, three directories (results, segmented, calibration) should appear

* Open the 'segmented' directory and verify whether the segmentation was properly performed (rosette clearly delimited). *At that point, if the rosette were not properly segmented, either the segmentator was not properly created (go back to 'Create a segmentator' section), or perhaps the background/plants between your images are too different to be segmented with the same segmentator (a manual segmentation image by image with SIOX plugin is then necessary)

* You can also open the 'calibration' directory to make sure the segmentation was properly performed on your calibrator.

### Result Parsing

* Make sure the python script [MacroRosetteAnalysis.py]([MacroRosetteAnalysis.py]) is located in the parent folder of the results folder and run it.
```sh
python ./MacroRosetteAnalysis.py
```

* You should then find a 'FinalAnalysis.txt' file in the results folder with the RGB values for the rosette and your calibrator for each picture.

#### Description of the header

* Sample = Picture
* Area = Projected Leaf Area

##### RGB values for the rosette
* Rosette_Red = R value from the rosette
* SD_Rosette_Red = standard deviation of R value from the rosette
* Rosette_Green = R value from the rosette
* SD_Rosette_Green = standard deviation of R value from the rosette
* Rosette_Yellow = R value from the rosette
* SD_Rosette_Yellow = standard deviation of R value from the rosette

##### RGB values for the green calibrator
* GREEN_Calibrator_Red = R value from the green calibrator
* SD_GREEN_Calibrator_Red = standard deviation of R value from the green calibrator
* GREEN_Calibrator_Green = R value from the green calibrator
* SD_GREEN_Calibrator_Green = standard deviation of R value for the green calibrator
* GREEN_Calibrator_Yellow = R value from the green calibrator
* SD_GREEN_Calibrator_Yellow = standard deviation of R value for the green calibrator

##### RGB values for the yellow calibrator
* YELLOW_Calibrator_Red = R value from the yellow calibrator
* SD_YELLOW_Calibrator_Red = standard deviation of R value for the yellow calibrator
* YELLOW_Calibrator_Green = R value from the yellow calibrator
* SD_YELLOW_Calibrator_Green = standard deviation of R value for the yellow calibrator
* YELLOW_Calibrator_Yellow = R value from the yellow calibrator
* SD_YELLOW_Calibrator_Yellow = standard deviation of R value for the yellow calibrator

## Toy dataset
You can already try test the macro with the 8 images of Arabidopsis provided (as a checkup in case the one you generate does not work).



## Authors

* **Johan Zicola**
* **Emmanuel Tergemina**

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
