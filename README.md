错题本 AI 助手（ai-error-book）
基于 Spring Boot 4 的错题识别与解答服务：上传错题图片，自动 OCR 识别题目文字，调用 DeepSeek 大模型生成答案与解题解析。
________________________________________
运行环境
依赖	要求
JDK	17 及以上
MySQL	8.0.34（默认端口 3306）
端口	8080
________________________________________
快速开始
1. 准备数据库
在 MySQL 中执行以下 SQL（创建数据库和错题表）：
CREATE DATABASE IF NOT EXISTS ai_error_book DEFAULT CHARACTER SET utf8mb4;

USE ai_error_book;

CREATE TABLE IF NOT EXISTS error_question (
    id BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    question_content TEXT COMMENT '题目原文',
    answer TEXT COMMENT '答案',
    analysis TEXT COMMENT '解析',
    img_url VARCHAR(500) COMMENT '图片地址',
    user_id BIGINT COMMENT '用户id',
    create_time DATETIME COMMENT '创建时间',
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='错题表';
也可执行项目目录下的 sql/init.sql 初始化脚本，该脚本会自动创建数据库、建表并插入 3 条示例数据，评委拿到后可直接运行查看效果。
2. 配置密钥（必做）
应用通过环境变量注入密钥，启动前必须设置以下三个变量：
环境变量	说明	获取方式
ALIYUN_ACCESS_KEY_ID	阿里云 AccessKeyId	阿里云控制台 → AccessKey 管理
ALIYUN_ACCESS_KEY_SECRET	阿里云 AccessKeySecret	同上（需开通「文字识别 OCR」服务）
DEEPSEEK_API_KEY	DeepSeek API Key	https://platform.deepseek.com → API Keys
IDEA 配置方式：
1.	菜单栏选择 Run → Edit Configurations...
2.	在 Environment variables 字段中添加上述三个变量
3.	点击 Apply → OK
命令行启动方式（Linux/Mac）：
export ALIYUN_ACCESS_KEY_ID=你的AccessKeyId
export ALIYUN_ACCESS_KEY_SECRET=你的AccessKeySecret
export DEEPSEEK_API_KEY=你的DeepSeekApiKey
mvn spring-boot:run
命令行启动方式（Windows PowerShell）：
$env:ALIYUN_ACCESS_KEY_ID="你的AccessKeyId"
$env:ALIYUN_ACCESS_KEY_SECRET="你的AccessKeySecret"
$env:DEEPSEEK_API_KEY="你的DeepSeekApiKey"
mvn spring-boot:run
3. 配置数据库（可选）
默认连接 jdbc:mysql://localhost:3306/ai_error_book，用户名 root，密码 0735。
如需修改，可直接编辑 src/main/resources/application.yml 中的数据库配置，或通过设置以下环境变量覆盖（Spring Boot 自动识别）：
# Linux/Mac
export SPRING_DATASOURCE_URL="jdbc:mysql://localhost:3306/ai_error_book?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false"
export SPRING_DATASOURCE_USERNAME="root"
export SPRING_DATASOURCE_PASSWORD="你的密码"

# Windows PowerShell
$env:SPRING_DATASOURCE_URL="jdbc:mysql://localhost:3306/ai_error_book?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false"
$env:SPRING_DATASOURCE_USERNAME="root"
$env:SPRING_DATASOURCE_PASSWORD="你的密码"
4. 启动项目
IDEA 启动：直接运行主类 com.koiyy.AiErrorBookApplication。
命令行打包启动：
mvn clean package
java -jar target/ai-error-book-0.0.1-SNAPSHOT.jar
5. 访问系统
启动成功后，浏览器访问：http://localhost:8080
________________________________________
接口说明
系统共提供 8 个 RESTful 接口，分为 错题管理 和 OCR/AI解题 两大模块。详细接口文档（含请求参数、响应示例）请参考同目录下的 AI错题本系统_接口文档.docx。
错题管理模块（/api/question）
方法	路径	说明
POST	/api/question/add	新增错题
GET	/api/question/list	查询全部错题
GET	/api/question/{id}	根据ID查询
PUT	/api/question/update	修改错题
DELETE	/api/question/delete/{id}	删除错题
GET	/api/question/page	分页查询用户错题
OCR 与 AI 解题模块（/api/ocr）
方法	路径	说明
POST	/api/ocr/recognize	图片文字识别
POST	/api/ocr/solve	AI 智能解题
OCR 识别文字接口：
•	路径：POST /api/ocr/recognize
•	参数：multipart/form-data，字段 file（图片文件）
•	返回：识别出的文字内容
成功响应：
{ "code": 1, "msg": "成功", "data": "识别出的题目文字" }
失败响应：
{ "code": 0, "msg": "OCR识别失败：...", "data": null }
错题解答接口（OCR + AI 解析）：
•	路径：POST /api/ocr/solve
•	参数：multipart/form-data，字段 file（错题图片）
•	返回：题目原文 + 答案 + 解析
成功响应：
{ "code": 1, "msg": "成功", "data": { "questionContent": "题目", "answer": "答案", "analysis": "解析" } }
失败响应：
{ "code": 0, "msg": "处理失败：...", "data": null }
DeepSeek-V4-Pro 默认开启思考模式，单次解答通常需要 10~60 秒，请耐心等待。
________________________________________
常见问题
现象	原因与解决
启动报 Could not resolve placeholder	环境变量未配置，见「配置密钥」部分
OCR 报 Specified access key is not found or invalid	AccessKey 已作废或 ID/Secret 不是同一对，去阿里云控制台重新生成一对
OCR 报未授权	阿里云账号未开通「文字识别 OCR」服务
DeepSeek 报 401	DEEPSEEK_API_KEY 无效或已删除
连不上数据库	检查 MySQL 是否启动、库表是否已初始化、环境变量覆盖是否正确
上传图片报 413	默认文件大小上限 10MB，超出会拒绝
________________________________________
说明
•	密钥需通过环境变量注入，jar 包内不含任何密钥
•	阿里云 OCR 使用 2021-07-07 新版接口，DeepSeek 使用 deepseek-v4-pro 模型
•	前端为纯静态 HTML/CSS/JS，由 Spring Boot 直接托管，无需额外部署 Web 服务器
