function tempnumber = testbanknum(tu,xx_m)
%顺序搜索

%clc
%clear
addpath F:\学习资料\深度学习\R-CNN\data2\traindata\训练网络
load numNet_back2

%tu = imread('F:\学习资料\深度学习\R-CNN\data2\粗定位后的图片\8.jpg');
[y,x,o] = size(tu);

xx = xx_m; yy =42;%移动框大小
stride_y = 6;stride_x = 4;%移动步长
i_m = floor((x-xx)/stride_x);j_m = floor((y-yy)/stride_y);%移动次数
i_2 = rem((x-xx),stride_x);  j_2 = rem((y-yy),stride_y);%余下需要移动的步长
temporary=[];

if j_m <= 0 %判断y方向边框超过图片y值
    j_m = 1;
    yy = y;
    j_2 = 0;
end

if i_2~=0 && j_2~=0
    
  for i = 1:i_m+1
        
        for j = 1:j_m+1
            
            if j <= j_m && i<= i_m
                pict = tu(round(1+(j-1)*stride_y):round(yy + (j-1)*stride_y),round(1+(i-1)*stride_x):round(xx + (i-1)*stride_x),:);
                 teim = Resize(pict);
                [num,scores] = classify(numNet_back2,teim);
                score = max(scores);
                kk = [grp2idx(num),score];
                temporary=[temporary;kk];
            elseif j > j_m && i<= i_m
                pict = tu(round(1+(j-1)*stride_y+j_2):round(yy+(j-1)*stride_y+j_2),round(1+(i-1)*stride_x):round(xx+(i-1)*stride_x),:);
                 teim = Resize(pict);
                [num,scores] = classify(numNet_back2,teim);
                score = max(scores);
                kk = [grp2idx(num),score];
                temporary=[temporary;kk];
                elseif j <= j_m && i> i_m
                    pict = tu(round(1+(j-1)*stride_y):round(yy+(j-1)*stride_y),round(1+(i-1)*stride_x+i_2):round(xx+(i-1)*stride_x+i_2),:); 
                     teim = Resize(pict);
                    [num,scores] = classify(numNet_back2,teim);
                     score = max(scores);
                    kk = [grp2idx(num),score];
                    temporary=[temporary;kk];
                    else
                         pict = tu(round(1+(j-1)*stride_y+j_2):round(yy+(j-1)*stride_y+j_2),round(1+(i-1)*stride_x+i_2):round(xx+(i-1)*stride_x+i_2),:); 
                          teim = Resize(pict);
                          [num,scores] = classify(numNet_back2,teim);
                          score = max(scores);
                          kk = [grp2idx(num),score];
                         temporary=[temporary;kk];
            
              end
            end
       
     record(:,:,i) = temporary;
     temporary=[];
      
end
elseif j_2~=0 && i_2 == 0
         for i = 1:i_m
        
        for j = 1:j_m+1
            
            if j <= j_m 
                pict = tu(round(1+(j-1)*stride_y):round(yy + (j-1)*stride_y),round(1+(i-1)*stride_x):round(xx + (i-1)*stride_x),:);
                teim = Resize(pict);
                [num,scores] = classify(numNet_back2,teim);
                score = max(scores);
                kk = [grp2idx(num),score];
                
                temporary=[temporary;kk];
           
                    else
                         pict = tu(round(1+(j-1)*stride_y+j_2):round(yy+(j-1)*stride_y+j_2),round(1+(i-1)*stride_x):round(xx+(i-1)*stride_x),:); 
                          teim = Resize(pict);
                          [num,scores] = classify(numNet_back2,teim);
                          score = max(scores);
                         kk = [grp2idx(num),score];
                         temporary=[temporary;kk];
            
              end
            end
       
     record(:,:,i) = temporary;
     temporary=[];
      
end
    elseif i_2~=0 && j_2 == 0
              for i = 1:i_m+1
        
        for j = 1:j_m
      
           if  i<= i_m
                pict = tu(round(1+(j-1)*stride_y):round(yy+(j-1)*stride_y),round(1+(i-1)*stride_x):round(xx+(i-1)*stride_x),:);
                teim = Resize(pict);
                [num,scores] = classify(numNet_back2,teim);
                score = max(scores);
                kk = [grp2idx(num),score];
                temporary=[temporary;kk];
             
                    else
                         pict = tu(round(1+(j-1)*stride_y+j_2):round(yy+(j-1)*stride_y+j_2),round(1+(i-1)*stride_x+i_2):round(xx+(i-1)*stride_x+i_2),:); 
                          teim = Resize(pict);
                          [num,scores] = classify(numNet_back2,teim);
                          score = max(scores);
                          kk = [grp2idx(num),score];
                         temporary=[temporary;kk];
            
            end
         end
       
     record(:,:,i) = temporary;
     temporary=[];
      
              end

      else
for i = 1:i_m
        
        for j = 1:j_m
            
                pict = tu(round(1+(j-1)*stride_y):round(yy + (j-1)*stride_y),round(1+(i-1)*stride_x):round(xx + (i-1)*stride_x),:);
                 teim = Resize(pict);
                [num,scores] = classify(numNet_back2,teim);
                score = max(scores);
                kk = [grp2idx(num),score];
                temporary=[temporary;kk];
           
        end
       
          record(:,:,i) = temporary;
          temporary=[];
      
end
   
end

[num,score,array]=size(record);
maxscore = 0;location = 0;prenumber = 0;tempnumber=[];prelocation = 0;

for i = 1:array
    for j = 1:num
   if record(j,1,i) ~= 11
       if maxscore < record(j,2,i) && record(j,2,i) >= 0.9
           maxscore = record(j,2,i);
           number = record(j,1,i);
          
       end
   end
    
    end
    location = location + 1;
    
    for j = 1:num
   if record(j,1,i) ~= 11
       if maxscore ~= 0
    nownumber = number;
    if prelocation~= 0 
    if prenumber ~= nownumber && (location-prelocation)>3
        tempnumber=[tempnumber;[number,location]];
        prenumber = nownumber;
        prelocation = location;
    elseif (location-prelocation)>3
            tempnumber=[tempnumber;[number,location]];
            prelocation = location;
    end  
    else
        if number>2 && number <8
        tempnumber=[tempnumber;[number,location]];
        prelocation = location;
        end
    end
       
   end
   end
    end
    maxscore = 0;
end
disp(record)
end




