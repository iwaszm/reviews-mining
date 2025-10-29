library(httr)
library(jsonlite)

test <- httr::POST(
  url = "https://router.huggingface.co/hf-inference/models/facebook/bart-large-mnli",
  httr::add_headers(
    Authorization = paste("Bearer", Sys.getenv("HF_API_KEY")),
    `Content-Type` = "application/json"
  ),
  body = list(
    inputs = "I love the app",
    parameters = list(candidate_labels = c("positive", "neutral", "negative"))
  ),
  encode = "json",
  timeout(30)
)

# 检查HTTP状态码
if (test$status_code == 200) {
  # 尝试解析JSON
  response_text <- httr::content(test, as = "text", encoding = "UTF-8")
  result <- jsonlite::fromJSON(response_text)
  print(result)
} else {
  # 打印错误信息
  cat("请求失败，状态码：", test$status_code, "\n")
  # 打印响应内容
  response_text <- httr::content(test, as = "text", encoding = "UTF-8")
  cat("响应内容：", response_text, "\n")
}
