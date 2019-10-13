function a = aFilter(sigma,delta,alpha,epsilon)

if (delta == 0) 
    a = 1;
else
    
sigma = abs(sigma);
% Define functions t,y,lambda1,lambda2
t = sigma.^(2*alpha+1)./(2*pi);
y = sigma./(2*pi);
lambda1 = (2*pi)^(-2*alpha/(2*alpha+1))*1/(2*alpha+1)*(delta/sqrt(2))^(4*alpha/(2*alpha+1));
lambda2 = (2*pi)^(-2*alpha/(2*alpha+1))*2*alpha/(2*alpha+1)*(delta/sqrt(2))^(-2/(2*alpha+1));

a = zeros(1,size(sigma,2));
b = lambda2./(lambda1.*t+lambda2)+epsilon.*(sigma.^alpha).*sqrt(lambda1.*lambda2)./(lambda1.*t+lambda2).*sqrt(t.*lambda1+lambda2-y);

a(sigma<((2*pi)*lambda2)) = 1;
a(((2*pi)*lambda2)<sigma) = b(((2*pi)*lambda2)<sigma);
a(sigma>(lambda1^(-1/(2*alpha)))) = 0;

end