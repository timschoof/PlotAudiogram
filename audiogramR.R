######### AudiogramR ##################
#
# Plot audiograms in R
#
# DataFile = name of your .csv data file (contained in the same folder as this script)
# SaveAs = file extension of the saved audiogram figure (e.g. tiff, jpg, pdf)
# ExperimentalGroup = name of your experimental group (can be left empty)
# ControlGroup = name of your control group (can be left empty)
#
########################################
# Tim Schoof - April 2019              #
# github.com/timschoof/PlotAudiogram   #
########################################

audiogramR <- function(DataFile,SaveAs,ExperimentalGroup,ControlGroup){

# Load relevant packages (and install them if necessary)
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(here)) install.packages("here")

# Read data file
data<-read_csv(here(paste(DataFile,".csv",sep="")))

# Reformat the data for plotting
d<- data %>% 
  gather(key = "ear-freq", value = "dB",-participant,-group) %>% 
  separate(col = "ear-freq", into = c("ear","freq"), sep = (1)) %>%
  mutate(freq = (type.convert(freq))/1000) %>% 
  mutate(freqLabels = formatC(freq, format="g")) %>% 
  mutate(ear = factor(ear, levels = c("R", "L"))) %>%
  mutate(ear = recode(ear, "R" = "Right", "L" = "Left")) 

# Divide the data into subsets
# Experimental group
if (!missing(ExperimentalGroup)) {
  patient <- d %>%
    subset(group %in% ExperimentalGroup)
} else{
  patient <- d
}

# Control group (if it exists)
if (!missing(ControlGroup)) {
control <- d %>%
  subset(group %in% ControlGroup) %>% 
  group_by(freq, ear) %>% 
  summarize(mindB = min(dB), maxdB = max(dB)) %>% 
  gather(key = "participant", value = "dB",-freq, -ear)
}

# Plot audiogram
p <- ggplot()+
  facet_grid(. ~ ear) +
  geom_line(data = patient, aes(x=freq, y=dB, group=participant))
  if (!missing(ControlGroup)) {
    p <- p + geom_area(data = control, aes(x=freq, y=dB, group=participant),
              fill="grey", alpha=.7)
      }
  p + scale_y_reverse(limits = c(100,-10), breaks = seq(-10, 100, by=10))+
  scale_x_log10(breaks =unique(d$freq), labels = unique(d$freqLabels))+
  theme_bw()+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14),
        strip.text.x = element_text(size = 12))+
  labs(x = "Frequency (kHz)", y = "Threshold (dB HL)")+
  stat_summary(data = patient,
               aes(x=freq, y=dB,group=ear), 
               fun.y=mean, 
               geom="line", lwd = 1.5)

# save audiogram
ggsave(here(paste("audiogram",SaveAs,sep=".")))
}