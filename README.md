# PhoneGap Plugin for ShowKit iOS

Integrate video chat into your phonegap web app in less than 10 minutes!

* ***This Plugin is built with Phonegap v2.7.0.***
* ***If you just want to see a working demo, feel free to ``git clone git@github.com:curiousminds/ShowKit_PhoneGap.git``. The ShowKit-PhoneGapPlugin itself is a working demo.***
* ***Before you start step 1, you should have an existing phonegap app. If you don't, please checkout PhoneGap's [Getting Started](http://docs.phonegap.com/en/2.7.0/guide_getting-started_ios_index.md.html#Getting%20Started%20with%20iOS) page.***

###Step 1. Add ShowKit.framework to your Project

  * Download the latest [ShowKit.framework](http://www.showkit.com/releases).
  * Drag ShowKit.framework into your project
    ![ScreenShot](https://raw.github.com/showkit/PhoneGap/master/www/img/phonegap_step1.png)

  * Make sure you check 'Copy items into destination group's folder (if needed)' and 'Add to targets'
    ![ScreenShot](https://raw.github.com/showkit/PhoneGap/master/www/img/phonegap_step2.png)

    
  * Select your project in the Project Navigator => 'Build Phases' => 'Link Binary With Library' => press '+' to add more frameworks and libraries...
    ![ScreenShot](https://raw.github.com/showkit/PhoneGap/master/www/img/phonegap_step3.png)

    * You need all of the following libraries
      * OpenGLES.framework
      * AVFoundation.framework
      * QuartzCore.framework
      * CFNetwork.framework
      * CoreVideo.framework
      * CoreGraphics.framework
      * CoreMedia.framework
      * AudioToolbox.framework
      * SystemConfiguration.framework
      * libresolv.dylib
      * libz.dylib

###Step 2. Add ShowKit-PhoneGapPlugin to your Project
   * ``git clone git@github.com:curiousminds/ShowKit_PhoneGap.git``
   * Drag the ShowKitPlugin into the 'Plugins' folder and copy the Showkit.js into the '/www/js' folder.
     ![ScreenShot](https://raw.github.com/showkit/PhoneGap/master/www/img/phonegap_step4.png)
   * Add the following line to the config.xml.
     * ``<plugin name="ShowKitPlugin" value="ShowKitPlugin" />`` 
   * Initialize the app with your ShowKit api key in index.js
     * ``ShowKit.initializeShowKit(apiKey);``
       ![ScreenShot](https://raw.github.com/showkit/PhoneGap/master/www/img/phonegap_step5.png)
   * Import ShowKit.js on any html where you will use ShowKit.
     * ``<script type="text/javascript" src="js/ShowKit.js"></script>``

###Step 3. Configure the Other Linker Flag
   * Remove the ``-all_load`` linker flag. Then add ``-force_load "$(BUILT_PRODUCTS_DIR)/libCordova.a"`` and ``-lc++`` to your Other Linker Flags
     ![ScreenShot](https://raw.github.com/showkit/PhoneGap/master/www/img/phonegap_step6.png)

###Congratulations! Your Project is now ShowKit enabled. You can build and run your project.
