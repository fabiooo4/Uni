students <- 1:100 # Genera numeri da 1 a 100
grades <- matrix( # Genera una matrice
  round(runif(1000,4,10), digits = 0), # Genera 1000 numeri casuali da 4 a 10 arrotondandoli ad intero
  nrow = length(students) # Assegna al numero della colonna il numero dello studente
)
colnames(grades) <- paste("Test", seq(1,10,1)) # Assegna il nome alle colonne con numeri da 1 a 10, incrementati di 1
rownames(grades) <- paste("Student", students) # Assegna il nome alle colonne con Student e il numero dello studente

avg_grades <- rowMeans(grades) # Fa la media di tutti i voti di ogni studente
best_stud <- which(avg_grades == max(avg_grades)) # Ottiene lo studente migliore dall'array delle medie dei voti
cat("The best student is: student", best_stud) # Concatena più stringhe
cat("The avg quote of the best student is:", max(avg_grades))

insuf <- NULL
for(i in 1:nrow(grades)) {
  insuf[i] <- 0
  for(j in 1:ncol(grades)) {
    if(grades[i,j] < 6) {
      insuf[i] <- insuf[i] + 1
    }
  }
}

barplot(table(insuf)/100, xlab = "Number of insufficient tests",
        ylab = "Relative abundance",
        main = "Relative abundance of insufficient tests",
)
