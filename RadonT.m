% Define constants
alpha = 2;
delta = 1;

% Plot filter a
sigma = linspace(0,10);
epsilon = 1;
a = aFilter(sigma,delta,alpha,epsilon);
plot(a);