# Data Adquisition

# Data Acquisition

## **Description**

This software allows to record hand gesture Emg and orientation signals using a surface Emg device. Compatible devices are Myo Armband and gForce Pro.

The data collected in this interface is fully compatible with [Manual Segmentation](https://github.com/laboratorioAI/manualSegmentation).

## **Prerequisites**

## **Myo**

Using the Myo Armband has an easier installation procedure. Check the [MyoMex repository](https://github.com/mark-toma/MyoMex) for the tutorial installation. We have included in this repository a copy of MyoMex.


![image.png](/images/README/image2.png)


## **Gforce**

The **gForce_mex** function must be compiled and added to the path. If you receive an error about it, check the gForce_interface project for help.

## Including Gforce in th

### Required Software

MYO Connect SDK: 0.9.0

MATLAB: Version 2023B or higher

Data Acquisition: Version established in:

[GitHub - laboratorioAI/dataAcquisition: Matlab graphic interface to record EMG signals from hand gestures measured with Myo Armband or GForce Pro.](https://github.com/laboratorioAI/dataAcquisition)

### Recommended Hardware

Operating System: Windows 10 or higher

Processor: Intel i5 6th generation, with a clock speed of at least 3.60 GHz

RAM: more than 10 GB

Storage: 12 GB of free disk space for MATLAB installation, along with Toolboxes and MYO Connect installation.

## **Installation and Connection of Myo**

To use the Myo armband with our computer, it is necessary to install the required software to connect it and receive the signals.

At the following link, you can download the various installers:

[https://drive.google.com/drive/folders/10lPDZ2VtnKZBWrFkTThiKI6hKaMzjYIT?usp=sharing](https://drive.google.com/drive/folders/10lPDZ2VtnKZBWrFkTThiKI6hKaMzjYIT?usp=sharing)

We need to connect the Bluetooth adapter to our computer, and it is important to mention that the adapter must remain connected while we are using the Myo. Once the Myo is synchronized, the following bubble will appear on our screen with this message.

## **Running Myo SDK and Setting Environment Paths**

To use the Myo in our program, it is necessary to install the Myo SDK (Myo Software Development Kit), as it allows us to access movement data and use it in our applications. We can find the file at:

[https://drive.google.com/drive/folders/10lPDZ2VtnKZBWrFkTThiKI6hKaMzjYIT?usp=sharing](https://drive.google.com/drive/folders/10lPDZ2VtnKZBWrFkTThiKI6hKaMzjYIT?usp=sharing)

Once we have the folder “myo-sdk-*-0.9.0” unzipped, we enter it and copy the path of the "bin" folder.

Next, go to environment variables, edit the PATH variable, and paste the path we just copied.

## **System Operation**

Once the project is on our computer, we simply need to run the script `ejecutar.m`. We must select a user and then in Gesture Selector G5. The following window will open.



On the right side of the window, we have a panel labeled "User Information" where we input the various data collected from the user, such as: age, occupation, gender, dominant hand, temperature, pressure, SpO2, weight, and height.

There is a "Survey" button that opens a window with a set of questions to be filled out with the user’s answers.

In "Device Connection", by pressing one of the buttons according to the device we are going to use, our program will automatically connect to it.


![image.png](/images/README/image1.png)


If the armband is successfully connected, the sample recording will be enabled.


![image.png](/images/README/image.png)



In the central part of the screen, we have the "Sample" panel, which is divided into three sections. In the "Sample" area, there are two buttons: RECORD and REPEAT. RECORD is used to capture a new sample, and REPEAT allows us to repeat the last sample in case of any issues.

In the central zone, images and GIFs are displayed, which serve to indicate the gesture to be performed at that moment. The images or GIFs will appear when the sampling process begins.

Finally, in the "Acquisition" zone, pressing the "New" button generates a new session to capture samples, while "Resume" is a button that allows us to resume sampling if there is any interruption.


To take a sample, as mentioned before, press the “RECORD” button, which starts a countdown from 3, while a bar indicates the duration of the sample through its movement. The respective gesture must be performed when the GO symbol appears.

Finally, after the sample is taken, in the lower section there is an area labeled "Device Signals" that will graphically display the signals taken by the various sensors of the armband.


![image.png](/images/README/image3.png)


Once all 50 samples for each of the 6 gestures are taken, the application will automatically close.

## **Additional important notes**

### **gForce SDK issues**

1. The gForce library is still in beta. There are some issues with the SDK that may difficult data acquisition. Please, be aware of the following issues:
2. In the case of a Run Time Error in the C++ MEX function, Matlab will crash inmediately and close itself. The device must be restarted manually.
3. Battery level sometimes returns 0%. This is the response from the device (the SDK not the C++ MEX function). It may not correspond to a completely empty battery, as in some tests afterwards the command returned a value (e.g. 77%).
4. Emg data is encoded in 8 or 12 bits. So, it should be centered at 128 or 2048, but it is not. The reference is slightly moved down. At 8 bits it is centered in 118 and at 12 bits, in 2000.
5. Gesture predictions are currently unavailable due to empty responses from the device.

### **Myo Armband connector**

We included in this repository the [MyoMex connector](https://github.com/mark-toma/MyoMex). Special thanks to @mark-toma.

## **Manual Segmentation**

After finishing the recordings in this interface, to carry on with the manual segmentation procedure, do the following:

1. Copy the data of all users (i.e. the content of this **./data/** folder except the README.md file) to the **/manualSegmentation/data/** folder in Manual Segmentation repository.
2. Run the script **/manualSegmentation/ejecutar.m** in manual segmentation repository.

## **Citation**

If you use this Data Acquisition System, please refer and cite the following paper:

[J. Zea, M. E. Benalcázar, L. I. Barona Lôpez and Á. L. Valdivieso Caraguay, "An Open-Source Data Acquisition and Manual Segmentation System for Hand Gesture Recognition based on EMG," 2021 IEEE Fifth Ecuador Technical Chapters Meeting (ETCM), Cuenca, Ecuador, 2021, pp. 1-6, doi: 10.1109/ETCM53643.2021.9590811.](https://github.com/laboratorioAI/dataAcquisition)

Changelog:

- v1.7 | June 21st, 2024 | Inclues GUI to survey and optimization of the data collection process.
- v1.6 | June 26th, 2023 | Inclues GUI to gesture set selection.
- v1.5.1 Updated recolectors and list of devices.
- v1.5 Version of dataset G11.
