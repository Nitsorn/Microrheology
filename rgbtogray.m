
somefolder = pwd;
        filelist = dir(somefolder);
 NImages=2000;
        
        for i=1:NImages
            if numel(num2str(i))==1
                I=imread(['0000' num2str(i) '.tif']);
            elseif numel(num2str(i))==2
                I=imread(['000' num2str(i) '.tif']);
            elseif numel(num2str(i))==3
                I=imread(['00' num2str(i) '.tif']);
            elseif numel(num2str(i))==4
                I=imread(['0' num2str(i) '.tif']);
            end
            J=rgb2gray(I);
            
            if numel(num2str(i))==1
                imwrite(J,['0000' num2str(i) '.tif']);
            elseif numel(num2str(i))==2
                imwrite(J,['000' num2str(i) '.tif']);
            elseif numel(num2str(i))==3
                imwrite(J,['00' num2str(i) '.tif']);
            elseif numel(num2str(i))==4
                imwrite(J,['0' num2str(i) '.tif']);
            end

        end