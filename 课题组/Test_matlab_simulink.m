lg=1;
while lg < size(out.q.signals.values,1)
    gluonSDH.plot([0,0,0,out.q.signals.values(lg,1),0,out.q.signals.values(lg,2)]);
    lg=lg+1;
end