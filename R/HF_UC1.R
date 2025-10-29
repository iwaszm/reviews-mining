library(httr)
library(jsonlite)

# 1. Setup HuggingFace_API_KEY in .Renviron
hf_key <- Sys.getenv("HF_API_KEY")

# 2. Define input text, labels, and models
input_text <- "I am ok with the UI, it can be better though"
labels <- c("positive", "negative", "neutral")
models <- list(
  "facebook/bart-large-mnli" = "https://api-inference.huggingface.co/models/facebook/bart-large-mnli",
  "joeddav/xlm-roberta-large-xnli" = "https://api-inference.huggingface.co/models/joeddav/xlm-roberta-large-xnli",
  "cardiffnlp/twitter-roberta-base-sentiment-latest" = "https://api-inference.huggingface.co/models/cardiffnlp/twitter-roberta-base-sentiment-latest",
  "nlptown/bert-base-multilingual-uncased-sentiment" = "https://api-inference.huggingface.co/models/nlptown/bert-base-multilingual-uncased-sentiment"
)

# 3. Prepare headers for authentication
headers <- add_headers(
  Authorization = paste("Bearer", hf_key),
  `Content-Type` = "application/json",
  Accept = "application/json"
)

# 4. Function to call Hugging Face API
for (model_name in names(models)) {
  url <- models[[model_name]]
  
  # Prepare body based on model type
  if (grepl("mnli|xnli", model_name)) {
    body <- list(inputs = input_text, parameters = list(candidate_labels = labels))
  } else {
    body <- list(inputs = input_text)
  }
  
  cat("🔍 Model:", model_name, "\n")
  res <- POST(url, headers, body = body, encode = "json")
  result <- content(res, as = "parsed", encoding = "UTF-8")
  
  if (is.null(result$error)) {
    print(result)
  } else {
    cat("❌ Error:", result$error, "\n")
  }
  cat("\n-----------------------------\n\n")
}
