function f = lowpass_filter(Fp, Fst, Ap, Ast)

d = fdesign.lowpass('Fp,Fst,Ap,Ast',Fp,Fst,Ap,Ast);
f = design(d,'equiripple');

end

