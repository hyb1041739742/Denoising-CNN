% signal = load("C:\Users\bbfss\Desktop\file\Code\github\Denoising-CNN\Denoising-CNN_2.0\实验数据保存\论文图像数据\剖面\FDUDDnCNN.txt")
% Clean , Noisy, FUDDnCNN, FDUDnCNN_Improve， Residual
FDUDnCNN_Improve = load("C:\Users\bbfss\Desktop\file\Code\github\Denoising-CNN\Denoising-CNN_2.0\实验数据保存\论文图像数据\剖面\模拟信号剖面\FDUDnCNN_Improve.txt")
FDUDDnCNN = load("C:\Users\bbfss\Desktop\file\Code\github\Denoising-CNN\Denoising-CNN_2.0\实验数据保存\论文图像数据\剖面\模拟信号剖面\FDUDDnCNN.txt")
Clean = load("C:\Users\bbfss\Desktop\file\Code\github\Denoising-CNN\Denoising-CNN_2.0\实验数据保存\论文图像数据\剖面\模拟信号剖面\Clean.txt")
Noisy = load("C:\Users\bbfss\Desktop\file\Code\github\Denoising-CNN\Denoising-CNN_2.0\实验数据保存\论文图像数据\剖面\模拟信号剖面\Noisy.txt")
Residual = load("C:\Users\bbfss\Desktop\file\Code\github\Denoising-CNN\Denoising-CNN_2.0\实验数据保存\论文图像数据\剖面\模拟信号剖面\Residual.txt")

FDUDnCNN_Improve = permute(FDUDnCNN_Improve,[2 1])
FDUDDnCNN = permute(FDUDDnCNN,[2 1])
Clean = permute(Clean,[2 1])
Noisy = permute(Noisy,[2 1])
Residual = permute(Residual,[2 1])

s_wplot(Clean)
s_wplot(Noisy)
s_wplot(Residual)
s_wplot(FDUDDnCNN)
s_wplot(FDUDnCNN_Improve)

hold on
x1 = [3720, 3747, 3740, 3780, 3822, 3840, 3770, 3818, 3679, 3726]
x2 = [3721, 3672, 905, 1520, 3353, 5007, 3769, 1520, 3929, 3729]
x3 = [3721, 3744, 3737, 3656, 3704, 3841, 4497, 3656, 3680, 3728]
x4 = [3719, 3747, 3740, 3820, 3823, 3840, 3772, 3820, 3679, 3725]
h1 = plot(x1, 'o', 'Markersize', 12, 'LineWidth', 1.5)
h2 = plot(x2, 'p', 'Markersize', 12, 'LineWidth', 1.5)
h3 = plot(x3, '*', 'Markersize', 12, 'LineWidth', 1.5)
h4 = plot(x4, '+', 'Markersize', 12, 'LineWidth', 1.5)
hold off
legend([h1, h2, h3, h4], 'Ground Truth', 'PSPNet\_R50', 'PSPNet\_R101', 'Improved PSPNet')