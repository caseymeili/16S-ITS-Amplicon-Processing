# plotting of rodent lung 16S and ITS data 
# stacked bar charts for genera abundance by sample
# bar charts for Good's Coverage Index and number of high quality sequences per sample

library(tidyr)
library(ggplot2)
library(pals)
library(readxl)
library(dplyr)

# 16S PLOTTING
# import data
# data formatted as mothur taxonomy file with everything except taxa and counts per sample removed
# low abundance genera summed and grouped as "other genera"
bact.data <- read_excel("~/Desktop/Amplicon-Data/mothur/plotting.xlsx", sheet="16S") 

# reshape the data for ggplot
df_long_bac <- gather(bact.data, key = "Sample", value = "Value", -taxon, -total)

# manually set the order of taxon and corresponding colors
taxon_order_bac <- unique(df_long_bac$taxon)
df_long_bac$taxon <- factor(df_long_bac$taxon, levels = taxon_order_bac)

# create the stacked bar chart
ggplot(df_long_bac, aes(x = Sample, y = Value, fill = taxon)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_manual(values=as.vector(stepped3(16)), name="Genus") +
  labs(title = "16S",
       x = "Sample Number",
       y = NULL) +
  scale_x_discrete(breaks = c("Rodent-1", "Rodent-2", "Rodent-3", "Rodent-4"),
                   labels = c("1", "2", "3", "4")) +  
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, vjust = -3), 
        axis.text.y = element_blank(),        
        axis.ticks.y = element_blank()) 

# save plot
output_path <- "/Users/caseymeili/Downloads/rodentlungs-16S.pdf"
ggsave(output_path, plot=last_plot())

# ggsave("updatedfinalmap.jpg", plot=last_plot(), height=720, width=1280, units="px")


######################################################

# ITS PLOTTING
# import data
# data formatted as mothur taxonomy file with everything except taxa and counts per sample removed
# low abundance genera summed and grouped as "other genera"
fungi.data <- read_excel("~/Desktop/Amplicon-Data/mothur/plotting.xlsx", sheet="ITS")

 # reshape the data for ggplot
df_long_fung <- gather(fungi.data, key = "Sample", value = "Value", -taxon, -total)

# manually set the order of taxon and corresponding colors
taxon_order_fung <- unique(df_long_fung$taxon)
df_long_fung$taxon <- factor(df_long_fung$taxon, levels = taxon_order_fung)

# create the stacked bar chart
ITS_plot <- ggplot(df_long_fung, aes(x = Sample, y = Value, fill = taxon)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_manual(values=as.vector(stepped3(16)), name="Genus") +
  labs(title = "ITS",
       x = "Sample Number",
       y = NULL) +
  scale_x_discrete(breaks = c("Rodent-1", "Rodent-2", "Rodent-3", "Rodent-4"),
                   labels = c("1", "2", "3", "4")) +  
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, vjust = -3), 
        axis.text.y = element_blank(),        
        axis.ticks.y = element_blank()) 
ITS_plot
# save plot
output_path <- "/Users/caseymeili/Downloads/rodentlungs-ITS.pdf"
ggsave(output_path, plot=last_plot())


######################################################

# COVERAGE PLOTTING
# import data
# data is good's coverage index value for each sample computed using mother/1.48.0 command summary.single
coverage.data <- read_excel("~/Desktop/Amplicon-Data/mothur/plotting.xlsx", sheet="Coverage")

# reshape the data for ggplot
coverage_long <- coverage.data %>%
  gather(key = "Sample", value = "Value", -Type)

# Filter out non-numeric rows
coverage_long_numeric <- coverage_long %>%
  filter(grepl("^\\d+\\.?\\d*$", Value))
coverage_long_numeric$Value <- as.numeric(as.character(coverage_long_numeric$Value))

# create bar chart
ggplot(coverage_long_numeric, aes(x = Sample, y = Value, fill = Type)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  scale_fill_manual(values=c("#4880B8","#7AACD2"), name="Amplicon") +
labs(title = "Coverage",
       x = "Sample Number",
       y = "Good's Coverage Index") +
  scale_x_discrete(breaks = c("Rodent-1", "Rodent-2", "Rodent-3", "Rodent-4"),
                   labels = c("1", "2", "3", "4")) +  
  scale_y_continuous(limits = c(0, 1)) +
  geom_text(aes(label = round(Value, 4)),
            position = position_dodge(width = 0.7),
            vjust = -0.5, size = 2.5, color = "black") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, vjust = 0), 
        axis.ticks.y = element_blank()) 

output_path <- "/Users/caseymeili/Downloads/rodentlungs-coverage.pdf"
ggsave(output_path, plot=last_plot())

######################################################

# HIGH QUALITY SEQUENCE NUMBER PLOTTING
# import data
# data is the number of sequences following every processing step, computed using mother/1.48.0 command count.groups
coverage.data <- read_excel("~/Desktop/Amplicon-Data/mothur/plotting.xlsx", sheet="HQ")

# reshape the data for ggplot
coverage_long <- coverage.data %>%
  gather(key = "Sample", value = "Value", -Type)

# Filter out non-numeric rows
coverage_long_numeric <- coverage_long %>%
  filter(grepl("^\\d+\\.?\\d*$", Value))
coverage_long_numeric$Value <- as.numeric(as.character(coverage_long_numeric$Value))

# create bar chart
ggplot(coverage_long_numeric, aes(x = Sample, y = Value, fill = Type)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  scale_fill_manual(values=c("#D55F2B", "#EE934F"), name="Amplicon") +
  labs(title = "Number of High Quality Sequences",
       x = "Sample Number",
       y = "Number of High Quality Sequences") +
  scale_x_discrete(breaks = c("Rodent-1", "Rodent-2", "Rodent-3", "Rodent-4"),
                   labels = c("1", "2", "3", "4")) +  
  #scale_y_continuous(limits = c(0, 1)) +
  geom_text(aes(label = round(Value, 4)),
            position = position_dodge(width = 0.7),
            vjust = -0.5, size = 2.5, color = "black") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, vjust = 0), 
        axis.ticks.y = element_blank()) 

output_path <- "/Users/caseymeili/Downloads/rodentlungs-hq.pdf"
ggsave(output_path, plot=last_plot())



