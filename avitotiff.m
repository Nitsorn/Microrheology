function avitotiff

obj = VideoReader('movie.avi');
vid = read(obj);
frames = obj.NumberOfFrames;
for i = 1 : frames
    if numel(num2str(i))==1
    imwrite(vid(:,:,:,i),strcat('0000',num2str(i),'.tif'));
elseif numel(num2str(i))==2
    imwrite(vid(:,:,:,i),strcat('000',num2str(i),'.tif'));
elseif numel(num2str(i))==3
    imwrite(vid(:,:,:,i),strcat('00',num2str(i),'.tif'));
else
    imwrite(vid(:,:,:,i),strcat('0',num2str(i),'.tif'));
end
    
end


