function [smth] = interate(image, xs, ys, alpha, beta, gamma, kappa, wl, we, wt, iterations)
% image: This is the image data
% xs, ys: The initial snake coordinates
% alpha: Controls tension
% beta: Controls rigidity
% gamma: Step size
% kappa: Controls enegry term
% wl, we, wt: Weights for line, edge and terminal enegy components
% iterations: No. of iteration for which snake is to be moved


%parameters
N = iterations; 
smth = image;


% Calculating size of image
[row col] = size(image);


%Computing external forces

eline = smth; %eline is simply the image intensities

[grady,gradx] = gradient(smth);
eedge = -1 * sqrt ((gradx .* gradx + grady .* grady)); %eedge is measured by gradient in the image

%masks for taking various derivatives
m1 = [-1 1];
m2 = [-1;1];
m3 = [1 -2 1];
m4 = [1;-2;1];
m5 = [1 -1;-1 1];

cx = conv2(smth,m1,'same');
cy = conv2(smth,m2,'same');
cxx = conv2(smth,m3,'same');
cyy = conv2(smth,m4,'same');
cxy = conv2(smth,m5,'same');

for i = 1:row
    for j= 1:col
        % eterm as deined in Kass et al Snakes paper
        eterm(i,j) = (cyy(i,j)*cx(i,j)*cx(i,j) -2 *cxy(i,j)*cx(i,j)*cy(i,j) + cxx(i,j)*cy(i,j)*cy(i,j))/((1+cx(i,j)*cx(i,j) + cy(i,j)*cy(i,j))^1.5);
    end
end

% imview(eterm);
% imview(abs(eedge));
eext = (wl*eline + we*eedge -wt * eterm); %eext as a weighted sum of eline, eedge and eterm

[fx, fy] = gradient(eext); %computing the gradient


%initializing the snake
xs=xs';
ys=ys';
[m n] = size(xs);
[mm nn] = size(fx);
    
%populating the penta diagonal matrix
A = zeros(m,m);
b = [(2*alpha + 6 *beta) -(alpha + 4*beta) beta];
brow = zeros(1,m);
brow(1,1:3) = brow(1,1:3) + b;
brow(1,m-1:m) = brow(1,m-1:m) + [beta -(alpha + 4*beta)]; % populating a template row
for i=1:m
    A(i,:) = brow;
    brow = circshift(brow',1)'; % Template row being rotated to egenrate different rows in pentadiagonal matrix
end

[L U] = lu(A + gamma .* eye(m,m));
Ainv = inv(U) * inv(L); % Computing Ainv using LU factorization
 
%moving the snake in each iteration
for i=1:N
    
    ssx = gamma*xs - kappa*interp2(fx,xs,ys);
    ssy = gamma*ys - kappa*interp2(fy,xs,ys);
    
    %calculating the new position of snake
    xs = Ainv * ssx;
    ys = Ainv * ssy;
    
    
    %Displaying the snake in its new position
    imshow(image,[]); 
    hold on;
    
    plot([xs; xs(1)], [ys; ys(1)], 'r-');
    hold off;
    pause(0.001)
    hold on;
    fillout([xs; xs(1)], [ys; ys(1)],[0,800,0,750],'k');
    hold off;
    
end