function writetif(Ecc,i)

if numel(num2str(i))==1
    imwrite(Ecc,['0000',num2str(i),'.tif']);
elseif numel(num2str(i))==2
    imwrite(Ecc,['000',num2str(i),'.tif']);
elseif numel(num2str(i))==3
    imwrite(Ecc,['00',num2str(i),'.tif']);    
else
    imwrite(Ecc,['0',num2str(i),'.tif']);
end


return
