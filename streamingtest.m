%% MATLAB initialization
clear; close all;
set(0,'DefaultFigureWindowStyle','docked')

%% camera initial settings
imaqreset;

info = imaqhwinfo('winvideo', 1);
info.SupportedFormats

flir = videoinput('winvideo', 1, 'Y16 _160x120'); % y16 format
flir.FramesPerTrigger = Inf;

%% ready plot
frame0 = getsnapshot(flir); % initial frame
[X, Y] = meshgrid(1:size(frame0, 2), 1:size(frame0, 1)); % set mesh

figure('Name', 'Real-time FLIR Data Display', 'NumberTitle', 'off');
subplot(2, 1, 1); h_img = imagesc(frame0);    title('2D Thermal Image (imagesc)'); colorbar; axis image; % imagesc handle 
subplot(2, 1, 2); h_msh = mesh(X, -Y, frame0); title('3D Temperature Profile (mesh)'); % mesh handle

%% streaming
start(flir); % start data streaming
pause(1); % wait camera to settle

while islogging(flir)
    if flir.FramesAvailable > 0
        framenow = getdata(flir, 1); % get new frame
        
        h_img.CData = framenow; % update imagesc handle
        h_msh.ZData = framenow; % update mesh handle
        
        drawnow;
    end
end
