function squa = Resize(tu)
   paddimg = [];
  [m,n,o]=size(tu);
     mean = sum(sum(sum(tu)))/(m*n*3);
     %��ͼƬ��Χ����ͼƬƽ���Ҷ�ֵ�����������
     if(m >= n)
         padding = ones(m)*mean;
         elseif m < n 
         padding = ones(n)*mean;
     end
     
     for kk = 1:3
         paddimg(:,:,kk) = padding;
     end
     
     if m >= n
         paddimg(:,floor((m-n)/2+1):floor((m+n)/2),:)=tu;
     elseif m<n
         paddimg(floor((n-m)/2+1):floor((m+n)/2),:,:)=tu;
     end
     
     squa = imresize(double(paddimg)/255,[32,32]);
end
