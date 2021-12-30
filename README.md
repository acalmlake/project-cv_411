[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=6410724&assignment_repo_type=AssignmentRepo)
# 基于图像配准的 A Look Into the Past
成员及分工\
PB18051035 王旭 调研 代码 报告\
PB18151852 刘宇 调研 代码 报告
## 问题描述
对图像作变幻，看起来是一件相对简单且有趣的事。所以，我们在选了A Look Into the Past 为主题进行实验，通过残存的光影体会照片里的前世今生。

我们期望通过新旧照片特征匹配，实现图相配准(Image registration)，让旧照片融入到新照片中，达到A Look Into the Past的效果。%%我们采取的样本分为小图（旧照片）匹配大图（新照片）和大图（旧照片）匹配大图（新照片）两种
## 原理分析
图像配准是使用某种算法，基于某种评估标准，将一副或多副图片（局部）最优映射到目标图片上的方法。根据不同配准方法，不同评判标准和不同图片类型，有不同类型的图像配准方法。其中，最本质的分类是：
1. 基于灰度的图像配准；
2. 基于特征的图像配准。

具体的图像配准算法是基于这两点的混合或者变体的算法。我们采用的是基于特征的配准，大致流程为：

```mermaid
  graph LR
  A(输入图像)-->B[特征提取匹配]
  B-->C[构建变换矩阵]
  C-->D[新旧图像融合]
  D-->E(输出)
```
