# R Code for graphing-your-data.qmd

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

  # Create a histogram in R
        data <- rnorm(100)
        hist(data, main = "Histogram of Data", xlab = "Values", col = "blue", border = "black")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Create a histogram in R
        data <- rnorm(100)
        hist(data, main = "Histogram of Data", xlab = "Values", col = "blue", border = "black")

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

 # Create a box plot in R
        data <- rnorm(100)
        boxplot(data, main = "Box Plot Example")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Create a box plot in R
        data <- rnorm(100)
        boxplot(data, main = "Box Plot Example")

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

 # Create a pie chart in R
        values <- c(10, 20, 30, 40)
        labels <- c("A", "B", "C", "D")
        pie(values, labels = labels, main = "Pie Chart Example")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Create a pie chart in R
        values <- c(10, 20, 30, 40)
        labels <- c("A", "B", "C", "D")
        pie(values, labels = labels, main = "Pie Chart Example")

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

# Create a scatter plot in R
        x <- rnorm(100)
        y <- rnorm(100)
        plot(x, y, main = "Scatter Plot Example", xlab = "X-axis", ylab = "Y-axis")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Create a scatter plot in R
        x <- rnorm(100)
        y <- rnorm(100)
        plot(x, y, main = "Scatter Plot Example", xlab = "X-axis", ylab = "Y-axis")

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

# Load the Titanic dataset
data(Titanic)

mosaicplot(~ Sex +Survived, data = Titanic, color = TRUE)


#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Create a mosaic plot in R
        library(vcd)
        data(Titanic)
        mosaic(Titanic, shade = TRUE, legend = TRUE)

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

# Create a bar chart in R
        categories <- c("A", "B", "C", "D")
        values <- c(10, 20, 30, 40)
        barplot(values, names.arg = categories, main = "Bar Chart Example", col = "blue")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Create a bar chart in R
        categories <- c("A", "B", "C", "D")
        values <- c(10, 20, 30, 40)
        barplot(values, names.arg = categories, main = "Bar Chart Example", col = "blue")

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

 # Create a quantile plot in R
        data <- rnorm(100)
        qqnorm(data)
        qqline(data, col = "blue")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Create a quantile plot in R
        data <- rnorm(100)
        qqnorm(data)
        qqline(data, col = "blue")

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

# Create a treemap in R
        library(treemap)
        
        data <- data.frame(
          category = c("A", "B", "C", "D"),
          subcategory = c("A1", "B1", "C1", "D1"),
          value = c(10, 20, 30, 40)
        )
        
        treemap(
          data,
          index = c("category", "subcategory"),
          vSize = "value",
          title = "Treemap Example"
        )

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Create a treemap in R
        library(treemap)
        
        data <- data.frame(
          category = c("A", "B", "C", "D"),
          subcategory = c("A1", "B1", "C1", "D1"),
          value = c(10, 20, 30, 40)
        )
        
        treemap(
          data,
          index = c("category", "subcategory"),
          vSize = "value",
          title = "Treemap Example"
        )

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

       # Create a time series plot in R
        time <- seq(from = as.Date("2022-01-01"), by = "month", length.out = 12)
        values <- rnorm(12, mean = 50, sd = 10)
        plot(time, values, type = "l", main = "Time Series Plot Example")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Create a time series plot in R
        time <- seq(from = as.Date("2022-01-01"), by = "month", length.out = 12)
        values <- rnorm(12, mean = 50, sd = 10)
        plot(time, values, type = "l", main = "Time Series Plot Example")

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

# Create a map in R
        library(ggplot2)
        library(maps)

        world_map <- map_data("world")
        ggplot(world_map, aes(x = long, y = lat, group = group)) +
          geom_polygon(fill = "lightblue", color = "white") +
          ggtitle("World Map Example")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Create a map in R
        library(ggplot2)
        library(maps)

        world_map <- map_data("world")
        ggplot(world_map, aes(x = long, y = lat, group = group)) +
          geom_polygon(fill = "lightblue", color = "white") +
          ggtitle("World Map Example")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Summarize unstructured text in R
        library(tm)
        library(wordcloud)

        text <- c("word1", "word2", "word3", "word1", "word2")
        corpus <- Corpus(VectorSource(text))
        tdm <- TermDocumentMatrix(corpus)
        word_freq <- sort(rowSums(as.matrix(tdm)), decreasing = TRUE)
        wordcloud(names(word_freq), word_freq, scale = c(3, 0.5), colors = brewer.pal(8, "Dark2"))