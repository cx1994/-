function Jingdingwei = Cudingwei(YuanShi,opts)
%[fn,pn,fi]=uigetfile('*.jpg','ѡ��ͼƬ');
%YuanShi=imread([pn fn]);%����ԭʼͼ��

%pt = 'F:\ѧϰ����\���ѧϰ\R-CNN\data1\5\';
%ext = '*.jpg';
%dis = dir([pt ext]);
%nms = {dis.name};

%jj=11;

%for k = 1:length(nms)
 %   nm = [pt nms{k}];  %ע��Ҫ����·��
 %   disp(nm)
%YuanShi=imread(nm);
%YuanShi=imread('F:\ѧϰ����\���ѧϰ\R-CNN\data1\1\17.jpg');
%figure(1);subplot(3,2,1),imshow(YuanShi),title('ԭʼͼ��');
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
  [I0,J]=find(R==max(max(R)));%J��¼����б��
  qingxiejiao=90-J;
  I1=imrotate(YuanShi,qingxiejiao,'bilinear','crop');
end
  %figure(1),imshow(I1)
  %YuanShiHuiDu = rgb2gray(YuanShi);
%figure(2);
%subplot(1,2,1),imshow(YuanShiHuiDu),title('�Ҷ�ͼ��');
YuanShiHuiDu = rgb2gray(I1);
BianYuan=edge(YuanShiHuiDu,'canny',0.4);%Canny���ӱ�Ե���
%subplot(1,2,2),imshow(BianYuan),title('Canny���ӱ�Ե����ͼ��');
se1=[1;1]; %���ͽṹԪ�� 
BianYuan=imerode(BianYuan,se1);    %��ʴͼ��
%figure(14),subplot(3,1,1),imshow(BianYuan),title('��ʴ���Եͼ��');

se2=strel('rectangle',[30,30]); %���νṹԪ��
BianYuan=imclose(BianYuan,se2);%ͼ����ࡢ���ͼ��
%subplot(3,1,2),imshow(BianYuan),title('����ͼ��');

BianYuan=bwareaopen(BianYuan,900);%�Ӷ������Ƴ����С��900��С����
%subplot(3,1,3),imshow(BianYuan),title('����ͼ��');

%
[y,x]=size(BianYuan);%size������������������ص���һ�������������������������ص��ڶ����������

%
Y1=zeros(y,1);
PX1=0;PX2=0;PY1=0;PY2=0;
for i=1:y
    for j=1:x
        if(BianYuan(i,j)==1)
            Y1(i,1)= Y1(i,1)+1;%��ɫ���ص�ͳ��
        end
  
    end
        if(Y1(i,1)>=50)
           PX1=i ;%��ɫ���ص�ͳ��
           PY1=j;
           break;
        end
end

Y2=zeros(y,1);
for k=y:-1:1
    for l=x:-1:1
         if(BianYuan(k,l)==1)
            Y2(k,1)= Y2(k,1)+1;%��ɫ���ص�ͳ��
        end
  
    end
        if(Y2(k,1)>=50)
           PX2=k ;%��ɫ���ص�ͳ��
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
se1=[1;1]; %���ͽṹԪ�� 
FuShi=imerode(Zifubian,se1);    %��ʴͼ��
figure(6),subplot(3,1,1),imshow(FuShi),title('��ʴ���Եͼ��');

se2=strel('rectangle',[1,35]); %���νṹԪ��
TianChong=imclose(FuShi,se2);%ͼ����ࡢ���ͼ��
subplot(3,1,2),imshow(TianChong),title('����ͼ��');

YuanShiLvBo=bwareaopen(TianChong,1200);%�Ӷ������Ƴ����С��1200��С����
subplot(3,1,3),imshow(YuanShiLvBo),title('��̬�˲���ͼ��');

[y,x]=size(YuanShiLvBo);
YuCuDingWei=double(YuanShiLvBo);

Y1=zeros(y,1);%����y��1��ȫ������
for i=1:y
    for j=1:x
        if(YuCuDingWei(i,j)==1)
            Y1(i,1)= Y1(i,1)+1;%��ɫ���ص�ͳ��
        end
    end
end
[temp,MaxY]=max(Y1);%Y��������ȷ��������������temp��MaxY��temp������¼Y1��ÿ�е����ֵ��MaxY������¼Y1ÿ�����ֵ���к�
%figure(7),subplot(2,2,1),plot(0:y-1,Y1),title('ԭͼ�з������ص�ֵ�ۼƺ�'),xlabel('��ֵ'),ylabel('����'); 
PY1=MaxY;
while ((Y1(PY1,1)>=20)&&(PY1>1))
        PY1=PY1-1;%ȷ����С�к�
end
PY2=MaxY;
while ((Y1(PY2,1)>=20)&&(PY2<y))
        PY2=PY2+1;%ȷ������к�
end
IY=Yudingwei(PY1:PY2,:,:);

X1=zeros(1,x);%����1��x��ȫ������
for j=1:x
    for i=PY1:PY2
        if(YuCuDingWei(i,j,1)==1)
                X1(1,j)= X1(1,j)+1;               
         end  
    end       
end
%subplot(2,2,4),plot(0:x-1,X1),title('ԭͼ�з������ص�ֵ�ۼƺ�'),xlabel('��ֵ'),ylabel('����');
PX1=1;
while ((X1(1,PX1)<1)&&(PX1<x))
       PX1=PX1+1;%�޳����ص�С��1����,
end    
PX3=x;
while ((X1(1,PX3)<1)&&(PX3>PX1))
        PX3=PX3-1;
end
CuDingWei=Yudingwei(PY1:PY2,PX1:PX3,:);
%subplot(2,2,3),imshow(CuDingWei),title('�ֶ�λ��Ĳ�ɫ����ͼ��')
%rgb2yuv(CuDingWei)

Cuedge=edge(rgb2gray(CuDingWei),'canny',0.2);
%figure(10),imshow(Cuedge);
%[n,m]=size(Cuedge);%size������������������ص���һ�������������������������ص��ڶ����������
Cuedge=double(Cuedge);
Jingdingwei = QieGe(Cuedge,CuDingWei);
%figure(12),imshow(Jingdingwei)

%jj = jj + 1;
%ii = int2str(jj);
%imwrite(Jingdingwei,strcat('F:\ѧϰ����\���ѧϰ\R-CNN\data2\�ֶ�λ���ͼƬ\',ii,'.jpg'));
figure(2),imshow(Jingdingwei)
end