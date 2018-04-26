clear all; close all; clc
data_dim = 2;

if data_dim == 2
    [x,y,vx,vy,ax,ay,nt,ttm,posu,times] = getUserTraj(0.01, 123);
    
    %f = lowpass_filter(0.1, 0.125, 1, 60);
    
    traj.x=x;%filter(f,x);
    traj.y=y;%filter(f,y);
    traj.vx=vx;%filter(f,vx);
    traj.vy=vy;%filter(f,vy);
    traj.ax=ax;%filter(f,ax);
    traj.ay=ay;%filter(f,ay);
    traj.times=times;
    
    clear x y vx vy ax ay times nt posu ttm;
    close 123
    
    % start time is initialized to zero! important for s
    traj.times=traj.times-traj.times(1);
    
    nbfs = 100;
    par=struct('ng', nbfs, 'h', ones(1,nbfs)*0.5, 's', 1, 'as', 1, 'K', 100, 'D', 100);
    
    r=dmpTrain(traj, par); 
    
    result=dmpTest(r);

    figure(1);
    plot(result.x(1,:), result.x(2,:), result.x_dmp(1,:), result.x_dmp(2,:), 'linewidth', 2);
    legend('original', 'dmp');
    
%     figure(2);
%     plot(result.t, result.f_target(:,1), result.t, result.f(1,:), 'linewidth', 2);
%     title('f_x');
%     legend('calculated', 'generated');
%     
%     figure(3);
%     plot(result.t, result.f_target(:,2), result.t, result.f(2,:), 'linewidth', 2);
%     title('f_y');
%     legend('calculated', 'generated');

elseif data_dim == 3
    [x,y,z,vx,vy,vz,ax,ay,az,times] = dataExt('Data/Jul13/Train/b3h38.txt');
    
    %f = lowpass_filter(0.1, 0.125, 1, 60);
    
    traj.x=x;
    traj.y=y;
    traj.vx=vx;%filter(f,vx);
    traj.vy=vy;%filter(f,vy);
    traj.ax=ax;%filter(f,ax);
    traj.ay=ay;%filter(f,ay);
    traj.times=times-times(1);
    traj.z = z;
    traj.vz = vz;%filter(f,vz);
    traj.az = az;%filter(f,az);
    
    clear x y z vx vy vz ax ay az times;

    nbfs = 30;
    par=struct('ng', nbfs, 'h', ones(1,nbfs)*0.5, 's', 1, 'as', 1, 'K', 10, 'D', 10);
    
    r = dmpTrain_3D(traj, par);

    result=dmpTest_3D(r);

    figure(1);
    scatter3(result.x(1,:), result.x(2,:), result.x(3,:), 'filled', 'b', 'MarkerFaceColor', 'b');
    hold on;
    scatter3(result.x_dmp(1,:), result.x_dmp(2,:), result.x_dmp(3,:),'filled', 'r', 'MarkerFaceColor', 'r');
    legend('original', 'dmp')
%     figure(2);
%     plot(result.t, result.f_target(:,1), result.t, result.f(1,:));
%     title('f_x');
%     
%     figure(3);
%     plot(result.t, result.f_target(:,2), result.t, result.f(2,:));
%     title('f_y');
%     
%     figure(4);
%     plot(result.t, result.f_target(:,3), result.t, result.f(3,:));
%     title('f_z');    
end

