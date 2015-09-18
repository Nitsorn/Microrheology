function GDFcoordplot
% write the name of the GDF file from IDL
A=read_gdf('watertest.gdf');

NFrames=length(A);
X=zeros(NFrames,2);
Y=zeros(NFrames,2);
Z=zeros(NFrames,2);

for i=1:NFrames;
X(i,1)=A(1,1,i);
Y(i,1)=A(1,2,i);
Z(i,1)=A(1,3,i);
X(i,2)=A(2,1,i);
Y(i,2)=A(2,2,i);
Z(i,2)=A(2,3,i);
end

figure(1);
    plot(X(:,1),'--r'), hold on ;
    plot(Y(:,1),':g');
    plot(Z(:,1),':b');
    legend('X','Y','Z');
%plot standard deviation
figure(2);
    plot(X(:,2),'--r'), hold on ;
    plot(Y(:,2),':g');
    plot(Z(:,2),':b');
    legend('X','Y','Z');
  
    hold off;
    

end