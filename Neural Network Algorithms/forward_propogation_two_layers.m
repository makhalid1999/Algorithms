function [a1, a2, a3] = forward_propogation_two_layers(w1, w2,b1, b2, x, m)
    a1 = x;
    a2 = (w1*a1.').';
    a2 = a2 + b1;
    a2 = (1./(1+exp(-a2)));
    a3 = (w2*a2.').';
    a3 = a3 + b2;
    a3 = (1./(1+exp(-a3)));
end