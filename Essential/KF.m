function [x,P]=KF(x,P,z,Q,R)

P=P+Q;                 %partial update
R=chol(P+R);            %Cholesky factorization
U=P/R;                    %K=U/R'; Faster because of back substitution
x=x+U*(R'\(z-x));         %Back substitution to get state update
P=P-U*U';                   %Covariance update, U*U'=P12/R/R'*P12'=K*P12.


% The next analytical solution is more simple, but numerically less stable
%x = x + (1+Q(1,1))/(1+Q(1,1)+R(1,1))*(z-x);

%P = R(1,1)/(1+Q(1,1)+R(1,1))*(P+Q);