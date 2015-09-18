function IDL_companion(file1,file2,file3,file4)
A=read_gdf(file1);
NFrames=max(size(A));

X=zeros(NFrames,2);
Y=zeros(NFrames,2);
Z=zeros(NFrames,2);
ap=zeros(NFrames,2);
np=zeros(NFrames,2);
alpha=zeros(NFrames,2);
nm=zeros(NFrames,2);
mean_ap=zeros(NFrames,1);
mean_np=zeros(NFrames,1);
mean_alpha=zeros(NFrames,1);
mean_nm=zeros(NFrames,1);

for i=1:NFrames;
X(i,1)=A(1,1,i);
Y(i,1)=A(1,2,i);
Z(i,1)=A(1,3,i);
ap(i,1)=A(1,4,i);
np(i,1)=A(1,5,i);
alpha(i,1)=A(1,6,i);
nm(i,1)=A(1,7,i);
X(i,2)=A(2,1,i);
Y(i,2)=A(2,2,i);
Z(i,2)=A(2,3,i);
ap(i,2)=A(2,4,i);
np(i,2)=A(2,5,i);
alpha(i,2)=A(2,6,i);
nm(i,2)=A(2,7,i);
mean_ap(i)=mean(ap(1:i));
mean_np(i)=mean(np(1:i));
mean_alpha(i)=mean(alpha(1:i));
mean_nm(i)=mean(nm(1:i));
end

for i=20:NFrames;
if abs(ap(i)-mean_ap(i-1)) > 0.5 | abs(alpha(i)-mean_alpha(i-1)) > 0.5 |... 
        abs(np(i)-mean_np(i-1)) >0.5
    word=strcat ('The error started at frame #',num2str(i));disp(word);
    error_point=i;
break
end
end

checkpoint=error_point-10;
pout=zeros(7,2,checkpoint);
new_p=zeros(7,1,checkpoint);
for i=1:error_point
    for j=1:2
pout(1,j,i)=X(i,j);
pout(2,j,i)=Y(i,j);
pout(3,j,i)=Z(i,j);
pout(4,j,i)=ap(i,j);
pout(5,j,i)=np(i,j);
pout(6,j,i)=alpha(i,j);
pout(7,j,i)=nm(i,j);
    end
new_p(1,1,i)=X(i,1);
new_p(2,1,i)=Y(i,1);
new_p(3,1,i)=Z(i,1);
new_p(4,1,i)=mean_ap(i,1);
new_p(5,1,i)=mean_np(i,1);
new_p(6,1,i)=mean_alpha(i,1);
new_p(7,1,i)=mean_nm(i,1);
end
word=strcat ('the parameters are') ;disp(word);
disp(pout(:,1,error_point));
%1st_run
accurate(pout,checkpoint,NFrames);
[new_sp]=user_information(checkpoint,pout,new_p,NFrames);

while new_sp < NFrames;
%2nd_run
[checkpoint,pout,new_p]=new_entry(file2,new_sp,new_p,pout,mean_ap...
    ,mean_np,mean_alpha,mean_nm,checkpoint,ap,np,alpha,nm,NFrames);
accurate(pout,checkpoint,NFrames);
[new_sp]=user_information(checkpoint,pout,new_p,NFrames);

%3rd_run
[checkpoint,pout,new_p]=new_entry(file3,new_sp,new_p,pout,mean_ap...
    ,mean_np,mean_alpha,mean_nm,checkpoint,ap,np,alpha,nm,NFrames);
accurate(pout,checkpoint,NFrames);
[new_sp]=user_information(checkpoint,pout,new_p,NFrames);

%4th_run
[checkpoint,pout,new_p]=new_entry(file4,new_sp,new_p,pout,mean_ap...
    ,mean_np,mean_alpha,mean_nm,checkpoint,ap,np,alpha,nm,NFrames);
accurate(pout,checkpoint,NFrames);
[new_sp]=user_information(checkpoint,pout,new_p,NFrames);
end

for i=1:NFrames;
X(i,1)=pout(1,1,i);
Y(i,1)=pout(2,1,i);
Z(i,1)=pout(3,1,i);
ap(i,1)=pout(4,1,i);
np(i,1)=pout(5,1,i);
alpha(i,1)=pout(6,1,i);
nm(i,1)=pout(7,1,i);
end
figure(1);
    plot(X(:,1),'--r'), hold on ;
    plot(Y(:,1),':g');
    plot(Z(:,1),':b');
    legend('X1','Y1','Z1');

