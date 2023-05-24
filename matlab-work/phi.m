function S_Z=phi(S_input, center, width)
S_input=S_input*ones(1,size(center,2));
error=S_input-center;
S_error=(error.^2)'*(1./width.^2);
S_Z=exp(-S_error);
end