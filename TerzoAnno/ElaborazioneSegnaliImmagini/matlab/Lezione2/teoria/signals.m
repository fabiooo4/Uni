%% Basic plot
A = 1:10;
B = rand(1,10);
plot(A,B);
%%

%% Discrete stem plot
X = 0:0.02:2;
Y = 0.5*exp(2*X);
figure(1); % Opens a figure window
stem(X,Y, 'Color', 'r', 'Marker', '.');
title('Stem Plot')
xlabel('X-axis')
ylabel('Y-axis')
%%

%% Audio handling
[y, sample_rate] = audioread('../assets/400SineWave.mp3');

% Listen
sound(y(1:sample_rate*0.5,:),sample_rate);

% Plot
t = 1:size(y(1:sample_rate/2,1),1);
t = t./sample_rate;
figure;
plot(t, y(1:sample_rate/2,1));
%%

%% Record audio
r = audiorecorder(44100,16,1);
recordblocking(r,5); % records for 5 seconds
play(r);
%%

%% Image handling
%%
[i1, i1_map] = imread('../assets/trees.tif'); % Indexed image
i2 = imread('../assets/peppers.png'); % Truecolor image
[i3, i3_map] = imread('../assets/cameraman.tif'); % Grayscale image
whos i1 i1_map i2 i3 i3_map;

figure;

subplot(1,3,1);
imshow(i1, map);
title('Indexed Image');

subplot(1,3,2);
imshow(i2);
title('Truecolor Image');

subplot(1,3,3);
imshow(i3);
title('Grayscale Image');
%%
