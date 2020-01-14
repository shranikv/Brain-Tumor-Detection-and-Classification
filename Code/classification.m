function [accuracy] = classification
% Solve a Pattern Recognition Problem with a Neural Network
% Script generated by Neural Pattern Recognition app
% Created 22-Mar-2019 00:42:39
%
% This script assumes these variables are defined:
%
%   input - input data.
%   target - target data.

input = xlsread("C:\Users\Personal\Desktop\BE Project\nnfeatures.xlsx",1,'A3:U252');
target = xlsread("C:\Users\Personal\Desktop\BE Project\nnfeatures.xlsx",1,'V3:Y252');

x = input';
t = target';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainbr';

% Create a Pattern Recognition Network
hiddenLayerSize = 10;

net = patternnet(hiddenLayerSize, trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 80/100;
%net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 20/100;

%net.trainParam.max_fail = 6;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);
accuracy = sum(tind == yind)/numel(tind);
accuracy = accuracy * 100;

% View the Network
view(net)
save('ArtificialNN');

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotroc(t,y)

