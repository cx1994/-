function Jingdingwei = Cudingwei(YuanShi,opts)
%[fn,pn,fi]=uigetfile('*.jpg','选择图片');
%YuanShi=imread([pn fn]);%输入原始图像

%pt = 'F:\学习资料\深度学习\R-CNN\data1\5\';
%ext = '*.jpg';
%dis = dir([pt ext]);
%nms = {dis.name};

%jj=11;

%for k = 1:length(nms)
 %   nm = [pt nms{k}];  %注意要加上路径
 %   disp(nm)
%YuanShi=imread(nm);
%YuanShi=imread('F:\学习资料\深度学习\R-CNN\data1\1\17.jpg');
%figure(1);subplot(3,2,1),imshow(YuanShi),title('原始图像');
if opts == 0
    imshow(YuanShi);
    dot=ginput(); 
I_R = jiaozheng(YuanShi(:,:,1),dot);
I_G = jiaozheng(YuanShi(:,:,2),dot);
I_B = jiaozheng(YuanShi(:,:,3),dot);
IRGB(:,:,1) = I_R;
IRGB(:,:,2) = I_G;
IRGB(:,:,3) = I_B;
I1 = uint8(IRGB);
imshow(I1);
else
  gray=rgb2gray(YuanShi);
  
  bw=edge(gray,'canny',0.2);
  theta=1:180;
  [R,xp]=radon(bw,theta);
  [I0,J]=find(R==max(max(R)));%J记录了倾斜角
  qingxiejiao=90-J;
  I1=imrotate(YuanShi,qingxiejiao,'bilinear','crop');
end
  %figure(1),imshow(I1)
  %YuanShiHuiDu = rgb2gray(YuanShi);
%figure(2);
%subplot(1,2,1),imshow(YuanShiHuiDu),title('灰度图像');
YuanShiHuiDu = rgb2gray(I1);
BianYuan=edge(YuanShiHuiDu,'canny',0.4);%Canny算子边缘检测
%subplot(1,2,2),imshow(BianYuan),title('Canny算子边缘检测后图像');
se1=[1;1]; %线型结构元素 
BianYuan=imerode(BianYuan,se1);    %腐蚀图像
%figure(14),subplot(3,1,1),imshow(BianYuan),title('腐蚀后边缘图像');

se2=strel('rectangle',[30,30]); %矩形结构元素
BianYuan=imclose(BianYuan,se2);%图像聚类、填充图像
%subplot(3,1,2),imshow(BianYuan),title('填充后图像');

BianYuan=bwareaopen(BianYuan,900);%从对象中移除面积小于900的小对象
%subplot(3,1,3),imshow(BianYuan),title('填充后图像');

%
[y,x]=size(BianYuan);%size函数将数组的行数返回到第一个输出变量，将数组的列数返回到第二个输出变量

%
Y1=zeros(y,1);
PX1=0;PX2=0;PY1=0;PY2=0;
for i=1:y
    for j=1:x
        if(BianYuan(i,j)==1)
            Y1(i,1)= Y1(i,1)+1;%白色像素点统计
        end
  
    end
        if(Y1(i,1)>=50)
           PX1=i ;%白色像素点统计
           PY1=j;
           break;
        end
end

Y2=zeros(y,1);
for k=y:-1:1
    for l=x:-1:1
         if(BianYuan(k,l)==1)
            Y2(k,1)= Y2(k,1)+1;%白色像素点统计
        end
  
    end
        if(Y2(k,1)>=50)
           PX2=k ;%白色像素点统计
           PY2=l;
           break;
        end
end
%cudingwei=I1(round(PX1):round(PX2),round(PY2):round(PY1),:);
%figure(3),subplot(1,1,1),imshow(cudingwei);

Yudingwei=I1(round((PX2-PX1+1)*12/32+PX1):round((PX2-PX1+1)*25/32+PX1),:,:);
%figure(4),imshow(Yudingwei);
zengqiang=duibizq(rgb2gray(Yudingwei));
Zifubian=edge(zengqiang,'canny',0.4);
%figure(5),subplot(1,1,1),imshow(Zifubian);
se1=[1;1]; %线型结构元素 
FuShi=imerode(Zifubian,se1);    %腐蚀图像
figure(6),subplot(3,1,1),imshow(FuShi),title('腐蚀后边缘图像');

se2=strel('rectangle',[1,35]); %矩形结构元素
TianChong=imclose(FuShi,se2);%图像聚类、填充图像
subplot(3,1,2),imshow(TianChong),title('填充后图像');

YuanShiLvBo=bwareaopen(TianChong,1200);%从对象中移除面积小于1200的小对象
subplot(3,1,3),imshow(YuanShiLvBo),title('形态滤波后图像');

[y,x]=size(YuanShiLvBo);
YuCuDingWei=double(YuanShiLvBo);

Y1=zeros(y,1);%产生y行1列全零数组
for i=1:y
    for j=1:x
        if(YuCuDingWei(i,j)==1)
            Y1(i,1)= Y1(i,1)+1;%白色像素点统计
        end
    end
end
[temp,MaxY]=max(Y1);%Y方向区域确定。返回行向量temp和MaxY，temp向量记录Y1的每列的最大值，MaxY向量记录Y1每列最大值的行号
%figure(7),subplot(2,2,1),plot(0:y-1,Y1),title('原图行方向像素点值累计和'),xlabel('行值'),ylabel('像素'); 
PY1=MaxY;
while ((Y1(PY1,1)>=20)&&(PY1>1))
        PY1=PY1-1;%确定最小行号
end
PY2=MaxY;
while ((Y1(PY2,1)>=20)&&(PY2<y))
        PY2=PY2+1;%确定最大行号
end
IY=Yudingwei(PY1:PY2,:,:);

X1=zeros(1,x);%产生1行x列全零数组
for j=1:x
    for i=PY1:PY2
        if(YuCuDingWei(i,j,1)==1)
                X1(1,j)= X1(1,j)+1;               
         end  
    end       
end
%subplot(2,2,4),plot(0:x-1,X1),title('原图列方向像素点值累计和'),xlabel('列值'),ylabel('像数');
PX1=1;
while ((X1(1,PX1)<1)&&(PX1<x))
       PX1=PX1+1;%剔除像素点小于1的列,
end    
PX3=x;
while ((X1(1,PX3)<1)&&(PX3>PX1))
        PX3=PX3-1;
end
CuDingWei=Yudingwei(PY1:PY2,PX1:PX3,:);
%subplot(2,2,3),imshow(CuDingWei),title('粗定位后的彩色车牌图像')
%rgb2yuv(CuDingWei)

Cuedge=edge(rgb2gray(CuDingWei),'canny',0.2);
%figure(10),imshow(Cuedge);
%[n,m]=size(Cuedge);%size函数将数组的行数返回到第一个输出变量，将数组的列数返回到第二个输出变量
Cuedge=double(Cuedge);
Jingdingwei = QieGe(Cuedge,CuDingWei);
%figure(12),imshow(Jingdingwei)

%jj = jj + 1;
%ii = int2str(jj);
%imwrite(Jingdingwei,strcat('F:\学习资料\深度学习\R-CNN\data2\粗定位后的图片\',ii,'.jpg'));
figure(2),imshow(Jingdingwei)
end