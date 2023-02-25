# Set Perpetual Prudence Themes
  
  theme_set(theme_minimal())
  set.seed(336)
  
  #For resetting par - dev.off()
  
  par(family = "serif")
  options(scipen = 0.5)
  
# Import required packages
  
  #install.packages('quantmod')
  #install.packages("devtools")
  library(quantmod)
  #library(tidyverse)
  library(glue)
  
  
# List of companies to look at: https://www.fidelity.co.uk/shares/ftse-100/
# https://dailypik.com/uk100-companies/

### Daily Correlation ###
  
corr_freq = "Daily"
  
company_ticks <- c('AZN.L', 'SHEL.L', 'HSBA.L', 'ULVR.L')

for (ticker in company_ticks) {
  
  #get data and transform
  df <- na.omit(data.frame(getSymbols.yahoo(ticker, auto.assign = FALSE)))[paste(ticker, '.Close', sep='')]
  #get return df
  ret_df <- data.frame(dailyReturn(as.xts(df))) #CHANGE FREQUENCY
  #add date columns and set indexes
  df <- cbind(Date=rownames(df), df)
  rownames(df) <- 1:nrow(df)
  ret_df <- cbind(Date=rownames(ret_df), ret_df)
  rownames(ret_df) <- 1:nrow(ret_df)
  #merge that shit
  df <- merge(df, ret_df, by="Date", all.x=TRUE)
  #rename return column
  colnames(df)[3] = paste(ticker, glue('.{corr_freq}Ret'), sep='')
  #assign to close_price_X
  assign(paste0("price_ret_", ticker), df)
  
}

# Cross correlation

  # Join
  cov_mat <- price_ret_AZN.L
    for (pr_df in list(price_ret_HSBA.L, price_ret_SHEL.L, price_ret_ULVR.L)) {
      cov_mat <- merge(cov_mat, pr_df, by="Date", all=FALSE)
    }
  cov_mat
  # Select return columns
  ret_name_list <- vector(length=4)
  for (i in 1:4) {
    ret_name_list[i] <- glue('{company_ticks[i]}.{corr_freq}Ret')
  }
  # Get covarance
  ret_cov <- cov_mat[ret_name_list]
  cov(ret_cov)
  
  
  