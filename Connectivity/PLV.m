% this is an adaptation of the function by Matteo Fraschini 
% downloaded from https://github.com/matteogithub/Connectivity

function PLV=PLV(a)
% a is a filtered multichannel signal (time x channels)
a = a'; % Giorgio: transpose to become channels x time as more traditional data.
N=size(a,2);
PLV(1:N,1:N)=0;
complex_a=hilbert(a);
for i=1:N
    for j=1:N
        if i<j
        % note: similar to Brainstorm. I do NOT calculate abs here to
        % extract the real part. In the case of multiple epochs to be
        % averaged, I first do extract complex values, and take the absolute at the end. 
        PLV(i,j)= mean(exp(1i*(angle(complex_a(:,i))-angle(complex_a(:,j)))),1);
        PLV(j,i)=PLV(i,j);     
        end
    end
end