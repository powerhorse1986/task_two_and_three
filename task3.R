if(!require("optparse")) {
  install.packages("optparse")
}
if(!require("biomaRt")) {
  install.packages("biomaRt")
}
if(!require("tidyverse")) {
  install.packages("tidyverse")
}
setwd(getwd())
library(ggplot2)
library(tidyverse)
library(biomaRt)

# build the option list
option_list <- list(
  make_option(c("-i", "--input"), type = "character", default = NULL,
              help = "path to input file", metavar = "character"),
  make_option(c("-o", "--output"), type = "character", default = "./out.pdf",
              help = "path to output file [default = %default]", metavar = "character")
)

# parse the option list
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# check if input file is given
if(is.null(opt$input)) {
  print_help(opt_parser)
  stop("At least one argument should be supplied (input file).n", call. = FALSE)
}

if(!file.exists(opt$input)) {
  stop("Input file does not exist, please make sure input a correct file path",
       call. = FALSE)
}


# read the Homo_sapiens.gene_info.gz into a dataframe with selected columns
df <- read_tsv(gzfile(opt$input)) %>%
  select(c(chromosome, Symbol)) 
  
# drop those rows with chromosome values contain "|" or "-
df <- df[!str_detect(df$chromosome, '\\|') & !str_detect(df$chromosome, "-"), ]


plot_df <- df %>%
  group_by(chromosome) %>%
  summarise(gene_count = n())

plot <- ggplot(data = plot_df, 
       aes(x = factor(chromosome, levels = c(1 : 22, "X", "Y", "MT", "Un")), 
           y = gene_count)) +
  geom_col() +
  ggtitle("Number of genes in each chromosome") +
  xlab("Chromosomes") + 
  ylab("Gene count") + 
  theme(
    panel.background = element_rect(fill = "transparent"),
    plot.background = element_rect(fill = "transparent", color = NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_line(color = "black")
  )
pdf(opt$output)
print(plot)
dev.off()
