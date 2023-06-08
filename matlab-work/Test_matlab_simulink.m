lg=1;
while lg < size(out.x,1)
    gluonSDH.plot([out.x(lg,1),out.x(lg,4),0,0,0,0]);
    lg=lg+1;
end