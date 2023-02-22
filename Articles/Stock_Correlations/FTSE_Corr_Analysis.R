# Set Perpetual Prudence Themes
  
  theme_set(theme_minimal())
  set.seed(336)
  
  #For resetting par - dev.off()
  
  par(family = "serif")
  options(scipen = 0.5)
  
# Import required packages
  
  #install.packages('quantmod')
  library(quantmod)
  
# List of companies to look at: https://www.fidelity.co.uk/shares/ftse-100/
# https://dailypik.com/uk100-companies/
  
company_ticks <- c('AZN.L', 'SHEL.L', 'HSBA.L', 'ULVR.L')

for (ticker in company_ticks) {
  assign(paste0("close_price_", ticker),
         na.omit(data.frame(getSymbols.yahoo(ticker, auto.assign = FALSE)))[paste(ticker, '.Close', sep='')])
}
