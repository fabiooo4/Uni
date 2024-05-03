library(ggplot2)

# moneta regolare
n = 50
x = rbinom(n, 1, 0.5)

ggplot(data.frame(x), aes(x = x)) + 
  geom_bar(aes(y = (..count..)/sum(..count..))) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(breaks = c(0, 1), labels = c("Croce", "Testa")) +
  labs(title = "Moneta regolare", x = "Esito", y = "Frequenza")
