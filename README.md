# -招行卡号识别
配置需要Matlab R2016b

1.算法设计

1.1模型设计

1.1.1卡号识别模型

采用传统方法粗分割出卡号区域，训练CNN网络识别10个字符以及背景，采用滑动框顺序搜索被分割区域，按顺序列出分类概率最高的16个数字，即是被识别卡的银行卡号。
1.1.2信用卡识别模型

不同信用卡识别采用训练R-CNN网络进行识别。

1.2卡号识别算法分析

1.2.1粗分割卡号区域
	
本次比赛采用的数据部分倾斜，以及部分有透视畸变，首先采用radon法校正倾斜，通过Hough法检测卡边角点，求解投影变换矩阵矫正透视畸变。但是银行卡所处环境复杂，Hough检测出的角点并不准确，因此只实现了倾斜校正，透视畸变还需要手动校正。
然后通过形态学的方法，先腐蚀，后膨胀闭合，形成连通域，除去噪声和边框干扰。因而通过投影法确定了信用卡的大致位置，根据先验知识，我们大概分割出信用卡号的大致位置（卡宽的三分之一至三分之二）。截取出该区域后，通过形态学和投影法，更进一步分割卡号位置，得到较为精确的卡号区域。

1.2.2训练CNN网络
	
CNN网络采用11层网络，一层输入层，三层卷积层，三层下采样层（最大值采样），两层全连接层，softmax分类为11类。具有一定深度的网络可以更好的提取图片特征，但是如果训练数据不够，很容易过拟合。由于截取卡号的数据大约只有几千，远远不够训练一个11层神经网络，因此采用fine-tune。在别的已训练好的网络基础上继续训练。训练在15epoch后收敛，测试集准确率为98%。

1.2.3滑动框顺序搜索
	
通过滑动框移动先列再行截取图片范围内的所有区域，每一列判断出概率最大的数字并且该数字的分类概率需要大于一阈值，如果都是背景则继续下一列。两个相邻的被判断出是数字的滑动框的距离必须大于某一阈值，避免移动步长较小重复识别数字。若最后识别出的卡号小于16，则缩小滑动框的长度，若大于16则增大滑动框的长度。

1.3招行卡识别算法分析
	
R-CNN利用selective search随机选取2000个左右不同大小的box,达到最大的覆盖率，最大可能的覆盖到不同的物体上，通过CNN网络分类不同的物体。RCNN网络的训练同样采用fine-tune的方法识别招行卡标志。




2.工程设计

2.1环境设置
	
卡号识别、信用卡：Matlab R2016b
 训练CNN网络：MatlabR2016b ,CUDA ,Visual Studio 2013。

2.2卡号识别算法实现

2.2.1粗分割卡号区域
	
采用Matlab中的radon函数校正倾斜。通过imerode函数腐蚀图片，imclose函数填充图片，bwareopen函数去除噪声与干扰，二值化后统计像素点得到粗分割区域。具体实现见Matlab文件Cudingwei.m

2.2.2训练CNN网络

Matlab中有一个10分类训练50000张图片的CNN神经网络cirfar10Net，修改最后的全连接层为11分类。在此基础上继续训练。训练在15epoch后收敛，测试集准确率为98%。具体实现见Matlab文件Numbernet.m

2.2.3滑动框顺序搜索
	
通过for循环截取图片，将截取图片尺寸改成神经网络的输入尺寸，得到每一个图片的分类数字，分类概率和当前所处在图片的位置，通过概率以及位置判断得到图片识别出的所有数字。具体实现见Matlab文件testbanknum.m。得到所有数字判断是否为16个数字，不是则缩小或增大滑动框长度继续进入testbanknum函数得到所有数字，滑动框长度小于或大于某阈值则跳出循环。具体实现见Matlab文件cardnumber.m。

2.3信用卡识别算法实现

2.3.1训练R-CNN网络

同样利用cirfar10Net网络以及Matlab自带的函数trainRCNNObjectDetector进行招行卡标志识别的网络训练，具体实现见Matlab文件trainBankNet.m。
标志检测利用Matlab中的detect函数，具体实现见Matlab文件testbank.m。

2.4算法性能

卡号识别平均时间：45秒；
卡号识别成功率：1. 未手动校正透视畸变：平均10个号码。2. 手动校正透视畸变：待优化。

招行信用识别时间：7.5s。
招行标志识别率：100%。

