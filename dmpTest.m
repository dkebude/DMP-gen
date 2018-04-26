function result = dmpTest(r)

%% Get necessary stuff from the input struct
psi = r.psi;
w = r.w;
s = r.s;
x_goal = r.x_goal;
x_init = r.x_init;
t = r.t;
dt = r.dt;
tau = r.tau;
nbfs = r.ng;
K = r.K;
D = r.D;

%% Initialize necessary stuff
f_num = zeros(2,length(t));
f_denom = zeros(2,length(t));
f = zeros(2,length(t));
x_dmp = zeros(2,length(t));
x_dmp(:,1) = x_init;
dx_dmp = zeros(2,length(t));
ddx_dmp = zeros(2,length(t));

%% Calculate forcing function
for i = 1:length(t)
    for j = 1:nbfs
        f_num(:,i) = f_num(:,i)+psi(j,i)*w(:,j);
        f_denom(:,i) = f_denom(:,i)+psi(j,i)+0.0000001;
    end
    
    f(:,i) = (f_num(:,i).*(s(i).*(x_goal-x_init)))./f_denom(:,i);
    ddx_dmp(:,i) = (K.*(x_goal-x_dmp(:,i))-D.*tau.*dx_dmp(:,i)+f(:,i))/(tau.^2);%(tau.^2);
    
    if i ~= length(t)
        dx_dmp(:,i+1) = dx_dmp(:,i) + (ddx_dmp(:,i)*dt)/tau;
        x_dmp(:,i+1) = x_dmp(:,i) + (dx_dmp(:,i)*dt)/tau;
    end
end

result = r;
result.x_dmp = x_dmp;
result.dx_dmp = dx_dmp;
result.ddx_dmp = ddx_dmp;
result.f = f;
result.f_num = f_num;
result.f_denom = f_denom;

end

