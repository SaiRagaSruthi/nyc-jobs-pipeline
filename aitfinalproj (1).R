#Research question2: Which job titles and categories are most frequently listed by the City of New York? 
library(dplyr)
library(lubridate)
library(ggplot2)
nycjobs_data <- read.csv("C:/Users/brown/Desktop/HW3/Jobs_NYC_Postings.csv")
frequent_jobs <- nycjobs_data %>%
  group_by(Business.Title, Job.Category) %>%
  summarise(count = n(), .groups = 'drop') %>%
  arrange(desc(count))

print(frequent_jobs)

top_frequent_jobs <- head(frequent_jobs, 10)

ggplot(top_frequent_jobs, aes(x=reorder(Business.Title, count), y=count, fill=Job.Category)) +
  geom_bar(stat="identity") +
  coord_flip() +  # Flips the axes
  labs(title="Top Job Titles and Categories in New York City", x="Job Title", y="Count")
#Research Question3:What differences exist in pay ranges across different job titles and categories?
library(ggplot2)
library(dplyr)
nycjobs_data$Salary.Range.From <- as.numeric(gsub("[^0-9.]", "", nycjobs_data$Salary.Range.From))
nycjobs_data$Salary.Range.To <- as.numeric(gsub("[^0-9.]", "", nycjobs_data$Salary.Range.To))
#Finding the  pay ranges and pay range difference for each job title and category
pay_ranges <- nycjobs_data %>%
  group_by(Business.Title, Job.Category) %>%
  summarise(
    Average_Minimum_Pay = mean(Salary.Range.From, na.rm = TRUE),
    Average_Maximum_Pay = mean(Salary.Range.To, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  mutate(pay_range_difference = Average_Maximum_Pay - Average_Minimum_Pay)
top_pay_ranges <- pay_ranges %>%
  top_n(20, wt = pay_range_difference) %>%
  arrange(desc(pay_range_difference))
top_pay_ranges$Business.Title <- factor(
  top_pay_ranges$Business.Title, 
  levels = top_pay_ranges$Business.Title[order(top_pay_ranges$Average_Minimum_Pay)]
)
ggplot(top_pay_ranges, aes(x = Business.Title)) +
  geom_segment(aes(xend = Business.Title, y = Average_Minimum_Pay, yend = Average_Maximum_Pay), 
               color = "grey", size = 0.8) +
  geom_point(aes(y = Average_Minimum_Pay), color = 'blue', size = 3, shape = 15) +
  geom_point(aes(y = Average_Maximum_Pay), color = 'red', size = 3, shape = 15) +
  coord_flip() +  # Flip the plot to horizontal
  labs(title = "Top Pay Ranges by Job Title and Category", 
       x = "Job Title", 
       y = "Pay ($)") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 8), axis.text.x = element_text(angle = 45, hjust = 1))
#Research Question 4: Which qualifications are most requested of applicants in various job postings?
library(dplyr)
library(tidyr)
library(stringr)
library(tidytext)
nycjobs_data <- nycjobs_data %>%
  filter(!is.na(Minimum.Qual.Requirements)) %>%
  mutate(Qualifications_Cleaned = tolower(Minimum.Qual.Requirements)) %>%
  mutate(Qualifications_Cleaned = str_replace_all(Qualifications_Cleaned, "[^[:alnum:] ]", " ")) %>%
  mutate(Qualifications_Cleaned = str_replace_all(Qualifications_Cleaned, "\\s+", " "))
words <- nycjobs_data %>%
  unnest_tokens(word, Qualifications_Cleaned)
word_counts <- words %>%
  count(word, sort = TRUE)
data("stop_words", package = "tidytext")
word_counts <- word_counts %>%
  anti_join(stop_words)
top_words <- word_counts %>%
  top_n(20, n)
ggplot(top_words, aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip() +  # Flip the plot to horizontal
  labs(title = "Top Requested Qualifications in NYC Job Postings", x = "Qualification", y = "Frequency") +
  theme_minimal()
