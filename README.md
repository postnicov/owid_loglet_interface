# owid_loglet_interface
A set of MATLAB/Octave functions, which provide an interface to the data on COVID-19 from "Our World in Data" and their processing with Loglet Lab

The script **owidCOVIDload.m** is aimed at automated downloading the full set of data on COVID-19 collected by "Our World in Data" (all data up to the day, when the script is run) and converting the records on the dynamics of total cases for a chosen country into the text file suitable for the subsequent processing with Loglet Lab.

The script **plotLogLetoutput.m** reads the standard output of the Loglet Lab 4 software saved as .xlsx file with the name coinciding with the name of the file, which was used as an input with the word *_download* added. The text file *processed_file_info.txt* created by the script **owidCOVIDload.m**, which contains the name of the file used by Loglet Lab, a country's name, and the dates corresponding to the numerical list of days is used during the data reading and processing.

Two examples are provided in the folder "Examples", each of them contains the data already processed with Loglet Lab and can be used for plotting via **plotLogLetoutput.m**.

The project is related to the mathematical model considered in the work  
- [Postnikov, E.B. Estimation of COVID-19 dynamics “on a back-of-envelope”: Does the simplest SIR model provide quantitative parameters and predictions? *Chaos, Solitons & Fractals* **135** (2020) 109841](https://www.sciencedirect.com/science/article/pii/S0960077920302411)

and provides an extended code with better usability.
