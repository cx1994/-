clc
clear
close all
tic;
xx = 28;%初始边框长度
opts = 1;%1为自动校正倾斜不校正透射畸变，0为手动校正透射畸变,依次选中左上，右上，左下，右下，但是还未优化

[fn,pn,fi]=uigetfile('*.jpg','选择图片');
img=imread([pn fn]);%输入原始图像
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





