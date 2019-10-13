function A = ivec(v,r); 

[n,m]=size(v);
if (m ~= 1 )
    error('Il vettore v deve essere un vettore colonna!!!');
end

if (mod(length(v),r)~=0)
    error('Il numero delle righe non e'' adatto!!!');
end

A = reshape(v,r,length(v)/r);
