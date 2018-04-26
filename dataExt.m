function [ x,y,z,vx,vy,vz,ax,ay,az,times ] = dataExt( data_dir )

sin_data = false;

if sin_data == true;
    x = 0:0.01:5;
    y = sin(x);
    z = cos(x);
    times = 0:0.01:5;
else
    %% Read data
    fID = fopen(data_dir, 'r');
    A = fscanf(fID, '%d %f %f %f %f', [5 Inf]);

    len = 0;
    %% Assign x, y, z, t values from A
    for i = 1:length(A)
        if A(1,i) == 1 && (A(3,i) ~= 0 && A(4,i) ~= 0 && A(5,i) ~= 0)
            len = len + 1;
        end
    end

    %% Initialize vars
    x = zeros(1, len);
    y = zeros(1, len);
    z = zeros(1, len);
    times = zeros(1, len);

    i = 1;
    for j = 1:length(A)
        if A(1,j) == 1 && (A(3,j) ~= 0 && A(4,j) ~= 0 && A(5,j) ~= 0)
            times(i) = A(2,j);
            x(i) = A(3,j);
            y(i) = A(4,j);
            z(i) = A(5,j);
            i = i + 1;
        end
    end

    %% x, y, z normalization (to start from 0)
    x = x - x(1);
    y = y - y(1);
    z = z - z(1);
end

%% Get time step
dt = diff(times);
dt = dt(1);

%% Get velocities and accelerations
vx = [0 diff(x)/dt];
vy = [0 diff(y)/dt];
vz = [0 diff(z)/dt];
ax = [0 diff(vx)/dt];
ay = [0 diff(vy)/dt];
az = [0 diff(vz)/dt];

end

