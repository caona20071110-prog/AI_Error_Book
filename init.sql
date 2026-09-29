-- ============================================================
-- AI错题本系统 - 数据库初始化脚本
-- ============================================================
-- 适用数据库：MySQL 5.7+ / 8.0+
-- 字符集：utf8mb4
-- 说明：本脚本用于在评委电脑上初始化项目所需的数据库和表结构
-- ============================================================

-- 1. 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS `ai_error_book` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `ai_error_book`;

-- 2. 删除旧表（如果存在，避免重复创建报错）
DROP TABLE IF EXISTS `error_question`;

-- 3. 创建错题表
CREATE TABLE `error_question` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `question_content` TEXT NOT NULL COMMENT '题目原文',
  `answer_content` TEXT COMMENT '参考答案',
  `analysis` TEXT COMMENT '解题解析',
  `img_url` VARCHAR(500) DEFAULT NULL COMMENT '图片地址',
  `user_id` BIGINT(20) DEFAULT NULL COMMENT '用户ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='错题表';

-- 4. 插入示例数据（可选，评委测试用）
INSERT INTO `error_question` (`question_content`, `answer_content`, `analysis`, `user_id`, `create_time`) VALUES
('求极限 lim(x->0) sin(3x)/tan(5x)', '3/5', '当x趋近于0时，sin(3x)等价于3x，tan(5x)等价于5x，因此原式=3x/5x=3/5。利用等价无穷小替换求解。', 1, NOW()),
('设A为3阶方阵，det(A)=2，求det(2A^(-1))', '4', '根据行列式性质：det(kA)=k^n*det(A)，det(A^(-1))=1/det(A)。因此det(2A^(-1))=2^3*det(A^(-1))=8*(1/2)=4。', 1, NOW()),
('设随机变量X服从正态分布N(2,9)，求P(X>5)', '约0.1587', '标准化：Z=(X-μ)/σ=(5-2)/3=1。查标准正态分布表得P(Z>1)=1-Φ(1)约等于1-0.8413=0.1587。', 1, NOW());

-- ============================================================
-- 初始化完成！
-- 数据库名：ai_error_book
-- 表名：error_question
-- 示例数据：3条
-- ============================================================
