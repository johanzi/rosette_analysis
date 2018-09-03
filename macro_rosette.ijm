
/**
*AUTHOR : Johan Zicola
*DATE: 2018-01-31
*
*INFORMATION:
*This macro analyses different parameters of images containing 1 rosette of Arabidopsis thaliana
*(should work with other species). The macro requires as input a directory containing the 
*images (RGB with tiff or jpg extension) and the threshold method to use for segmentation.
*The output of the macro is the generation of 4 directories within the directory containing the
*images, "green_images" contains the splitted green channel images from the RGB images, "red_images"
*contains the splitted red channel images from the RGB images, "binary_images",
*contains the thresholded "based on green images", "analyzed_images" contain the binaries of the selected objects
*for the "Analysis Particles" analysis (allow to vizualize whether the selection was made properly or not).
*At last, the "results" directory contains txt files (tab-separated values) which contains the results of 
*the analysis for each image (in red and green channels). Ideally only 1 value per file should be present 
* (rosette identified as a single object) but some leaves can be identified as separate objects due 
* to unproper thresholding. In this case, one needs to pay attention to how analyzing the results 
* (area should be summed, mean average should be averaged, and so on).
*/

macro "Rosette analysis"{   
    Dialog.create("Dialog Windows");
   
    source_folder = getDirectory("Select source directory:");
    
    //Choose the thresholding method (Moments dark was the one was working the best on the test images)
    Dialog.addChoice("Nucleus threshold method:", newArray("Moments dark", "Minimum dark","Default dark","Huang dark",
    "Intermodes dark","IsoData dark","Li dark","MaxEntropy dark","Mean dark",
    "MinError dark","Otsu dark","Percentile dark",
    "RenyiEntropy dark","Shanbhag dark","Triangle dark","Yen dark"));
    
    //Show the dialog interface
    Dialog.show();

    threshold_rosette = Dialog.getChoice();


	//Get Date and time of the system
	function get_time() {
	     MonthNames = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
	     DayNames = newArray("Sun", "Mon","Tue","Wed","Thu","Fri","Sat");
	     getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	     TimeString ="Date: "+DayNames[dayOfWeek]+" ";
	     if (dayOfMonth<10) {TimeString = TimeString+"0";}
	     TimeString = TimeString+dayOfMonth+"-"+MonthNames[month]+"-"+year+"\nTime: ";
	     if (hour<10) {TimeString = TimeString+"0";}
	     TimeString = TimeString+hour+":";
	     if (minute<10) {TimeString = TimeString+"0";}
	     TimeString = TimeString+minute+":";
	     if (second<10) {TimeString = TimeString+"0";}
	     TimeString = TimeString+second;
	     print(TimeString);
	}



    // Defined whether the filename provided contains either of the extensions
    // defined in 'extensions' array
    function isImage(filename) {
        extensions = newArray("jpg", "tiff","tif");
        result = false;
        for (i=0; i<extensions.length; i++) {
            if (endsWith(toLowerCase(filename), "." + extensions[i]))
            result = true;
        }
        return result;
    }
    
    // Close all files (images, results, summary, ...) open in ImageJ
    function closeAll(){
        list = getList("window.titles");
        for (i=0; i<list.length; i++){
            winame = list[i];
            selectWindow(winame);
            run("Close");
        }
    }
    
    // Extract from the RGB file contained in input directory (defined by user)
    // the channel (either blue or red) and save it in "green_images" or "red_images" directories
    function extract_color(image, color){
        list_source = getFileList(source_folder);
        if (color == "red"){
        	code = "1-1";
        }
        if (color == "green"){
        	code = "2-2";
        }
        setBatchMode(true);
        for (i=0; i < list_source.length; i++){
            source = list_source[i];
            if (isImage(source)){
                open(source_folder+source);
                run("RGB Stack");
                run("Duplicate...", "duplicate range="+code);
                run("Gaussian Blur...", "sigma=2");
                saveAs("Tiff",source_folder+File.separator+color+"_images"+File.separator+source);
                run("Close All"); //important to use "Close All" instead of close() to avoid RAM filling
            }
        setBatchMode(false);
        }
    }

    
    // Segment green images using input threshold (defined by user)
    // Make a binary image from the thresholded image and save it in 
    // "binary_images" directory
    function segment_rosette(source_folder){
        list_source = getFileList(source_folder+"green_images");
        setBatchMode(true);
        for (i=0; i < list_source.length; i++){
            source = list_source[i];
            if (isImage(source)){
                open(source_folder+File.separator+"green_images"+File.separator+source);
                setAutoThreshold(threshold_rosette);
                run("Convert to Mask");
                saveAs("Tiff",source_folder+File.separator+"binary_images"+File.separator+source);
                close();
            }
        }
        setBatchMode(false);
    }
    
    
    // Analyze particles binary images in "binary_images" directory and extract 
    // pixel information from the "green images" in "green_images" directory.
    // Generates a binary image from the particles analyzed and save it in 
    // "analysed_images" directory. Save the "result" file generated by "Analyze Particles"
    // and save it in "results" directory (under the name <image_name>_Results.txt.
    function particle_analysis(source_folder, color){
	    list_source = getFileList(source_folder+File.separator+color+"_images");
        list_binary = getFileList(source_folder+File.separator+"binary_images");
        
        setBatchMode(true);
        for (i=0; i < list_source.length; i++){
            source = list_source[i];
            binary = list_binary[i];
            //Get the name of the file opened with its .tiff extension => will be used to name results output
            dotIndex = indexOf(source, ".");
            title = substring(source, 0, dotIndex);
            open(source_folder+File.separator+color+"_images"+File.separator+source);
            rename(title);
            open(source_folder+File.separator+"binary_images"+File.separator+binary);
            run("Set Measurements...", "area mean standard min kurtosis area_fraction redirect="+title+" decimal=3");
            run("Analyze Particles...", "size=5000-Infinity show=Masks display exclude clear summarize add");
            saveAs("Tiff",source_folder+File.separator+"analysed_images"+File.separator+source);
            selectWindow("Results");
            saveAs("Results", source_folder+File.separator+"results"+File.separator+source+"_"+color+"_Results.txt");
            run("Close All");
        }
        setBatchMode(false);
}


    
 
    // Create directories
    File.makeDirectory(source_folder+File.separator+"green_images"+File.separator);
    
    File.makeDirectory(source_folder+File.separator+"red_images"+File.separator);
    
    File.makeDirectory(source_folder+File.separator+"binary_images"+File.separator);
    
    File.makeDirectory(source_folder+File.separator+"analysed_images"+File.separator);
    
    File.makeDirectory(source_folder+File.separator+"results");


    // launch function
    // Extract red channel
    extract_color(source_folder, "red");
    
    // Extract green channel
    extract_color(source_folder, "green");

    // Segment rosette based on green image
    segment_rosette(source_folder);
    
    // Analysis from red channel images
    particle_analysis(source_folder, "red");
    
    // Analysis from green channel images
    particle_analysis(source_folder, "green");
        
    // Generates a log file in the input directory (defined by user) containing
    // the input directory, the threshold method used and the date 
    print("folder processed processed: "+source_folder);
	print("Threshold method : "+threshold_rosette);
	get_time(); //calls date and time from defined function get_time
	selectWindow("Log");
	saveAs("Text", source_folder+File.separator+"Log.txt");
	run("Close");

	closeAll();
	
}
