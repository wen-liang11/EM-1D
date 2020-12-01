clear, clc;

% choose 1st order ABC
first_order=0;

xsize=300;
timetot=200;        
xcenter=150;        

epsilon=(1/(36*pi))*1e-9*ones(1,xsize);      % permittivity
mu=4*pi*1e-7*ones(1,xsize);      % permeability
c=3e+8;     % light speed

deltax=1e-6;
deltat=deltax/c;

Ez=zeros(1,xsize);
Hy=zeros(1,xsize);
Eztot=zeros(timetot,xsize);
Hytot=zeros(timetot,xsize);

sigma=4e-4*ones(1,xsize);
sigmastar=4e-4*ones(1,xsize);

A=((mu-0.5*deltat*sigmastar)./(mu+0.5*deltat*sigmastar)); 
B=(deltat/deltax)./(mu+0.5*deltat*sigmastar);
                                                  
C=((epsilon-0.5*deltat*sigma)./(epsilon+0.5*deltat*sigma)); 
D=(deltat/deltax)./(epsilon+0.5*deltat*sigma);

Ez(xcenter)=1;      % impulse input 
for n=1:1:timetot
    
    % H field
    Hy(1:xsize-1)=A(1:xsize-1).*Hy(1:xsize-1)+B(1:xsize-1).*(Ez(2:xsize)-Ez(1:xsize-1));
    if first_order == 0
        Hy(1)=0;
    end
    % E field
    Ez(2:xsize)=C(2:xsize).*Ez(2:xsize)+D(2:xsize).*(Hy(2:xsize)-Hy(1:xsize-1));
   
    % impulse 
    if n ==1
        Ez(xcenter)=0;
    end
    
    % 1st order ABC
    if first_order == 1
        if n>1
            Ez(1)=Ezlast1+((c*deltat-deltax)/(c*deltat+deltax))*(Ez(2)-Ez(1));
            Ez(xsize)=Ezlast2+((c*deltat-deltax)/(c*deltat+deltax))*(Ez(xsize-1)-Ez(xsize));
        end
    end
     Hytot(n,:)=Hy;
     Eztot(n,:)=Ez;
     
    Ezlast1=Ez(2);
    Ezlast2=Ez(xsize-1);
        
    
    plot((1:1:xsize)*deltax,Ez,'color','b', 'linewidth',1.5);
    titlestring=['\fontsize{14}Ez vs X for 1D FDTD & 1st ABC at time = ',num2str(round(n*deltat/10e-15)),' fs'];
    title(titlestring,'color','b');
    xlabel('x in m','FontSize',14,'color','b' );
    ylabel('Ez in V/m','FontSize',14,'color','b');
    set(gca,'FontSize',14,'xcolor','b','ycolor','b');
    axis([0 xsize*deltax -3 3]);
    F(n)=getframe(gcf);
end
% writerObj=VideoWriter('test.avi');
% open(writerObj);
% writeVideo(writerObj,F);
% close(writerObj);