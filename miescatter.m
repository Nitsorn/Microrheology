function miescatter

%============================================================================
%======================================
close all;
clear variables;
colormap('gray');
tf_flag=true;
cc_flag=false; 
dia=700*2e-9; % sphere diameter
rad=dia/2;    
ns=1.5; % sphere refractive index (complex)
nm=1.333; % outer medium refractive index (real)
lambda=632.8e-9; % vaccuum wavelength here
conv=1;
k=2*pi/lambda*nm; % the wavenumber in medium nm
x=k*dia/2; % the size parameter
m=ns/nm; % the relative fractive index
[an,bn]=expcoeff_mie(x,m,conv); % compute the coefficients here and use them below
%======================================
%=====================================================
if 1==0
[E,H]=nfmie(an,bn,x,y,z,rad,ns,nm,lambda,tf_flag,cc_flag);
Ecc=sqrt(real(E(:,1)).^2+real(E(:,2)).^2+real(E(:,3)).^2+imag(E(:,1)).^2+imag(E(:,2)).^2+imag(E(:,3)).^2);
plot(x/rad,Ecc)
return
end
%=====================================================
%======================================
% produce movie here and some paramters
Nx=180; % set the resolution of the image to make here (20 - fast and curse, 200 slow and fine)
Ny=180;
N=600;
f=30; %Frame rate
tp=0.5;
Lx=2e-5;
Ly=2e-5;
x0=[0,0,0]; %Initial position of particle
v0=[0,0,-8e-8];
[x,y,z]=mytimeseries(N,f,dia,tp,x0,v0); 
%============================================================================
%==========================MAIN FUNCTION=====================================
%============================================================================
vidObj=VideoWriter('movie.avi');
open(vidObj);
for i=1:N    
[nx,ny]=coordinates(Lx,Ly,Nx,Ny,[x(i),-y(i)]);
[xf,yf]=ndgrid(nx,ny);
zf=zeros(size(xf))+z(i);    

% generate a frame here
[E,H]=nfmie(an,bn,xf,yf,zf,rad,ns,nm,lambda,tf_flag,cc_flag);
Ecc=sqrt(real(E(:,:,1)).^2+real(E(:,:,2)).^2+real(E(:,:,3)).^2+imag(E(:,:,1)).^2+imag(E(:,:,2)).^2+imag(E(:,:,3)).^2);
clf
imagesc(nx/rad,ny/rad,Ecc); 
    if i==1
    cl=caxis;
    else
    caxis(cl)
    end
axis image;
axis off;
writetif(Ecc,i);
frame=getframe(gca);
writeVideo(vidObj,frame);
end
close(vidObj);
%============================================================================
%=================================END========================================
%============================================================================

return


%============================================================================
 
function [xp,yp] = coordinates(Lx,Ly,Nx,Ny,xpar)
% Returns coordinates relative to particle position in a spacified frame:
% Lx,Ly = the lab width/height of the frame (m)
% Nx/Ny = the number of pixel in the x and y directions (-)
% xpar a vector of the particle position coordinates [x,y,z]
x=linspace(0,Nx,Nx)*Lx/Nx-Lx/2;
y=linspace(0,Ny,Ny)*Ly/Ny-Ly/2;
xp=x-xpar(1);
yp=y-xpar(2);
return
 
function [x,y,z]=mytimeseries(N,f,dia,tp,x0,v0)
% Returns x y and z coordinates (m) given:
% N = number of frames
% f = frame rate (Hz)
% d = particle diameter
% tp = temperature parameter
% x0 = initial position (m)
% v0 = drift velocity (m/s)
% Call: [x,y,z]=mytimeseries(1000,10,200e-9,0.5,[0 0 0],0.1e-6*[0 0 -1])
 
dt=1/f;
delta=dia*dt*tp;
 
x=zeros(N,1);
y=zeros(N,1);
z=zeros(N,1);
 
x(1)=x0(1);
y(1)=x0(2);
z(1)=x0(3);
 
 for i=2:N   
            dx=delta*normrnd(0,1)+v0(1)*dt;
            dy=delta*normrnd(0,1)+v0(2)*dt;
            dz=v0(3)*dt;
 
            x(i)=x(i-1)+dx; 
            y(i)=y(i-1)+dy;
            z(i)=z(i-1)+dz; 
             
 end
 
if 1==0
figure(1)
plot(x,'-bo'); hold on
plot(y,'-ro'); hold on
plot(z,'-go'); hold on
ylabel('position (m)')
xlabel('frame')
end

function [x,y,z]=mytimeseriesstraight(Lx,Ly,N,x0)
% Returns x y and z coordinates (m) given:
% N = number of frames
% f = frame rate (Hz)
% d = particle diameter
% sf = scale factor (-)
% x0 = initial position (m)
% v0 = drift velocity (m/s)
  
x=zeros(N,1);
y=zeros(N,1).*(-Ly/4);
z=zeros(N,1);
 
x(1)=x0(1);
y(1)=x0(2);
z(1)=x0(3);
 
 for i=2:N   
            dx=0;
            dy=(Ly/2)/N;
            dz=0;
 
            x(i)=x(i-1)+dx; 
            y(i)=y(i-1)+dy;
            z(i)=z(i-1)+dz; 
             
 end
 
if 1==0
figure(1)
plot(x,'-bo'); hold on
plot(y,'-ro'); hold on
plot(z,'-go'); hold on
ylabel('position (m)')
xlabel('frame')
end

function writetif(Ecc,i)


Ecc = (Ecc - min(min(Ecc))) / (max(max(Ecc)) - min(min(Ecc)));

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
# Microrheology
