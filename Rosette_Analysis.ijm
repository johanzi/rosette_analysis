/**
*AUTHOR : Johan Zicola and Emmanuel Tergemina
*DATE: 2018-12-11
*/

macro "Rosette Analysis"{
    Dialog.create("Dialog Windows");


	source_folder = getDirectory("Select source directory:");
	segmentator = File.openDialog("Select the segmentator:");

	////Create Directories
	File.makeDirectory(source_folder+"results"+File.separator)
	File.makeDirectory(source_folder+"segmented"+File.separator)
	File.makeDirectory(source_folder+"calibration"+File.separator)
	

	setBatchMode(false);

	function define_roi() {
		for (k=0; k<nResults; k++) {
      		x = getResult('XStart', k);
     		y = getResult('YStart', k);
     		doWand(x,y);
    		roiManager("add");
  		}
	}
	function extract_rgb() {
		//Extract Red values
    	setRGBWeights(1, 0, 0);
  		run("Measure");
  		setResult("Label", nResults-1, "Red");
  		//Extract Green values
  		setRGBWeights(0, 1, 0);
  		run("Measure");
 		setResult("Label", nResults-1, "Green");
  		//Extract Blue values
  		setRGBWeights(0, 0, 1);
		run("Measure");
		setResult("Label", nResults-1, "Blue");
	}
	if (isOpen("ROI Manager")) {
     	selectWindow("ROI Manager");
     	run("Close");
	 }

	files = getFileList(source_folder);
	extensions = newArray(".jpg",".tiff");

	for (i=0; i<files.length; i++) {
    	showProgress(i, files.length);
		for (j=0; j<extensions.length; j++) {
			if (endsWith(toLowerCase(files[i]), extensions[j])) {
				//print(files[i]);
				open(files[i]);

				index = indexOf(toLowerCase(files[i]), extensions[j]);
				fileName = substring(toLowerCase(files[i]), 0, index);
				file = substring(files[i], 0, index);


				///////Calibration

				makeRectangle(32, 1500, 4220, 1324);

				run("Duplicate...", " ");

				////Apply SIOX Yellow Segmentator
				run("Apply saved SIOX segmentator", "browse="+source_folder+"segmentator4Yellow.siox siox="+source_folder+"segmentator4Yellow.siox");
				run("Analyze Particles...", "clear add");
				define_roi();
  				selectWindow(file+"-1.JPG");
  				run("Duplicate...", " ");
      			roiManager("Select", 0);
      			roiManager("reset");
      			run("Clear Outside");
      			saveAs(".jpg", source_folder+"calibration"+File.separator+file+"_YellowSegmented");
				extract_rgb();
				selectWindow("Results");
      			saveAs("Results", source_folder+File.separator+"results"+File.separator+file+"_Yellow.txt");
      			//run("Close All");
      			run("Close");


				////Apply SIOX Green Segmentator
      			selectWindow(file+"-1.JPG");
      			run("Apply saved SIOX segmentator", "browse="+source_folder+"segmentator4Green.siox siox="+source_folder+"segmentator4Green.siox");
				run("Analyze Particles...", "clear add");
				define_roi();
  				selectWindow(file+"-1.JPG");
  				run("Duplicate...", " ");
      			roiManager("Select", 0);
      			roiManager("reset");
      			run("Clear Outside");
      			saveAs(".jpg", source_folder+"calibration"+File.separator+file+"_GreenSegmented");
      			extract_rgb();
				selectWindow("Results");
      			saveAs("Results", source_folder+File.separator+"results"+File.separator+file+"_Green.txt");
      			//run("Close All");
      			run("Close");


				//////Rosette segmentation
				selectWindow(files[i]);
				//run("Duplicate...", " ");
				makeRectangle(44, 24, 4224, 1484);

				run("Crop");
				//run("Duplicate...", " ");
      			run("Apply saved SIOX segmentator", "browse="+segmentator+" siox="+segmentator);
				////Define ROI
				run("Analyze Particles...", "clear add");
				define_roi();
      			selectWindow(files[i]);
      			roiManager("Select", 0);
      			roiManager("reset");
      			run("Clear Outside");
      			saveAs(".jpg", source_folder+"segmented"+File.separator+file+"_Segmented");
				extract_rgb();
      			selectWindow("Results");
      			saveAs("Results", source_folder+File.separator+"results"+File.separator+file+"_Results.txt");
      			run("Close All");

			}
		}
	}
	//exec(source_folder+"MacroRosetteAnalysis.py")
}
