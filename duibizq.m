function A=duibizq(I)
%[fn,pn,fi]=uigetfile('*.jpg','Ñ¡ÔñÍ¼Æ¬');
%YuanShi=imread([pn fn]);%ÊäÈëÔ­Ê¼Í¼Ïñ
%figure(1);subplot(3,2,1),imshow(YuanShi),title('Ô­Ê¼Í¼Ïñ');
%%%%%%%%%%1¡¢Í¼ÏñÔ¤´¦Àí%%%%%%%%%%%
%YuanShiHuiDu=test1;
%Yshd=rgb2gray(YuanShi);%×ª»¯Îª»Ò¶ÈÍ¼Ïñ
%figure(3),subplot(1,2,1),imhist(I);
%figure(2),subplot(1,2,1),imshow(Yshd);

f1=40;s1=20;
f2=150;s2=220;

[m,n]=size(I);
h=double(I);
for i=1:m
    for j=1:n
   t=h(i,j);
   g(i,j)=0;
   if((t>=0) && (t<=f1))
       g(i,j)= (s1/s2)*t;
   else if((t>=f1) && (t<=f2))
           g(i,j)=((s2-s1)/(f2-f1))*(t-f1)+s1;
       else if((t>=f2) && (t<=255))
               g(i,j)=((255-s2)/(255-f2))*(t-f2)+s2;
           end
       end
   end
        
    end
end
subplot(1,2,2),imshow(mat2gray(g));
A=mat2gray(g);
%BianYuan1=edge(I,'canny',0.2);%CannyËã×Ó±ßÔµ¼ì²â
%BianYuan2=edge(A,'canny',0.2);%CannyËã×Ó±ßÔµ¼ì²â
%figure(12),subplot(1,2,1),imshow(BianYuan1);subplot(1,2,2),imshow(BianYuan2);

end