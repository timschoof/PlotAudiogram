# PlotAudiogram

R code to plot audiogram data. Main code: audiogramR.R

## Parameters
audiogramR(DataFile,SaveAs,ExperimentalGroup,ControlGroup)

DataFile = name of your .csv data file (contained in the same folder as this script) <br/>
SaveAs = file extension of the saved audiogram figure (e.g. tiff, jpg, pdf) <br/>
ExperimentalGroup = name of your experimental group (can be left empty) <br/>
ControlGroup = name of your control group (can be left empty)
<br/> <br/>

## Running the code

Load the audiogramR function by typing source("audiogramR") in the command line. 

Note that all parameters should be in inverted commas. For example: audiogramR("ExampleData","pdf","patient","control")

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2633064.svg)](https://doi.org/10.5281/zenodo.2633064)


