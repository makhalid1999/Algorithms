function [theta1, theta2, theta3] = Training(data, m)
x = data(1:m,1:22);
y = data(1:m,23);
theta1 = 2*rand(14, 23)-1;
theta2 = 2*rand(7, 15)-1;
theta3 = 2*rand(1, 8)-1;
[a1, a2, a3, a4] = forward_propogation_three_layers(theta1, theta2, theta3, x, m);
J = -(1/m)*(y.'*log(a4)+(1-y).'*log(1-a4));
D1 = zeros(14, 23);
D2 = zeros(7, 15);
D3 = zeros(1, 8);
for i = 1:100
    d4 = a4 - y;
    D3 = 1/m*(d4.'*a3);
    theta3 = theta3 - 0.1*D3;
    d3 = ((d4*theta3(:,1:7)).*(a3(:,1:7).*(1-a3(:,1:7))));
    D2 = 1/m*(d3.'*a2);
    theta2 = theta2 - 0.1*D2;
    d2 = (d3*theta2(:,1:14)).*(a2(:,1:14).*(1-a2(:,1:14)));
    D1 = 1/m*(d2.'*a1);
    theta1 = theta1 - 0.1*D1;
    [a1, a2, a3, a4] = forward_propogation_three_layers(theta1, theta2, theta3, x, m);
    J = [J -(1/m)*(y.'*log(a4)+(1-y).'*log(1-a4))];
end
figure(1);
plot(J);
title("Cost Function");
xlabel("Iteration Number");
ylabel("J");
end

