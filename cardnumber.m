clc
clear
close all
tic;
xx = 28;%��ʼ�߿򳤶�
opts = 1;%1Ϊ�Զ�У����б��У��͸����䣬0Ϊ�ֶ�У��͸�����,����ѡ�����ϣ����ϣ����£����£����ǻ�δ�Ż�

[fn,pn,fi]=uigetfile('*.jpg','ѡ��ͼƬ');
img=imread([pn fn]);%����ԭʼͼ��
tu = Cudingwei(img,opts);
tempnumber = testbanknum(tu,xx);
tt = size(tempnumber,1);

while  tt~= 16
    
    if tt > 16
        xx = xx+2;
       
        tempnumber = testbanknum(tu,xx);
        tt = size(tempnumber,1);
    else
        xx = xx-1;
        
        tempnumber = testbanknum(tu,xx);
        tt = size(tempnumber,1);
    end
    
    if xx < 19 || xx > 32
        break;
    end
end

cardnum = tempnumber(:,1)-1;
disp(cardnum')
toc;





