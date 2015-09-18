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