figure(2);
    plot(ap(:,1),'--r'), hold on ;
    plot(np(:,1),':g');
    plot(alpha(:,1),':b');
    plot(nm(:,1),'--y');
    legend('ap','np','alpha','nm');


    assignin('base','pout',pout)
    
word=strcat ('Preparing the data for microrheology computation');
disp(word);
prompt='Insert integrated intensity of the feature. Default=0==>';
ii=input(prompt);
prompt='Insert radius of gyration of the feature. Default=1000==>';
rad_gyra=input(prompt);
prompt='Insert eccentricity of the feature. Default=0==>';
eccen=input(prompt);
prompt='Insert the frame rate of the movie (fps). Range=30 to 90==>';
fps=input(prompt);
prompt='Insert the number of beads discussed. Default=1==>';
bead=input(prompt);

res=zeros(NFrames,8);
res(1,7)=(1/fps);
for i=1:NFrames
    res(i,1)=pout(1,1,i);
    res(i,2)=pout(1,2,i);
    res(i,3)=ii;
    res(i,4)=rad_gyra;
    res(i,5)=eccen;
    res(i,6)=i;
    if i>1
    res(i,7)=res(i-1,7)+(1/fps);
    end
    res(i,8)=bead;
end
assignin('base','res',res)
prompt='Insert maximum Rg value to be included in mm. set= -1 if not calculated==>';
rg_cutoff=input(prompt);

prompt='Insert bead radius in mm==>';
a=input(prompt);
prompt='Insert Temp (K) ==>';
T=input(prompt);
prompt='Insert Clip. Default=0.03 ==>';
clip=input(prompt);
prompt='Insert width. Default=0.7 ==>';
width=input(prompt);
word=strcat('Saving res in your current folder.');
disp(word);
basepath=strcat(cd,'/');

assignin('base','basepath',basepath)
assignin('base','numFOV',bead)
assignin('base','timeint',(1/fps))
assignin('base','number_of_frames',NFrames)
assignin('base','maxtime',(NFrames/fps))
assignin('base','rg_cutoff',rg_cutoff)
assignin('base','a',a)
assignin('base','dim',2)
assignin('base','T',T)
assignin('base','clip',clip)
assignin('base','width',width)

mkdir('Bead_Tracking');
cd ('Bead_Tracking');
mkdir('res_files');
cd ('res_files');

save res_run1.mat res;
word=strcat('Proceed to rheology.m.');
disp(word);
cd (basepath);
addpath(genpath(basepath));
end        

function [result]=accurate(pout,checkpoint,NFrames)
if checkpoint ~= (NFrames-9)
x = pout(1,1,checkpoint);
y = pout(2,1,checkpoint);

word=strcat ('Please check if the [x,y] for frame #',num2str(checkpoint),...
    ' is [',num2str(pout(1,1,checkpoint)),',',num2str(pout(2,1,checkpoint)),'].');disp(word);
prompt='type 1 if correct. 0 if wrong  =>';
result=input(prompt);
while result == 0;
    checkpoint=checkpoint-10;
    result=accurate(pout,checkpoint,NFrames);
end
else return
end
end

function [checkpoint,pout,new_p,new_sp]=new_entry(file,new_sp,new_p,pout,mean_ap...
    ,mean_np,mean_alpha,mean_nm,checkpoint,ap,np,alpha,nm,NFrames_real)
if checkpoint ~= (NFrames_real-9)
A=read_gdf(file);
R_NFrames=max(size(A));
word=strcat('Did you start from the recommended starting point?');disp(word);
prompt='type 1 if correct. 0 if wrong  =>';
restart=input(prompt);
if restart == 0
    prompt ='Where did you start from?';
    new_sp =input(prompt);
end

NFrames=R_NFrames+new_sp;

X=zeros(NFrames,2);
Y=zeros(NFrames,2);
Z=zeros(NFrames,2);


