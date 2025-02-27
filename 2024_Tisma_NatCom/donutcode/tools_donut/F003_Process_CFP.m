function F003_Process_CFP(initval,actions)
%sequence of actions to work through chromosome

load(initval.PathResultName);    
[rr,cc,dd]=size(cfp_Stack);
 h=figure;
 
%% Analysis section; data is stored
if actions.cfp_analyze
    
    %1 click approximate location
    close all;
    clickpic=cfp_pic;
    CcX=AllFrameData(1).Chromosome.xCOM/2;
    CcY=AllFrameData(1).Chromosome.yCOM/2;
    CX=AllFrameData(1).Chromosome.CartesianContourMax_X/2;
    CY=AllFrameData(1).Chromosome.CartesianContourMax_Y/2;
    BX=AllFrameData(1).BrightField.CartesianContourEdge_X;
    BY=AllFrameData(1).BrightField.CartesianContourEdge_Y;
   
    plot([CcX CcX],[CcY CcY], 'wx','MarkerSize', 20); hold on;
    plot(CX,CY,'b-','LineWidth', 2); hold on;
    plot(BX,BY, 'w-','LineWidth', 2); hold on;
    pcolor(clickpic); colormap bone; shading flat; hold on; axis equal 
    pause(0.1);
    [x0,y0,~]=ginput(1);
    
    
    %2 track the spot (method llorente-garcia, see moolman et al BJ 2015)
 for jj=1:dd
    dd-jj+1
    pic=cfp_Stack(:,:,jj);      
    CellSimProps.roilox=1;          %lower x coordinate of Roi
    CellSimProps.roiloy=1;           %lower y coordinate of Roi
    CellSimProps.absx=x0;    %this is what was originally simulated
    CellSimProps.absy=y0;     %this is what was originally simulated     
    [spot_fit,spot_est,spotim, bckim]=SpotsBy_1x2DGaussFixWidth_BackgroundBy_localROI_iterative(pic,CellSimProps);             
    AllFrameData(jj).CFP.spotY=spot_fit.y0;
    AllFrameData(jj).CFP.spotX=spot_fit.x0; 
    AllFrameData(jj).CFP.spotContent=spot_fit.N0;     
    AllFrameData(jj).CFP.spotPosAngle=mod(atan2((spot_fit.y0-CcY),(spot_fit.x0-CcX)),2*pi);
    AllFrameData(jj).CFP.spotPosRadial=((spot_fit.x0-CcX).^2+ (spot_fit.y0-CcY).^2).^0.5;
    
  end
    
%----------------------------------------------
end
save(initval.PathResultName,'AllFrameData','/append');


