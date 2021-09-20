import torch
import PIL
import os
import numpy as np
from PIL import Image
from sklearn.preprocessing import MinMaxScaler

path = r"C:\Users\bbfss\Desktop\Code\github\Denoising-CNN\训练集\干净信号txt"  # 干净文件夹目录
# path = r"C:\Users\bbfss\Desktop\Code\github\Denoising-CNN\训练集\带噪信号txt"  # 带噪文件夹目录
files = os.listdir(path)  # 得到文件夹下的所有文件名称
s = []
for file in files:  # 遍历文件夹
    if not os.path.isdir(file):  # 判断是否是文件夹，不是文件夹才打开
        f = open(path + "/" + file);  # 打开文件
        iter_f = iter(f);  # 创建迭代器
        str1 = ""
        for line in iter_f:  # 遍历文件，一行行遍历，读取文本
            str1 = str1 + line
        s.append(str1)  # 每个文件的文本存到list中
print(s)  # 打印结果

a = []
for x in s:
    l = []
    for i in x.split('\n'):
        if i == '':
            continue;
        l.append(float(i))
    a.append(np.array(l))

# 归一化操作， 可以使用MinMaxScaler()中的inverse_transform方法还原
min_max_scaler = MinMaxScaler()
a = min_max_scaler.fit_transform(a)

ph = []
for x in a:
    photo = np.zeros((1, 2000))
    #     photo[256][:][0]=x
    for i in range(2000):
        photo[0][i] = x[i]
    ph.append(photo.reshape(40, 50))

path = "C:/Users/bbfss/Desktop/Code/github/Denoising-CNN/训练集/干净灰度图/"
# path = "C:/Users/bbfss/Desktop/Code/github/Denoising-CNN/训练集/带噪灰度图/"
count = 0
for x in ph:
    count += 1
    new_im = Image.fromarray(x * 255.0)  # 实现array转化成图像
    num = str(count)
    new_im = new_im.convert('L')  # 将图像转化成灰度图
    new_im.save(path + 'train/img' + num + '.bmp')
