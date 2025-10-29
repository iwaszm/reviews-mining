# it does not work yet
library(openai)

# 1. Setup OPENAI_API_KEY in .Renviron
openai_key <- Sys.getenv("OPENAI_API_KEY")

# 2. a text to classify
news_title <- "特斯拉第三季度交付量大幅增长，股价盘后上涨"

# 3. Use OpenAI API to classify the text
textai <- create_chat_completion(
  model = "gpt-3.5-turbo",
  messages = list(
    list(role = "system", content = "你是一个文本分类助手，只回答'财经'、'科技'或'其他'其中之一。"),
    list(role = "user", content = paste0("请判断以下新闻标题属于财经、科技还是其他类别：", news_title))
  )
)

# 4. 输出分类结果
cat("分类结果：", textai$choices[[1]]$message$content)