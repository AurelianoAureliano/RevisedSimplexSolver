A = [
    1 1;
    2 1;
];

b = [
    12;
    16;
];

c = [
    40;
    30;
];

[m, n] = size(A);

[z, x, pivalues, indices, exitflag] = rsm(A, b, c, m, n, true);

fprintf("\nTotal Cost: $%.2f\n", z)

fprintf("\nShadow Price:\n")
fprintf("%6.2f \n", [pivalues(1:m)])
