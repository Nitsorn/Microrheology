cd
fname='final_0.tif';
info=imfinfo(fname);
num_images=numel(info);
for k=1:num_images
    
    A=imread(fname,k,'Info',info);
    
    
if numel(num2str(k))==1
    imwrite(A,['0000',num2str(k),'.tif']);
elseif numel(num2str(k))==2
    imwrite(A,['000',num2str(k),'.tif']);
elseif numel(num2str(k))==3
    imwrite(A,['00',num2str(k),'.tif']);    
else
    imwrite(A,['0',num2str(k),'.tif']);
end
end
