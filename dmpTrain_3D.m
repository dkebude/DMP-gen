function r = dmpTrain_3D(traj, par)

%% Get from data struct
x = [traj.x; traj.y; traj.z];
dx = [traj.vx; traj.vy; traj.vz];
ddx = [traj.ax; traj.ay; traj.az];
x_goal = [traj.x(end); traj.y(end); traj.z(end)];
x_init = [traj.x(1); traj.y(1); traj.z(1)];
t = traj.times;
dt = diff(t);
dt = dt(1);
tau = max(t);

%% Get parameters from par struct
nbfs = par.ng;
h = par.h;
a_s = par.as;
K = par.K;
D = par.D;
s = zeros(1,length(t));
s(1) = par.s;

%% Initalizations of other necessary stuff
f_target = zeros(length(t),3);
f_target(1,:) = ((tau.^2).*ddx(:,1)-K.*(x_goal-x(:,1))+D.*tau.*dx(:,1));%./(x_goal-x_init);
s_x = zeros(length(t),3);
psi = zeros(length(h),length(t));
w = zeros(3, nbfs);

%% Calculate phase var, f_target and s_x matrix
for i = 2:length(t)
    s_dot = (-a_s*s(i-1))/tau;
    s(i) = s(i-1) + (s_dot*dt);
    
    f_target(i,:) = ((tau.^2).*ddx(:,i)-K.*(x_goal-x(:,i))+D.*tau.*dx(:,i));%./(x_goal-x_init); 
    s_x(i,:) = s(i).*(x_goal-x_init);
end

%% Calculate where gaussian centers should be located
c = linspace(max(s), min(s), nbfs);
d = diff(c);
c = c/d(1); % Normalization for exponential correctness

%% Generate gaussians
for i = 1:length(t)
    for j = 1:nbfs
        psi(j,i) = exp(-h(j)*((s(i)/d(1))-c(j)).^2);
    end
end

%% Applying regression here!
for j = 1:nbfs
    psi_x = diag(psi(j,:));
    
    w(1,j) = (s_x(:,1)'*psi_x*f_target(:,1))/(s_x(:,1)'*psi_x*s_x(:,1));
    w(2,j) = (s_x(:,2)'*psi_x*f_target(:,2))/(s_x(:,2)'*psi_x*s_x(:,2));
    w(3,j) = (s_x(:,3)'*psi_x*f_target(:,3))/(s_x(:,3)'*psi_x*s_x(:,3));
end

%% Generating output struct
r = par;
r.c = c;
r.psi = psi;
r.x = x;
r.dx = dx;
r.ddx = ddx;
r.s = s;
r.t = t;
r.dt = dt;
r.tau = tau;
r.f_target = f_target;
r.w = w;
r.x_init = x_init;
r.x_goal = x_goal;
r.d1 = d(1);

end

