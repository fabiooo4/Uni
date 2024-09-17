stoffe <- data.frame(
  rotolo = c("Rosso", "Blu", "Verde", "Damascato", "Fiori", "Pois",
             "Optical", "Geometrico", "Bimbo", "Leopardo", "Zebra"),
  lunghezza = c(7, 14.7, 8.7, 11.9, 7.9, 5.1, 8.3, 6.5, 9.2, 5.7, 12.7),
  buchi = c(3, 7, 4, 4, 1, 1, 3, 1, 4, 0, 3))  

coeffl <- cor(stoffe$lunghezza, stoffe$buchi)

linear <- lm(buchi ~ lunghezza, data = stoffe)
linear

plot(
  x = stoffe$lunghezza,
  y = stoffe$buchi,
  type = "p",
  main = "Correlazione lineare stoffe: buchi ~ lunghezza",
  xlab = "Lunghezza",
  ylab = "Buchi",
  pch = 16,
  col = "blue",
   )
grid(lty="dotted")

abline(linear$coefficients, col = "red")

nLunghezza <- 14
nBughi <- round(linear$coefficients[1] + nLunghezza * linear$coefficients[2])