for i=1+new_sp:NFrames;
X(i,1)=A(1,1,i-new_sp);
Y(i,1)=A(1,2,i-new_sp);
Z(i,1)=A(1,3,i-new_sp);
X(i,2)=A(2,1,i-new_sp);
Y(i,2)=A(2,2,i-new_sp);
Z(i,2)=A(2,3,i-new_sp);
ap(i,1)=A(1,4,i-new_sp);
np(i,1)=A(1,5,i-new_sp);
alpha(i,1)=A(1,6,i-new_sp);
nm(i,1)=A(1,7,i-new_sp);
ap(i,2)=A(2,4,i-new_sp);
np(i,2)=A(2,5,i-new_sp);
alpha(i,2)=A(2,6,i-new_sp);
nm(i,2)=A(2,7,i-new_sp);
mean_ap(i)=mean(ap(1:i));
mean_np(i)=mean(np(1:i));
mean_alpha(i)=mean(alpha(1:i));
mean_nm(i)=mean(nm(1:i));
end

for i=1:5
    if abs(X(i+new_sp)-new_p(1,1,i+new_sp)) > 4 | abs(Y(i+new_sp)-...
        new_p(2,1,i+new_sp)) > 4 
    word=strcat ('This tracking is different from previous data set') ;disp(word);
        break
    else 
        if i==5
    word=strcat ('This tracking is accurate upto the old checkpoint: Frame #'...
        ,num2str(checkpoint),'. Proceeding to match data.');disp(word);
        end
    end
end
for i=6:R_NFrames    
    if abs(ap(i+new_sp)-new_p(4,1,new_sp)) > 0.5 | abs(alpha(i+new_sp)-...
        new_p(6,1,new_sp)) > 2 |... 
        abs(np(i+new_sp)-new_p(5,1,new_sp)) >0.5
    %for first 20 files, let it go
        if i<20
             warning('either ap,alpha or np does not match. Refer to "GDFcoordplot".');
             prompt='if this is temporary, please ignore by pressing "1". Exit=0';
             ignore=input(prompt);
        if ignore ~= 1
         word=strcat('Please re-run your tracking. This file is inaccurate');disp(word);
         i=20;
            break
        end
     %for other files, test
        else
    
            error_point=i+new_sp;
            word=strcat ('The new error started at frame #',num2str(error_point));disp(word);
            break
        end
    else if i <R_NFrames
        else error_point=R_NFrames+new_sp;
        end
        
    end
end

checkpoint=error_point-10;
old_sp=new_sp;
for i=1+old_sp:error_point
    for j=1:2
pout(1,j,i)=X(i,j);
pout(2,j,i)=Y(i,j);
pout(3,j,i)=Z(i,j);
pout(4,j,i)=ap(i,j);
pout(5,j,i)=np(i,j);
pout(6,j,i)=alpha(i,j);
pout(7,j,i)=nm(i,j);
    end
new_p(1,1,i)=X(i,1);
new_p(2,1,i)=Y(i,1);
new_p(3,1,i)=Z(i,1);
new_p(4,1,i)=mean_ap(i,1);
new_p(5,1,i)=mean_np(i,1);
new_p(6,1,i)=mean_alpha(i,1);
new_p(7,1,i)=mean_nm(i,1);
end
if error_point ~= NFrames;
    word=strcat ('The parameters are') ;disp(word);
    disp(pout(:,1,error_point))
else
    word= strcat ('Your tracking is complete. The final frame [#', num2str(NFrames),'] has parameters');disp(word);
    disp(pout(:,1,error_point))
    word=strcat ('The mean parameters are:');disp(word);
    disp(new_p(:,:,error_point));
end

end
end

function [new_sp,complete]= user_information(checkpoint,pout,new_p,NFrames)
if checkpoint ~= (NFrames-9)

new_sp=checkpoint-5;
word1=strcat ('The new starting point is at frame #',num2str(new_sp));disp(word1);

word2=strcat ('The new coordinates (rc) are [',num2str(pout(1,1,new_sp)),','...
    ,num2str(pout(2,1,new_sp)),'].');disp(word2);
word3=strcat ('Other starting parameters [zc,ap,np,alpha,nm] are in rows 3 to 7.');disp(word3);
disp(new_p(:,:,new_sp));


prompt2='Do you have more files? 1=yes 0=no  =>';
complete=input(prompt2);

if complete == 1;
    word=strcat('Moving on to the next file');disp(word);
else  
    return
end
else

new_sp=NFrames;
end
end

function go_to_next(complete)
if complete == 0
    return
end
end
